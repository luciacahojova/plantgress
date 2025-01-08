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
        let plants = try await plantRepository.getPlantsForRoom(roomId: roomId)
        
        if plants.isEmpty {
            throw RoomError.emptyRoom
        }
        
        try await taskRepository.completeTaskForRoom(
            plants: plants,
            taskType: taskType,
            completionDate: completionDate
        )
    }
}
