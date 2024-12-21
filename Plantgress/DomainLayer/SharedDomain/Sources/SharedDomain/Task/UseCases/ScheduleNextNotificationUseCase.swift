//
//  ScheduleNextNotificationUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 21.12.2024.
//

import Foundation

public protocol ScheduleNextNotificationUseCase {
    func execute(notificationId: String) async throws
}

public struct ScheduleNextNotificationUseCaseImpl: ScheduleNextNotificationUseCase {
    
    private let taskRepository: TaskRepository
    private let plantRepository: PlantRepository

    public init(
        taskRepository: TaskRepository,
        plantRepository: PlantRepository
    ) {
        self.taskRepository = taskRepository
        self.plantRepository = plantRepository
    }

    public func execute(notificationId: String) async throws {
        // Parse the notification ID
        let components = notificationId.split(separator: "_")
        guard components.count == 2,
              let plantId = UUID(uuidString: String(components[0])),
              let taskType = TaskType(rawValue: String(components[1])) else {
            throw TaskError.invalidNotificationId
        }

        // Fetch the plant from the database
        let plant = try await plantRepository.getPlant(id: plantId)
        
        try await taskRepository.scheduleNextNotification(
            for: plant,
            taskType: taskType,
            completionDate: Date()
        )
    }
}
