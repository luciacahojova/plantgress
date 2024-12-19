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

public struct TaskRepositoryImpl: TaskRepository {
    
    public init() {}

    // MARK: - Synchronize Notifications for All Plants
    public func synchronizeAllNotifications(for plants: [Plant]) async throws {
        for plant in plants {
            try await synchronizeNotifications(for: plant)
        }
    }

    // MARK: - Synchronize Notifications for a Single Plant
    public func synchronizeNotifications(for plant: Plant) async throws {
        // Handle Progress Tracking Notifications
        if plant.settings.progressTracking.isTracked && plant.settings.progressTracking.hasAlert {
            try synchronizeProgressNotification(for: plant)
        }

        // Handle Task Notifications
        for taskConfig in plant.settings.tasksConfiguartions where taskConfig.isTracked {
            for period in taskConfig.periods {
                try synchronizeTaskNotification(for: plant, taskConfig: taskConfig, period: period)
            }
        }

        // Remove stale notifications (notifications no longer valid)
        try await cleanUpStaleNotifications(for: plant)
    }

    // MARK: - Complete Task
    public func completeTask(for plant: Plant, taskType: TaskType, periodId: UUID, completionDate: Date) async throws {
        guard let taskConfig = plant.settings.tasksConfiguartions.first(where: { $0.taskType == taskType }),
              let period = taskConfig.periods.first(where: { $0.id == periodId }) else {
            throw TaskError.taskOrPeriodNotFound
        }

        // Calculate the next due date
        let nextDueDate = calculateNextDueDate(startDate: completionDate, interval: period.interval)

        // Update notification for this period
        let notificationId = generateNotificationId(plantId: plant.id, taskType: taskType, periodId: period.id)
        updateNotification(id: notificationId, dueDate: nextDueDate)

        // Recalculate all other periods for this task type
        for otherPeriod in taskConfig.periods where otherPeriod.id != period.id {
            let recalculatedDate = calculateNextDueDate(startDate: completionDate, interval: otherPeriod.interval)
            let otherNotificationId = generateNotificationId(plantId: plant.id, taskType: taskType, periodId: otherPeriod.id)
            updateNotification(id: otherNotificationId, dueDate: recalculatedDate)
        }
    }

    // MARK: - Get Upcoming Tasks
    public func getUpcomingTasks(for plants: [Plant], days: Int) -> [PlantTask] {
        var allTasks: [PlantTask] = []
        for plant in plants {
            let plantTasks = getUpcomingTasks(for: plant, days: days)
            
            allTasks.append(contentsOf: plantTasks)
        }
        return allTasks
    }

    public func getUpcomingTasks(for plant: Plant, days: Int) -> [PlantTask] {
        let calendar = Calendar.current
        let now = Date()
        let endDate = calendar.date(byAdding: .day, value: days, to: now)!

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
    
    public func getUpcomingProgressTasks(for plants: [Plant], days: Int) -> [ProgressTask] {
        var allProgressTasks: [ProgressTask] = []
        for plant in plants {
            let plantProgressTasks = getUpcomingProgressTasks(for: plant, days: days)
            allProgressTasks.append(contentsOf: plantProgressTasks)
        }
        return allProgressTasks
    }
    
    public func getUpcomingProgressTasks(for plant: Plant, days: Int) -> [ProgressTask] {
        let calendar = Calendar.current
        let now = Date()
        let endDate = calendar.date(byAdding: .day, value: days, to: now)!

        var progressTasks: [ProgressTask] = []

        if plant.settings.progressTracking.isTracked {
            let dueDates = calculateDueDates(startDate: plant.settings.progressTracking.startDate, interval: plant.settings.progressTracking.interval, endDate: endDate)

            progressTasks.append(contentsOf: dueDates.map {
                ProgressTask(
                    id: UUID(),
                    plantId: plant.id,
                    plantName: plant.name,
                    imageUrl: plant.images.first?.urlString ?? "",
                    dueDate: $0,
                    isCompleted: false
                )
            })
        }

        return progressTasks
    }


    // MARK: - Private Helper Methods

    private func synchronizeProgressNotification(for plant: Plant) throws {
        let progressConfig = plant.settings.progressTracking
        let notificationId = "\(plant.id.uuidString)_progressTracking"
        let nextDate = calculateNextDueDate(startDate: progressConfig.startDate, interval: progressConfig.interval)
        updateNotification(id: notificationId, dueDate: nextDate)
    }

    private func synchronizeTaskNotification(for plant: Plant, taskConfig: TaskConfiguration, period: TaskPeriod) throws {
        let notificationId = generateNotificationId(plantId: plant.id, taskType: taskConfig.taskType, periodId: period.id)
        let nextDate = calculateNextDueDate(startDate: taskConfig.startDate, interval: period.interval)
        updateNotification(id: notificationId, dueDate: nextDate)
    }

    private func cleanUpStaleNotifications(for plant: Plant) async throws {
        let currentNotificationIds = await getPendingNotificationIds()
        
        let validNotificationIds = plant.settings.tasksConfiguartions.flatMap { taskConfig in
            taskConfig.periods.map { period in
                generateNotificationId(plantId: plant.id, taskType: taskConfig.taskType, periodId: period.id)
            }
        } + ["\(plant.id.uuidString)_progressTracking"]

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

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to update notification: \(error.localizedDescription)")
            } else {
                print("🟢 Notification updated: \(id)")
            }
        }
    }

    private func removeNotification(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        print("🟢 Notification removed: \(id)")
    }

    private func getPendingNotificationIds() async -> [String] {
        let requests = await UNUserNotificationCenter.current().pendingNotificationRequests()
        return requests.map { $0.identifier }
    }

    private func generateNotificationId(plantId: UUID, taskType: TaskType, periodId: UUID) -> String {
        return "\(plantId.uuidString)_\(taskType.rawValue)_\(periodId.uuidString)"
    }

    private func calculateNextDueDate(startDate: Date, interval: TaskInterval) -> Date {
        let calendar = Calendar.current
        var nextDate = startDate

        switch interval {
        case .daily(let interval):
            nextDate = calendar.date(byAdding: .day, value: interval, to: startDate)!
        case .weekly(let interval, let weekdays):
            let weekdayComponents = weekdays.map { DateComponents(weekday: $0) }
            nextDate = weekdayComponents
                .compactMap { calendar.nextDate(after: startDate, matching: $0, matchingPolicy: .nextTime) }
                .first ?? startDate
        case .monthly(let interval, let months):
            nextDate = months.compactMap {
                calendar.nextDate(after: startDate, matching: DateComponents(month: $0), matchingPolicy: .nextTime)
            }.first ?? startDate
        case .yearly(let dates):
            nextDate = dates.compactMap {
                calendar.nextDate(after: startDate, matching: DateComponents(month: $0.month, day: $0.day), matchingPolicy: .nextTime)
            }.first ?? startDate
        }

        return nextDate
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
}
