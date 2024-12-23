//
//  ScheduleNextNotificationUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 21.12.2024.
//

import Foundation

public protocol ScheduleNextNotificationUseCase {
    func execute(plantId: UUID, taskType: TaskType, dueDate: Date) async throws
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

    public func execute(plantId: UUID, taskType: TaskType, dueDate: Date) async throws {
        // Fetch the plant from the database
        let plant = try await plantRepository.getPlant(id: plantId)
        
        try await taskRepository.scheduleNextNotification(
            for: plant,
            taskType: taskType,
            dueDate: dueDate,
            completionDate: Date()
        )
    }
}
