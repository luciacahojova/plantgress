//
//  DeleteTaskUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 19.12.2024.
//

import Foundation

/// Protocol defining the use case for deleting a plant task.
public protocol DeleteTaskUseCase {
    /// Executes the use case to delete a specific task associated with a plant.
    /// - Parameter task: The `PlantTask` object representing the task to delete.
    /// - Throws: An error if the task deletion process fails.
    func execute(task: PlantTask) async throws
}

/// Implementation of the `DeleteTaskUseCase` protocol for deleting a plant task.
public struct DeleteTaskUseCaseImpl: DeleteTaskUseCase {
    
    /// The repository for managing task-related data.
    private let taskRepository: TaskRepository
    
    /// The repository for managing plant-related data.
    private let plantRepository: PlantRepository

    /// Initializes a new instance of `DeleteTaskUseCaseImpl`.
    /// - Parameters:
    ///   - taskRepository: The `TaskRepository` for interacting with task-related data.
    ///   - plantRepository: The `PlantRepository` for interacting with plant-related data.
    public init(
        taskRepository: TaskRepository,
        plantRepository: PlantRepository
    ) {
        self.taskRepository = taskRepository
        self.plantRepository = plantRepository
    }

    /// Executes the use case to delete a specific task associated with a plant.
    /// - Parameter task: The `PlantTask` object representing the task to delete.
    /// - Throws: An error if the task deletion process fails.
    public func execute(task: PlantTask) async throws {
        // Retrieve the plant associated with the task.
        let plant = try await plantRepository.getPlant(id: task.plantId)
        
        // Use the task repository to delete the specified task.
        try await taskRepository.deleteTask(task, plant: plant)
    }
}
