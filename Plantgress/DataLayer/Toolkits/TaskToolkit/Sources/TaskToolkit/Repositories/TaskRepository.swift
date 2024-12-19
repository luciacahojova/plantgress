//
//  TaskRepository.swift
//  TaskToolkit
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import FirebaseFirestoreProvider
import Foundation
import SharedDomain
import UserNotifications
import Utilities

public struct TaskRepositoryImpl: TaskRepository {
    
    private let firebaseFirestoreProvider: FirebaseFirestoreProvider

    public init(firebaseFirestoreProvider: FirebaseFirestoreProvider) {
        self.firebaseFirestoreProvider = firebaseFirestoreProvider
    }

    public func completeTask(for plant: Plant, taskType: TaskType, completionDate: Date) async throws {
        // Find the task configuration
        guard let taskConfig = plant.settings.tasksConfiguartions.first(where: { $0.taskType == taskType }) else {
            throw TaskError.taskTypeNotFound
        }

        // Determine the ongoing period
        let ongoingPeriod = taskConfig.periods.first(where: { isInPeriod(completionDate, interval: $0.interval) })
        
        if let period = ongoingPeriod {
            // Remove the outdated notification for the completed task
            let completedNotificationId = generateNotificationId(plantId: plant.id, taskType: taskType, periodId: period.id)
            removeNotification(id: completedNotificationId)

            // Calculate and update the next due date for this period
            let nextDueDate = calculateNextDueDate(startDate: completionDate, interval: period.interval)
            updateNotification(id: completedNotificationId, dueDate: nextDueDate)
        }

        // Store the completed task in Firestore
        let completedTask = PlantTask(
            id: UUID(),
            plantId: plant.id,
            plantName: plant.name,
            imageUrl: plant.images.first?.urlString ?? "",
            taskType: taskType,
            dueDate: completionDate,
            isCompleted: true
        )
        
        try await firebaseFirestoreProvider.create(
            path: DatabaseConstants.taskPath(plantId: plant.id.uuidString),
            id: completedTask.id.uuidString,
            data: completedTask
        )
    }


    public func getUpcomingTasks(for plant: Plant, days: Int) -> [PlantTask] {
        return calculateTasks(for: plant, days: days).sorted { $0.dueDate < $1.dueDate }
    }

    public func getUpcomingTasks(for plants: [Plant], days: Int) -> [PlantTask] {
        var allTasks: [PlantTask] = []
        
        for plant in plants {
            allTasks.append(contentsOf: calculateTasks(for: plant, days: days))
        }
        
        return allTasks.sorted { $0.dueDate < $1.dueDate }
    }

    public func getCompletedTasks(for plantId: UUID) async throws -> [PlantTask] {
        try await firebaseFirestoreProvider.getAll(
            path: DatabaseConstants.taskPath(plantId: plantId.uuidString),
            as: PlantTask.self
        )
    }

    public func getCompletedTasks(for plantIds: [UUID]) async throws -> [PlantTask] {
        var allTasks: [PlantTask] = []
        
        for plantId in plantIds {
            let plantTasks = try await firebaseFirestoreProvider.getAll(
                path: DatabaseConstants.taskPath(plantId: plantId.uuidString),
                as: PlantTask.self
            )
            
            allTasks.append(contentsOf: plantTasks)
        }
        
        return allTasks
    }

    public func synchronizeNotifications(for plant: Plant) async throws {
        // Synchronize progress notifications
        for taskConfig in plant.settings.tasksConfiguartions where taskConfig.isTracked {
            for period in taskConfig.periods {
                let nextDueDate = calculateNextDueDate(startDate: taskConfig.startDate, interval: period.interval)
                let notificationId = generateNotificationId(plantId: plant.id, taskType: taskConfig.taskType, periodId: period.id)
                updateNotification(id: notificationId, dueDate: nextDueDate)
            }
        }
        try await cleanUpStaleNotifications(for: plant)
    }

    public func synchronizeAllNotifications(for plants: [Plant]) async throws {
        for plant in plants {
            try await synchronizeNotifications(for: plant)
        }
    }

    private func fetchPlant(plantId: UUID) async throws -> Plant {
        try await firebaseFirestoreProvider.get(
            path: DatabaseConstants.plantPath(plantId: plantId.uuidString),
            id: plantId.uuidString,
            as: Plant.self
        )
    }

    private func calculateTasks(for plant: Plant, days: Int) -> [PlantTask] {
        let now = Date()
        let endDate = Calendar.current.date(byAdding: .day, value: days, to: now)!

        var tasks: [PlantTask] = []

        for taskConfig in plant.settings.tasksConfiguartions where taskConfig.isTracked {
            for period in taskConfig.periods {
                let dueDates = calculateDueDates(startDate: taskConfig.startDate, interval: period.interval, endDate: endDate)
                tasks.append(contentsOf: dueDates.map {
                    PlantTask(
                        id: UUID(),
                        plantId: plant.id,
                        plantName: plant.name,
                        imageUrl: plant.images.first?.urlString ?? "",
                        taskType: taskConfig.taskType,
                        dueDate: $0,
                        isCompleted: false
                    )
                })
            }
        }

        return tasks
    }

    private func calculateDueDates(startDate: Date, interval: TaskInterval, endDate: Date) -> [Date] {
        var dueDates: [Date] = []
        var currentDate = startDate

        while currentDate <= endDate {
            dueDates.append(currentDate)
            currentDate = calculateNextDueDate(startDate: currentDate, interval: interval)
        }

        return dueDates
    }

    private func calculateNextDueDate(startDate: Date, interval: TaskInterval) -> Date {
        let calendar = Calendar.current
        switch interval {
        case .daily(let interval):
            return calendar.date(byAdding: .day, value: interval, to: startDate)!
            
        case .weekly(let interval, let weekday):
            let weekdayComponent = DateComponents(weekday: weekday)
            let nextWeek = calendar.date(byAdding: .weekOfYear, value: interval, to: startDate)!
            return calendar.nextDate(after: nextWeek, matching: weekdayComponent, matchingPolicy: .nextTime) ?? nextWeek
            
        case .monthly(let interval, let months):
            return months.compactMap {
                calendar.nextDate(after: startDate, matching: DateComponents(month: $0), matchingPolicy: .nextTime)
            }.first ?? startDate
            
        case .yearly(let dates):
            return dates.compactMap {
                calendar.nextDate(after: startDate, matching: DateComponents(month: $0.month, day: $0.day), matchingPolicy: .nextTime)
            }.first ?? startDate
        }
    }

    private func cleanUpStaleNotifications(for plant: Plant) async throws {
        let currentNotificationIds = await getPendingNotificationIds()
        
        let validNotificationIds = plant.settings.tasksConfiguartions.flatMap { taskConfig in
            taskConfig.periods.map { period in
                generateNotificationId(plantId: plant.id, taskType: taskConfig.taskType, periodId: period.id)
            }
        }

        for notificationId in currentNotificationIds where !validNotificationIds.contains(notificationId) {
            removeNotification(id: notificationId)
        }
    }

    private func updateNotification(id: String, dueDate: Date) {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)

        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = "You have a task scheduled."
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❗️Failed to schedule notification: \(error.localizedDescription)")
            }
        }
    }

    private func removeNotification(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }

    private func getPendingNotificationIds() async -> [String] {
        let requests = await UNUserNotificationCenter.current().pendingNotificationRequests()
        
        print("⏳ Pending notifications: \(requests.map { $0.identifier })")
        return requests.map { $0.identifier }
    }

    private func generateNotificationId(plantId: UUID, taskType: TaskType, periodId: UUID) -> String {
        return "\(plantId.uuidString)_\(taskType.rawValue)_\(periodId.uuidString)"
    }
    
    private func isInPeriod(_ date: Date, interval: TaskInterval) -> Bool {
        let calendar = Calendar.current

        switch interval {
        case .daily:
            return true
        case .monthly(let interval, let months):
            let currentMonth = calendar.component(.month, from: date)
            return months.contains(currentMonth)
        case .yearly, .weekly:
            return false
        }
    }
}
