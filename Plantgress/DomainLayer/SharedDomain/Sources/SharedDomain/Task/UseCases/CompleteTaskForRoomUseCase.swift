//
//  CompleteTaskForRoomUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 19.12.2024.
//

import Foundation

/// Protocol defining the use case for completing a task for all plants in a room.
public protocol CompleteTaskForRoomUseCase {
    /// Executes the use case to complete a task for all plants in a specified room.
    /// - Parameters:
    ///   - roomId: The unique identifier of the room.
    ///   - taskType: The type of task to complete.
    ///   - completionDate: The date when the task was completed.
    /// - Throws: An error if the process fails, such as if the room is empty or the task type is not tracked.
    func execute(roomId: UUID, taskType: TaskType, completionDate: Date) async throws
}

/// Implementation of the `CompleteTaskForRoomUseCase` protocol for completing a task for all plants in a room.
public struct CompleteTaskForRoomUseCaseImpl: CompleteTaskForRoomUseCase {
    
    /// The repository for managing task-related data.
    private let taskRepository: TaskRepository
    
    /// The repository for managing plant-related data.
    private let plantRepository: PlantRepository
 
    /// Initializes a new instance of `CompleteTaskForRoomUseCaseImpl`.
    /// - Parameters:
    ///   - taskRepository: The `TaskRepository` for interacting with task-related data.
    ///   - plantRepository: The `PlantRepository` for interacting with plant-related data.
    public init(taskRepository: TaskRepository, plantRepository: PlantRepository) {
        self.taskRepository = taskRepository
        self.plantRepository = plantRepository
    }

    /// Executes the use case to complete a task for all plants in a specified room.
    /// - Parameters:
    ///   - roomId: The unique identifier of the room.
    ///   - taskType: The type of task to complete.
    ///   - completionDate: The date when the task was completed.
    /// - Throws: `RoomError.emptyRoom` if the room has no plants, or `RoomError.taskNotTracked` if the task type is not tracked for any plant.
    public func execute(roomId: UUID, taskType: TaskType, completionDate: Date) async throws {
        // Retrieve all plants in the specified room.
        let plants = try await plantRepository.getPlantsForRoom(roomId: roomId)
        
        // Check if the room has no plants.
        if plants.isEmpty {
            throw RoomError.emptyRoom
        }
        
        guard plants.contains(
            where: { plant in
                plant.settings.tasksConfigurations.contains(where: { $0.taskType == taskType && $0.isTracked })
            }
        ) else {
            throw RoomError.taskNotTracked
        }
        
        guard plants.contains(where: { plant in plant.settings.tasksConfigurations.contains(where: { $0.taskType == taskType }) }) else {
            throw RoomError.taskNotTracked
        }
        
        try await taskRepository.completeTaskForRoom(
            plants: plants,
            taskType: taskType,
            completionDate: completionDate
        )
    }
}
