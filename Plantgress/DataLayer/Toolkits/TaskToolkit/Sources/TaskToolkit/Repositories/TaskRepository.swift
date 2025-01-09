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

/// Implementation of the `TaskRepository` protocol for managing plant tasks, notifications, and scheduling.
public struct TaskRepositoryImpl: TaskRepository {
    
    /// Firebase Firestore provider for database operations.
    private let firebaseFirestoreProvider: FirebaseFirestoreProvider

    /// Initializes a new instance of `TaskRepositoryImpl`.
    /// - Parameter firebaseFirestoreProvider: The Firestore provider for handling database operations.
    public init(firebaseFirestoreProvider: FirebaseFirestoreProvider) {
        self.firebaseFirestoreProvider = firebaseFirestoreProvider
    }
    
    /// Retrieves the upcoming tasks for a specific plant within a specified number of days.
    /// - Parameters:
    ///   - plant: The plant for which to retrieve tasks.
    ///   - days: The range of days to include for upcoming tasks.
    /// - Returns: An array of upcoming tasks for the plant.
    public func getUpcomingTasks(for plant: Plant, days: Int) async -> [PlantTask] {
        let today = Date()
        let completedTasks = (try? await getCompletedTasks(for: plant.id)) ?? []
        let pendingNotifications = await getPendingNotifications()
        var tasks: [PlantTask] = []

        for taskConfig in plant.settings.tasksConfigurations where (taskConfig.isTracked && taskConfig.hasNotifications) {
            var currentDueDate = completedTasks
                .filter { $0.taskType == taskConfig.taskType }
                .map { $0.completionDate ?? $0.dueDate }
                .max() ?? taskConfig.startDate
            
            while currentDueDate <= today {
                var newDueDate = calculateNextDueDate(
                    startDate: currentDueDate,
                    startTime: taskConfig.time,
                    interval: findClosestPeriod(startDate: currentDueDate, periods: taskConfig.periods)?.interval ?? .daily(interval: 1)
                )
                
                if completedTasks.contains(
                    where: { $0.taskType == taskConfig.taskType && Calendar.current.isDate($0.completionDate ?? currentDueDate, inSameDayAs: newDueDate) }
                ) {
                    
                    newDueDate = calculateNextDueDate(
                        startDate: newDueDate,
                        startTime: taskConfig.time,
                        interval: findClosestPeriod(startDate: newDueDate, periods: taskConfig.periods)?.interval ?? .daily(interval: 1)
                    )
                }
                currentDueDate = newDueDate
            }
            
            let plantTask = createPlantTask(plant: plant, taskType: taskConfig.taskType, dueDate: currentDueDate)
            tasks.append(plantTask)
        }

        return tasks.sorted { $0.dueDate < $1.dueDate }
    }
    
    /// Finds the closest task period to the specified start date.
    /// - Parameters:
    ///   - startDate: The start date to compare against task periods.
    ///   - periods: A list of task periods to evaluate.
    /// - Returns: The closest task period, or `nil` if none is found.
    private func findClosestPeriod(startDate: Date, periods: [TaskPeriod]) -> TaskPeriod? {
        var closestPeriod: TaskPeriod?
        var minimumInterval: TimeInterval = .greatestFiniteMagnitude

        for period in periods {
            let nextDate = calculateNextDate(for: period.interval, startDate: startDate)
            let timeInterval = nextDate.timeIntervalSince(startDate)

            // Ensure the date is in the future and is the closest one
            if timeInterval >= 0 && timeInterval < minimumInterval {
                minimumInterval = timeInterval
                closestPeriod = period
            }
        }

        return closestPeriod
    }
    
    /// Creates a new `PlantTask` object.
    /// - Parameters:
    ///   - plant: The plant associated with the task.
    ///   - taskType: The type of the task.
    ///   - dueDate: The due date of the task.
    /// - Returns: The created `PlantTask` object.
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

    /// Retrieves upcoming tasks for multiple plants within a specified number of days.
    /// - Parameters:
    ///   - plants: A list of plants for which to retrieve tasks.
    ///   - days: The range of days to include for upcoming tasks.
    /// - Returns: An array of upcoming tasks for all plants.
    public func getUpcomingTasks(for plants: [Plant], days: Int) async -> [PlantTask] {
        var allUpcomingTasks: [PlantTask] = []

        for plant in plants {
            await allUpcomingTasks.append(contentsOf: getUpcomingTasks(for: plant, days: days))
        }

        return allUpcomingTasks.sorted { $0.dueDate < $1.dueDate }
    }

    /// Retrieves all completed tasks for a specific plant.
    /// - Parameter plantId: The ID of the plant.
    /// - Returns: A sorted array of completed tasks.
    /// - Throws: An error if the operation fails.
    public func getCompletedTasks(for plantId: UUID) async throws -> [PlantTask] {
        return try await firebaseFirestoreProvider.getAll(
            path: DatabaseConstants.taskPath(plantId: plantId.uuidString),
            as: PlantTask.self
        ).sorted { ($0.completionDate ?? $0.dueDate) > ($1.completionDate  ?? $0.dueDate) }
    }
    
    /// Retrieves all completed tasks for multiple plants.
    /// - Parameter plantIds: A list of plant IDs.
    /// - Returns: A sorted array of completed tasks for the plants.
    /// - Throws: An error if the operation fails.
    public func getCompletedTasks(for plantIds: [UUID]) async throws -> [PlantTask] {
        var allCompletedTasks: [PlantTask] = []

        for plantId in plantIds {
            let completedTasks = try await getCompletedTasks(for: plantId)
            allCompletedTasks.append(contentsOf: completedTasks)
        }

        return allCompletedTasks.sorted { ($0.completionDate ?? $0.dueDate) > ($1.completionDate  ?? $0.dueDate) }
    }
    
    /// Deletes a specific task for a plant.
    /// - Parameters:
    ///   - task: The task to delete.
    ///   - plant: The plant associated with the task.
    /// - Throws: An error if the deletion fails.
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
    
    /// Deletes the last completed task of a specific type for a plant.
    /// - Parameters:
    ///   - plant: The plant associated with the task.
    ///   - taskType: The type of task to delete.
    /// - Throws: An error if the operation fails.
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
    
    /// Marks a task as completed for a plant and schedules the next occurrence.
    /// - Parameters:
    ///   - plant: The plant associated with the task.
    ///   - taskType: The type of task to complete.
    ///   - dueDate: The due date of the task. Defaults to the nearest due date.
    ///   - completionDate: The completion date of the task.
    /// - Throws: An error if the operation fails.
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
        guard let taskConfig = plant.settings.tasksConfigurations.first(where: { $0.taskType == taskType }) else {
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
            .map { calculateNextDueDate(startDate: completionDate, startTime: taskConfig.time, interval: $0.interval) }
            .min()

        while let dueDate = nextDueDate,
              completedTasks.contains(where: { $0.taskType == taskType && $0.dueDate == dueDate }) {
            nextDueDate = calculateNextDueDate(
                startDate: dueDate,
                startTime: taskConfig.time,
                interval: findClosestPeriod(startDate: dueDate, periods: taskConfig.periods)?.interval ?? .daily(interval: 1)
            )
        }

        // Schedule the next notification if a valid due date is found
        if let nextDueDate {
            updateNotification(id: notificationId, dueDate: nextDueDate, taskConfig: taskConfig, plant: plant)
        } else {
            print("⚠️ No valid future due dates found for \(taskType.rawValue). No notification scheduled.")
        }
    }
    
    /// Marks a task as completed for all plants in a room.
    /// - Parameters:
    ///   - plants: A list of plants in the room.
    ///   - taskType: The type of task to complete.
    ///   - completionDate: The completion date of the task.
    /// - Throws: An error if the operation fails.
    public func completeTaskForRoom(
        plants: [Plant],
        taskType: TaskType,
        completionDate: Date
    ) async throws {
        // Iterate over the plants in the room
        for plant in plants {
            // Check if the task type is tracked for the plant
            guard plant.settings.tasksConfigurations.contains(where: { $0.taskType == taskType && $0.isTracked }) else {
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
    
    /// Deletes all tasks for a specific plant.
    /// - Parameter plantId: The ID of the plant.
    public func deleteAllTasks(for plantId: UUID) {
        print("🗑️ Deleting tasks for plant: (\(plantId))")
        
        var notificationIds: [String] = []
        
        for taskType in TaskType.allCases {
            notificationIds.append(generateNotificationId(plantId: plantId, taskType: taskType))
        }

        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: notificationIds)
        
        removeTaskConfigurationFromUserDefaults(for: plantId)
    }
    
    /// Synchronizes all notifications for multiple plants.
    /// - Parameter plants: A list of plants for which to synchronize notifications.
    /// - Throws: An error if the synchronization fails.
    public func synchronizeAllNotifications(for plants: [Plant]) async throws {
        for plant in plants {
            try await synchronizeNotifications(for: plant)
        }
        
        await printPendingNotifications()
    }

    /// Synchronizes notifications for a specific plant.
    /// - Parameter plant: The plant for which to synchronize notifications.
    /// - Throws: An error if the synchronization fails.
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

        for taskConfig in plant.settings.tasksConfigurations where taskConfig.isTracked && taskConfig.hasNotifications {
            var nextDueDate = taskConfig.periods
                .map { calculateNextDueDate(startDate: taskConfig.startDate, startTime: taskConfig.time, interval: $0.interval) }
                .min()

            while let dueDate = nextDueDate,
                  (completedTasks.contains { $0.taskType == taskConfig.taskType && Calendar.current.isDate($0.dueDate, inSameDayAs: dueDate) } ||
                   pendingNotifications.contains { notification in
                       guard let notificationTaskType = notification.content.userInfo["taskType"] as? String,
                             let notificationDueDate = (notification.trigger as? UNCalendarNotificationTrigger)?.nextTriggerDate(),
                             notificationTaskType == taskConfig.taskType.rawValue
                       else { return false }
                       return notificationDueDate == dueDate
                   }) {
                nextDueDate = calculateNextDueDate(
                    startDate: dueDate,
                    startTime: taskConfig.time,
                    interval: findClosestPeriod(startDate: dueDate, periods: taskConfig.periods)!.interval
                )
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
    
    /// Initializes notifications for a newly added plant.
    /// - Parameter plant: The plant for which to initialize notifications.
    /// - Throws: An error if the initialization fails.
    public func initializeNotifications(for plant: Plant) async throws {
        print("🔄 Initializing notifications for new plant: \(plant.name) (\(plant.id))")
        
        for taskConfig in plant.settings.tasksConfigurations where taskConfig.isTracked && taskConfig.hasNotifications {
            // Calculate the next due date for the task type
            let nextDueDate = taskConfig.periods
                .map { calculateNextDueDate(startDate: taskConfig.startDate, startTime: taskConfig.time, interval: $0.interval) }
                .min() // Get the earliest due date

            if let nextDueDate = nextDueDate {
                let notificationId = generateNotificationId(plantId: plant.id, taskType: taskConfig.taskType)
                print("📅 Adding notification for \(taskConfig.taskType.rawValue): \(nextDueDate)")
                updateNotification(id: notificationId, dueDate: nextDueDate, taskConfig: taskConfig, plant: plant)
                updateNotification(id: notificationId, dueDate: nextDueDate, taskConfig: taskConfig, plant: plant)
            } else {
                print("⚠️ No valid due dates for \(taskConfig.taskType.rawValue), skipping notification.")
            }
        }
        
        try saveTaskConfiguration(for: plant)
    }

    /// Schedules the next notification for a plant task.
    /// - Parameters:
    ///   - plant: The plant associated with the task.
    ///   - taskType: The type of task to schedule.
    ///   - dueDate: The next due date for the task.
    ///   - completionDate: The completion date of the task.
    /// - Throws: An error if the scheduling fails.
    public func scheduleNextNotification(for plant: Plant, taskType: TaskType, dueDate: Date, completionDate: Date) async throws {
        // Find the task configuration for the given task type
        guard let taskConfig = plant.settings.tasksConfigurations.first(where: { $0.taskType == taskType }) else {
            throw TaskError.taskTypeNotFound
        }

        // Calculate the next due date based on the task's interval
        guard let nextDueDate = taskConfig.periods
            .map({ calculateNextDueDate(startDate: completionDate, startTime: taskConfig.time, interval: $0.interval) })
            .min() else { return }

        // Generate the notification ID
        let notificationId = generateNotificationId(plantId: plant.id, taskType: taskType)

        // Schedule the notification
        updateNotification(id: notificationId, dueDate: nextDueDate, taskConfig: taskConfig, plant: plant)
    }
    
    private func calculateNextDate(for interval: TaskInterval, startDate: Date) -> Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        
        switch interval {
        case .daily(let interval):
            return calendar.date(byAdding: .day, value: interval, to: startDate) ?? startDate
            
        case .weekly(let interval, let weekday):
            let currentWeekday = calendar.component(.weekday, from: startDate)
            var daysToAdd = (weekday - currentWeekday + 7) % 7
            daysToAdd += (daysToAdd == 0 ? interval : interval - 1) * 7
            
            return calendar.date(byAdding: .day, value: daysToAdd, to: startDate) ?? startDate
            
        case .monthly(let interval, let months):
            let currentMonth = calendar.component(.month, from: startDate)
            
            var nextMonth = currentMonth
            
            let sortedMonths = months.sorted()
            
            while !sortedMonths.contains(nextMonth) {
                nextMonth = (nextMonth % 12)
                nextMonth += 1
            }
            
            let monthIncrement = (nextMonth - currentMonth + 12) % 12
            
            if nextMonth == currentMonth {
                return calendar.date(byAdding: .day, value: interval, to: startDate) ?? startDate
            }
            
            let incrementedDate = calendar.date(byAdding: .month, value: monthIncrement, to: startDate) ?? startDate
            
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month, .hour, .minute, .second, .nanosecond], from: incrementedDate))
            
            return startOfMonth ?? startDate
            
        case .yearly(let date):
            let components = DateComponents(year: calendar.component(.year, from: startDate), month: date.month, day: date.day)
            var nextDate = calendar.date(from: components) ?? startDate
            if nextDate < startDate {
                nextDate = calendar.date(byAdding: .year, value: 1, to: nextDate) ?? startDate
            }
            return nextDate
        }
    }
    
    private func calculateNextDueDate(startDate: Date, startTime: Date, interval: TaskInterval) -> Date {
        let calendar = Calendar.current
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: startDate)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: startTime)
        var combinedComponents = todayComponents
        combinedComponents.hour = timeComponents.hour
        combinedComponents.minute = timeComponents.minute
        
        switch interval {
        case .daily(let interval):
            return calendar.date(byAdding: .day, value: interval, to: startDate)!
            
        case .weekly(let interval, let weekday):
            let currentWeekday = calendar.component(.weekday, from: startDate)
            var daysToAdd = (weekday - currentWeekday + 7) % 7
            daysToAdd += (daysToAdd == 0 ? interval : interval - 1) * 7
            
            guard let date = calendar.date(from: combinedComponents),
                  let dueDate = calendar.date(byAdding: .day, value: daysToAdd, to: date) else {
                return calendar.date(byAdding: .day, value: daysToAdd, to: startDate) ?? startDate
            }
            return dueDate
            
        case .monthly(let interval, let months):
            let startMonth = calendar.component(.month, from: startDate)
            var nextMonth = startMonth
            
            let sortedMonths = months.sorted()
            
            while !sortedMonths.contains(nextMonth) {
                nextMonth = (nextMonth % 12)
                nextMonth += 1
            }
            
            if nextMonth == startMonth {
                combinedComponents.day = interval + (combinedComponents.day ?? 1)
            } else {
                combinedComponents.month = nextMonth
                combinedComponents.day = 1
            }
            
            return calendar.date(from: combinedComponents) ?? startDate
            
        case .yearly(let date):
            return calendar.nextDate(
                after: startDate,
                matching: DateComponents(
                    month: date.month,
                    day: date.day,
                    hour: combinedComponents.hour,
                    minute: combinedComponents.minute
                ),
                matchingPolicy: .nextTime
            ) ?? startDate
        }
    }
    
    private func cleanUpStaleNotifications(for plant: Plant) async throws {
        let currentNotificationIds = await getPendingNotificationIds()

        // Filter pending notifications to those related to the plant
        let plantNotificationIds = currentNotificationIds.filter { $0.contains(plant.id.uuidString) }

        let validNotificationIds = plant.settings.tasksConfigurations.map { taskConfig in
            generateNotificationId(plantId: plant.id, taskType: taskConfig.taskType)
        }

        for notificationId in plantNotificationIds where !validNotificationIds.contains(notificationId) {
            removeNotification(id: notificationId)
        }
    }

    private func updateNotification(id: String, dueDate: Date, taskConfig: TaskConfiguration, plant: Plant) {
        let calendar = Calendar.current
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: taskConfig.time)
        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
        dateComponents.hour = timeComponents.hour
        dateComponents.minute = timeComponents.minute
        dateComponents.second = timeComponents.second
        
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
        content.title = "Task Reminder"
        content.body = "\(plantTask.plantName) requires care!"
        content.sound = .default
        content.userInfo = userInfo

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❗️Failed to schedule notification: \(error.localizedDescription)")
            } else {
                print("✅ Notification scheduled with ID: \(id), to \(dateComponents)")
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
        let data = try JSONEncoder().encode(plant.settings.tasksConfigurations)
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
        return storedConfig != plant.settings.tasksConfigurations
    }
}
