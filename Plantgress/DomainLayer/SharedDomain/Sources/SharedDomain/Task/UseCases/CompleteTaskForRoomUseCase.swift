//
//  CompleteTaskForRoomUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 19.12.2024.
//

import Foundation

public protocol CompleteTaskForRoomUseCase {
    func execute(roomId: UUID, taskType: TaskType, completionDate: Date) async throws
}

public struct CompleteTaskForRoomUseCaseImpl: CompleteTaskForRoomUseCase {
    private let taskRepository: TaskRepository
    private let plantRepository: PlantRepository

    public init(taskRepository: TaskRepository, plantRepository: PlantRepository) {
        self.taskRepository = taskRepository
        self.plantRepository = plantRepository
    }

    public func execute(roomId: UUID, taskType: TaskType, completionDate: Date) async throws {
        // Fetch all plants in the room
        let plants = try await plantRepository.getPlantsForRoom(roomId: roomId)

        // Complete the task for each plant
        for plant in plants {
            try await taskRepository.completeTask(for: plant, taskType: taskType, completionDate: completionDate)
        }
    }
}
