//
//  DeleteTaskForRoomUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 21.12.2024.
//

import Foundation

public protocol DeleteTaskForRoomUseCase {
    func execute(roomId: UUID, taskType: TaskType) async throws
}

public struct DeleteTaskForRoomUseCaseImpl: DeleteTaskForRoomUseCase {
    
    private let taskRepository: TaskRepository
    private let plantRepository: PlantRepository

    public init(taskRepository: TaskRepository, plantRepository: PlantRepository) {
        self.taskRepository = taskRepository
        self.plantRepository = plantRepository
    }

    public func execute(roomId: UUID, taskType: TaskType) async throws {
        let plants = try await plantRepository.getPlantsForRoom(roomId: roomId)

        for plant in plants {
            try await taskRepository.deleteTask(for: plant, taskType: taskType)
        }
    }
}
