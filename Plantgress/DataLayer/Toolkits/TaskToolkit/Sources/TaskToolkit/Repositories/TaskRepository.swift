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

public struct TaskRepositoryImpl: TaskRepository { // TODO: Add updating settings
    private let firebaseFirestoreProvider: FirebaseFirestoreProvider

    public init(firebaseFirestoreProvider: FirebaseFirestoreProvider) {
        self.firebaseFirestoreProvider = firebaseFirestoreProvider
    }
    
    public func getUpcomingTasks(for plant: Plant, days: Int) -> [PlantTask] {
        let now = Date()
        let endDate = Calendar.current.date(byAdding: .day, value: days, to: now)!

        var upcomingTasks: [PlantTask] = []

        for taskConfig in plant.settings.tasksConfiguartions where taskConfig.isTracked {
            let nextDueDates = taskConfig.periods.compactMap {
                calculateNextDueDate(startDate: taskConfig.startDate, interval: $0.interval)
            }.filter { $0 <= endDate && $0 >= now }

            upcomingTasks.append(contentsOf: nextDueDates.map { dueDate in
                PlantTask(
                    id: UUID(),
                    plantId: plant.id,
                    plantName: plant.name,
                    imageUrl: plant.images.first?.urlString ?? "",
                    taskType: taskConfig.taskType,
                    dueDate: dueDate,
                    completionDate: nil,
                    isCompleted: false
                )
            })
        }

        return upcomingTasks.sorted { $0.dueDate < $1.dueDate }
    }

    public func getUpcomingTasks(for plants: [Plant], days: Int) -> [PlantTask] {
        var allUpcomingTasks: [PlantTask] = []

        for plant in plants {
            allUpcomingTasks.append(contentsOf: getUpcomingTasks(for: plant, days: days))
        }

        return allUpcomingTasks.sorted { $0.dueDate < $1.dueDate }
    }

    public func getCompletedTasks(for plantId: UUID) async throws -> [PlantTask] {
        return try await firebaseFirestoreProvider.getAll(
            path: DatabaseConstants.taskPath(plantId: plantId.uuidString),
            as: PlantTask.self
        )
    }

    public func getCompletedTasks(for plantIds: [UUID]) async throws -> [PlantTask] {
        var allCompletedTasks: [PlantTask] = []

        for plantId in plantIds {
            let completedTasks = try await getCompletedTasks(for: plantId)
            allCompletedTasks.append(contentsOf: completedTasks)
        }

        return allCompletedTasks
    }
    
    public func deleteTask(_ task: PlantTask) async throws {
        if task.isCompleted {
            // Delete the completed task from Firestore
            try await firebaseFirestoreProvider.delete(
                path: DatabaseConstants.taskPath(plantId: task.plantId.uuidString),
                id: task.id.uuidString
            )
            print("✅ Completed task deleted from Firestore for task: \(task.id)")
        } else {
            // Remove the notification for the upcoming task
            let notificationId = generateNotificationId(
                plantId: task.plantId,
                taskType: task.taskType
            )
            removeNotification(id: notificationId)
            print("✅ Upcoming task notification removed for: \(notificationId)")
        }
    }
    
    public func completeTask(for plant: Plant, taskType: TaskType, completionDate: Date) async throws {
        // Find the task configuration for the given task type
        guard let taskConfig = plant.settings.tasksConfiguartions.first(where: { $0.taskType == taskType }) else {
            throw TaskError.taskTypeNotFound
        }

        // Remove the existing notification for this task
        let notificationId = generateNotificationId(plantId: plant.id, taskType: taskType)
        removeNotification(id: notificationId)

        // Store the completed task in Firestore
        let completedTask = PlantTask(
            id: UUID(),
            plantId: plant.id,
            plantName: plant.name,
            imageUrl: plant.images.first?.urlString ?? "",
            taskType: taskType,
            dueDate: completionDate,
            completionDate: completionDate,
            isCompleted: true
        )
        
        try await firebaseFirestoreProvider.create(
            path: DatabaseConstants.taskPath(plantId: plant.id.uuidString),
            id: completedTask.id.uuidString,
            data: completedTask
        )
        
        // Find the next due date across all periods for this task type
        guard let nextDueDate = taskConfig.periods
            .map({ calculateNextDueDate(startDate: taskConfig.startDate, interval: $0.interval) })
            .min() else { return }
        
        updateNotification(id: notificationId, dueDate: nextDueDate)
    }
    
    public func deleteNotifications(for plantId: UUID) {
        print("🗑️ Deleting notifications for plant: (\(plantId))")
        
        var notificationIds: [String] = []
        
        for taskType in TaskType.allCases {
            notificationIds.append(generateNotificationId(plantId: plantId, taskType: taskType))
        }

        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: notificationIds)
    }
    
    public func synchronizeAllNotifications(for plants: [Plant]) async throws {
        for plant in plants {
            try await synchronizeNotifications(for: plant)
        }
        
        await printPendingNotifications()
    }

    public func synchronizeNotifications(for plant: Plant) async throws {
        print("🔄 Synchronizing notifications for plant: \(plant.name) (\(plant.id))")
        
        // Iterate through each tracked task configuration
        for taskConfig in plant.settings.tasksConfiguartions
            where (taskConfig.isTracked && taskConfig.hasNotifications) {
            
            // Find the next due date across all periods for this task type
            let nextDueDate = taskConfig.periods
                .map { calculateNextDueDate(startDate: taskConfig.startDate, interval: $0.interval) }
                .min() // Get the earliest due date

            if let nextDueDate = nextDueDate {
                let notificationId = generateNotificationId(plantId: plant.id, taskType: taskConfig.taskType)
                print("📅 Next due date for \(taskConfig.taskType.rawValue): \(nextDueDate)")
                
                updateNotification(id: notificationId, dueDate: nextDueDate)
            } else {
                print("⚠️ No upcoming due dates found for \(taskConfig.taskType.rawValue)")
            }
        }

        // Clean up stale notifications specific to this plant
        try await cleanUpStaleNotifications(for: plant)
    }

    public func scheduleNextNotification(for plant: Plant, taskType: TaskType, completionDate: Date) async throws {
        // Find the task configuration for the given task type
        guard let taskConfig = plant.settings.tasksConfiguartions.first(where: { $0.taskType == taskType }) else {
            throw TaskError.taskTypeNotFound
        }

        // Calculate the next due date based on the task's interval
        guard let nextDueDate = taskConfig.periods
            .map({ calculateNextDueDate(startDate: completionDate, interval: $0.interval) })
            .min() else { return }

        // Generate the notification ID
        let notificationId = generateNotificationId(plantId: plant.id, taskType: taskType)

        // Schedule the notification
        updateNotification(id: notificationId, dueDate: nextDueDate)
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
        case .monthly(_, let months):
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

        // Filter pending notifications to those related to the plant
        let plantNotificationIds = currentNotificationIds.filter { $0.contains(plant.id.uuidString) }

        let validNotificationIds = plant.settings.tasksConfiguartions.map { taskConfig in
            generateNotificationId(plantId: plant.id, taskType: taskConfig.taskType)
        }

        for notificationId in plantNotificationIds where !validNotificationIds.contains(notificationId) {
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

        // Remove existing notification before adding the updated one
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❗️Failed to update notification: \(error.localizedDescription)")
            }
        }
    }

    private func removeNotification(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }

    private func getPendingNotificationIds() async -> [String] {
        let requests = await UNUserNotificationCenter.current().pendingNotificationRequests()
        return requests.map { $0.identifier }
    }

    private func generateNotificationId(plantId: UUID, taskType: TaskType) -> String {
        return "\(plantId.uuidString)_\(taskType.rawValue)"
    }
    
    private func printPendingNotifications() async {
        let requests = await UNUserNotificationCenter.current().pendingNotificationRequests()
        for request in requests {
            print("""
            🔔 Notification: \(request.identifier)
            Title: \(request.content.title)
            Body: \(request.content.body)
            Due Date: \(String(describing: (request.trigger as? UNCalendarNotificationTrigger)?.nextTriggerDate()))
            """)
        }
    }
}
