//
//  DeleteTaskForRoomUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 21.12.2024.
//

import Foundation

/// Protocol defining the use case for deleting a specific task type for all plants in a room.
public protocol DeleteTaskForRoomUseCase {
    /// Executes the use case to delete a specific task type for all plants in the specified room.
    /// - Parameters:
    ///   - roomId: The unique identifier of the room.
    ///   - taskType: The type of task to delete.
    /// - Throws: An error if the deletion process fails.
    func execute(roomId: UUID, taskType: TaskType) async throws
}

/// Implementation of the `DeleteTaskForRoomUseCase` protocol for deleting a specific task type for all plants in a room.
public struct DeleteTaskForRoomUseCaseImpl: DeleteTaskForRoomUseCase {
    
    /// The repository for managing task-related data.
    private let taskRepository: TaskRepository
    
    /// The repository for managing plant-related data.
    private let plantRepository: PlantRepository

    /// Initializes a new instance of `DeleteTaskForRoomUseCaseImpl`.
    /// - Parameters:
    ///   - taskRepository: The `TaskRepository` for interacting with task-related data.
    ///   - plantRepository: The `PlantRepository` for interacting with plant-related data.
    public init(taskRepository: TaskRepository, plantRepository: PlantRepository) {
        self.taskRepository = taskRepository
        self.plantRepository = plantRepository
    }

    /// Executes the use case to delete a specific task type for all plants in the specified room.
    /// - Parameters:
    ///   - roomId: The unique identifier of the room.
    ///   - taskType: The type of task to delete.
    /// - Throws: An error if the deletion process fails.
    public func execute(roomId: UUID, taskType: TaskType) async throws {
        // Retrieve all plants in the specified room.
        let plants = try await plantRepository.getPlantsForRoom(roomId: roomId)

        // Iterate over each plant and delete the specified task type.
        for plant in plants {
            try await taskRepository.deleteTask(for: plant, taskType: taskType)
        }
    }
}
