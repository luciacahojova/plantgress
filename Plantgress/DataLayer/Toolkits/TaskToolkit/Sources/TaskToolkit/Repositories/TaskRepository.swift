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
    
    public func getUpcomingTasks(for plant: Plant, days: Int) async -> [PlantTask] {
        let now = Date()
        let endDate = Calendar.current.date(byAdding: .day, value: days, to: now)!

        let completedTasks = (try? await getCompletedTasks(for: plant.id)) ?? []
        let pendingNotifications = await getPendingNotifications()
        var tasks: [PlantTask] = []

        for taskConfig in plant.settings.tasksConfiguartions where taskConfig.isTracked {
            let lastCompletedDate = completedTasks
                .filter { $0.taskType == taskConfig.taskType }
                .map { $0.completionDate ?? $0.dueDate }
                .max() ?? taskConfig.startDate

            var currentDueDate = lastCompletedDate
            while true {
                currentDueDate = calculateNextDueDate(
                    startDate: currentDueDate,
                    interval: taskConfig.periods.first?.interval ?? .daily(interval: 1)
                )

                // Check if the task is already completed
                if completedTasks.contains(where: { $0.taskType == taskConfig.taskType && $0.dueDate == currentDueDate }) {
                    continue
                }

                // Check if this due date already has a pending notification
                if pendingNotifications.contains(where: { notification in
                    guard let notificationDueDateString = notification.content.userInfo["dueDate"] as? String,
                          let notificationDueDate = ISO8601DateFormatter().date(from: notificationDueDateString),
                          notificationDueDate == currentDueDate else {
                        return false
                    }
                    return true
                }) {
                    continue
                }
                
                let plantTask = createPlantTask(plant: plant, taskType: taskConfig.taskType, dueDate: currentDueDate)
                tasks.append(plantTask)
                
                break
            }
        }

        return tasks.sorted { $0.dueDate < $1.dueDate }
    }
    
    private func createPlantTask(plant: Plant, taskType: TaskType, dueDate: Date) -> PlantTask {
        PlantTask(
            id: UUID(),
            plantId: plant.id,
            plantName: plant.name,
            imageUrl: plant.images.first?.urlString ?? "",
            taskType: taskType,
            dueDate: dueDate,
            completionDate: nil,
            isCompleted: false
        )
    }

    public func getUpcomingTasks(for plants: [Plant], days: Int) async -> [PlantTask] {
        var allUpcomingTasks: [PlantTask] = []

        for plant in plants {
            await allUpcomingTasks.append(contentsOf: getUpcomingTasks(for: plant, days: days))
        }

        return allUpcomingTasks.sorted { $0.dueDate < $1.dueDate }
    }

    public func getCompletedTasks(for plantId: UUID) async throws -> [PlantTask] {
        return try await firebaseFirestoreProvider.getAll(
            path: DatabaseConstants.taskPath(plantId: plantId.uuidString),
            as: PlantTask.self
        ).sorted { ($0.completionDate ?? $0.dueDate) > ($1.completionDate  ?? $0.dueDate) }
    }

    public func getCompletedTasks(for plantIds: [UUID]) async throws -> [PlantTask] {
        var allCompletedTasks: [PlantTask] = []

        for plantId in plantIds {
            let completedTasks = try await getCompletedTasks(for: plantId)
            allCompletedTasks.append(contentsOf: completedTasks)
        }

        return allCompletedTasks.sorted { ($0.completionDate ?? $0.dueDate) > ($1.completionDate  ?? $0.dueDate) }
    }
    
    public func deleteTask(_ task: PlantTask, plant: Plant) async throws {
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
            try await scheduleNextNotification(
                for: plant,
                taskType: task.taskType,
                dueDate: task.dueDate,
                completionDate: Date()
            )
            print("✅ Upcoming task notification removed for: \(notificationId)")
        }
    }
    
    public func deleteTask(for plant: Plant, taskType: TaskType) async throws {
        let completedTasks = try await getCompletedTasks(for: plant.id)
        
        if let lastTask = completedTasks.filter({ $0.taskType == taskType }).last {
            try await firebaseFirestoreProvider.delete(
                path: DatabaseConstants.taskPath(plantId: plant.id.uuidString),
                id: lastTask.id.uuidString
            )
            print("✅ Deleted last completed task of type \(taskType) for plant \(plant.id)")
        }
    }
    
    public func completeTask(for plant: Plant, taskType: TaskType, dueDate: Date?, completionDate: Date) async throws {
        let pendingNotifications = await getPendingNotifications()
        guard let notificationDueDate = (
            dueDate ?? pendingNotifications
                .compactMap { notification -> Date? in
                    guard let dueDateString = notification.content.userInfo["dueDate"] as? String else {
                        return nil
                    }
                    return ISO8601DateFormatter().date(from: dueDateString)
                }
                .first
        ) else {
            throw TaskError.missingDueDate
        }
        
        // Find the task configuration for the given task type
        guard let taskConfig = plant.settings.tasksConfiguartions.first(where: { $0.taskType == taskType }) else {
            throw TaskError.taskTypeNotFound
        }

        // Remove the existing notification for this task
        let notificationId = generateNotificationId(plantId: plant.id, taskType: taskType)
        removeNotification(id: notificationId)
        
        // Fetch all completed tasks for the plant
        let completedTasks = try await getCompletedTasks(for: plant.id)

        // Store the completed task in Firestore
        let completedTask = PlantTask(
            id: UUID(),
            plantId: plant.id,
            plantName: plant.name,
            imageUrl: plant.images.first?.urlString ?? "",
            taskType: taskType,
            dueDate: notificationDueDate,
            completionDate: completionDate,
            isCompleted: true
        )
        
        try await firebaseFirestoreProvider.create(
            path: DatabaseConstants.taskPath(plantId: plant.id.uuidString),
            id: completedTask.id.uuidString,
            data: completedTask
        )

        // Find the next due date that hasn't been completed yet
        var nextDueDate = taskConfig.periods
            .map { calculateNextDueDate(startDate: completionDate, interval: $0.interval) }
            .min()

        while let dueDate = nextDueDate,
              completedTasks.contains(where: { $0.taskType == taskType && $0.dueDate == dueDate }) {
            nextDueDate = calculateNextDueDate(startDate: dueDate, interval: taskConfig.periods.first!.interval)
        }

        // Schedule the next notification if a valid due date is found
        if let nextDueDate {
            updateNotification(id: notificationId, dueDate: nextDueDate, taskConfig: taskConfig, plant: plant)
        } else {
            print("⚠️ No valid future due dates found for \(taskType.rawValue). No notification scheduled.")
        }
    }
    
    public func completeTaskForRoom(
        plants: [Plant],
        taskType: TaskType,
        completionDate: Date
    ) async throws {
        // Iterate over the plants in the room
        for plant in plants {
            // Check if the task type is tracked for the plant
            guard plant.settings.tasksConfiguartions.contains(where: { $0.taskType == taskType && $0.isTracked }) else {
                continue
            }
            
            // Determine the current due date from pending notifications
            let pendingNotifications = await getPendingNotifications()
            let dueDate = pendingNotifications
                .compactMap { notification -> Date? in
                    guard let dueDateString = notification.content.userInfo["dueDate"] as? String else {
                        return nil
                    }
                    return ISO8601DateFormatter().date(from: dueDateString)
                }
                .first

            // Proceed to complete the task
            try await completeTask(
                for: plant,
                taskType: taskType,
                dueDate: dueDate ?? completionDate, // Use the provided completionDate if dueDate is not available
                completionDate: completionDate
            )
        }
    }
    
    public func deleteAllTasks(for plantId: UUID) {
        print("🗑️ Deleting tasks for plant: (\(plantId))")
        
        var notificationIds: [String] = []
        
        for taskType in TaskType.allCases {
            notificationIds.append(generateNotificationId(plantId: plantId, taskType: taskType))
        }

        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: notificationIds)
        
        removeTaskConfigurationFromUserDefaults(for: plantId)
    }
    
    public func synchronizeAllNotifications(for plants: [Plant]) async throws {
        for plant in plants {
            try await synchronizeNotifications(for: plant)
        }
        
        await printPendingNotifications()
    }

    public func synchronizeNotifications(for plant: Plant) async throws {
        print("🔄 Synchronizing notifications for plant: \(plant.name) (\(plant.id))")
        
        if !hasTaskConfigurationChanged(for: plant) {
            print("✅ Task configuration unchanged. Skipping notification update.")
            return
        }
        
        print("⚠️ Task configuration changed. Updating notifications.")
        
        // Proceed with existing synchronization logic
        let completedTasks = try await getCompletedTasks(for: plant.id)
        let pendingNotifications = await getPendingNotifications()

        for taskConfig in plant.settings.tasksConfiguartions where taskConfig.isTracked && taskConfig.hasNotifications {
            var nextDueDate = taskConfig.periods
                .map { calculateNextDueDate(startDate: taskConfig.startDate, interval: $0.interval) }
                .min()

            while let dueDate = nextDueDate,
                  (completedTasks.contains { $0.taskType == taskConfig.taskType && $0.dueDate == dueDate } ||
                   pendingNotifications.contains { notification in
                       guard let notificationTaskType = notification.content.userInfo["taskType"] as? String,
                             let notificationDueDate = (notification.trigger as? UNCalendarNotificationTrigger)?.nextTriggerDate(),
                             notificationTaskType == taskConfig.taskType.rawValue
                       else { return false }
                       return notificationDueDate == dueDate
                   }) {
                nextDueDate = calculateNextDueDate(startDate: dueDate, interval: taskConfig.periods.first!.interval)
            }

            if let nextDueDate = nextDueDate {
                let notificationId = generateNotificationId(plantId: plant.id, taskType: taskConfig.taskType)
                updateNotification(id: notificationId, dueDate: nextDueDate, taskConfig: taskConfig, plant: plant)
            }
        }

        try await cleanUpStaleNotifications(for: plant)

        // Store the updated configuration
        try saveTaskConfiguration(for: plant)
    }
    
    public func initializeNotifications(for plant: Plant) async throws {
        print("🔄 Initializing notifications for new plant: \(plant.name) (\(plant.id))")
        
        for taskConfig in plant.settings.tasksConfiguartions where taskConfig.isTracked && taskConfig.hasNotifications {
            // Calculate the next due date for the task type
            let nextDueDate = taskConfig.periods
                .map { calculateNextDueDate(startDate: taskConfig.startDate, interval: $0.interval) }
                .min() // Get the earliest due date

            if let nextDueDate = nextDueDate {
                let notificationId = generateNotificationId(plantId: plant.id, taskType: taskConfig.taskType)
                print("📅 Adding notification for \(taskConfig.taskType.rawValue): \(nextDueDate)")
                updateNotification(id: notificationId, dueDate: nextDueDate, taskConfig: taskConfig, plant: plant)
            } else {
                print("⚠️ No valid due dates for \(taskConfig.taskType.rawValue), skipping notification.")
            }
        }
        
        try saveTaskConfiguration(for: plant)
    }

    public func scheduleNextNotification(for plant: Plant, taskType: TaskType, dueDate: Date, completionDate: Date) async throws {
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
        updateNotification(id: notificationId, dueDate: nextDueDate, taskConfig: taskConfig, plant: plant)
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
        case .yearly(let date):
            return calendar.nextDate(after: startDate, matching: DateComponents(month: date.month, day: date.day), matchingPolicy: .nextTime) ?? startDate
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

    private func updateNotification(id: String, dueDate: Date, taskConfig: TaskConfiguration, plant: Plant) {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
        
        removeNotification(id: id)

        // Construct a PlantTask object to include all relevant details
        let plantTask = PlantTask(
            id: UUID(),
            plantId: plant.id,
            plantName: plant.name,
            imageUrl: plant.images.first?.urlString ?? "",
            taskType: taskConfig.taskType,
            dueDate: dueDate,
            completionDate: nil,
            isCompleted: false
        )

        // Manually construct the userInfo dictionary
        let dateFormatter = ISO8601DateFormatter()
        let userInfo: [String: Any] = [
            "id": plantTask.id.uuidString,
            "plantId": plantTask.plantId.uuidString,
            "plantName": plantTask.plantName,
            "imageUrl": plantTask.imageUrl,
            "taskType": plantTask.taskType.rawValue,
            "dueDate": dateFormatter.string(from: plantTask.dueDate),
            "completionDate": "",
            "isCompleted": plantTask.isCompleted
        ]

        let content = UNMutableNotificationContent()
        content.title = "Reminder: \(plantTask.taskType.rawValue)"
        content.body = "\(plantTask.plantName) requires \(plantTask.taskType.rawValue)"
        content.sound = .default
        content.userInfo = userInfo

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❗️Failed to schedule notification: \(error.localizedDescription)")
            } else {
                print("✅ Notification scheduled with ID: \(id)")
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
    
    private func getPendingNotifications() async -> [UNNotificationRequest] {
        await UNUserNotificationCenter.current().pendingNotificationRequests()
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
    
    private func saveTaskConfiguration(for plant: Plant) throws {
        let data = try JSONEncoder().encode(plant.settings.tasksConfiguartions)
        UserDefaults.standard.set(data, forKey: "taskConfig_\(plant.id.uuidString)")
    }

    private func getStoredTaskConfiguration(for plantId: UUID) -> [TaskConfiguration]? {
        guard let data = UserDefaults.standard.data(forKey: "taskConfig_\(plantId.uuidString)") else {
            return nil
        }
        return try? JSONDecoder().decode([TaskConfiguration].self, from: data)
    }
    
    private func removeTaskConfigurationFromUserDefaults(for plantId: UUID) {
        let userDefaultsKey = "taskConfig_\(plantId.uuidString)"
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
    
    private func hasTaskConfigurationChanged(for plant: Plant) -> Bool {
        guard let storedConfig = getStoredTaskConfiguration(for: plant.id) else {
            return true // No stored configuration, consider it changed
        }
        return storedConfig != plant.settings.tasksConfiguartions
    }
}
