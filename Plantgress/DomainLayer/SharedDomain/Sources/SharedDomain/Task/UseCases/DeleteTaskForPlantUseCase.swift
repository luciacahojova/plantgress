//
//  DeleteTaskForPlantUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 21.12.2024.
//

import Foundation

/// Protocol defining the use case for deleting a specific task type for a plant.
public protocol DeleteTaskForPlantUseCase {
    /// Executes the use case to delete a specific task type for a plant.
    /// - Parameters:
    ///   - plant: The `Plant` object associated with the task.
    ///   - taskType: The type of task to delete.
    /// - Throws: An error if the deletion process fails.
    func execute(plant: Plant, taskType: TaskType) async throws
}

/// Implementation of the `DeleteTaskForPlantUseCase` protocol for deleting a specific task type for a plant.
public struct DeleteTaskForPlantUseCaseImpl: DeleteTaskForPlantUseCase {
    
    /// The repository for managing task-related data.
    private let taskRepository: TaskRepository

    /// Initializes a new instance of `DeleteTaskForPlantUseCaseImpl`.
    /// - Parameter taskRepository: The `TaskRepository` for interacting with task-related data.
    public init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }

    /// Executes the use case to delete a specific task type for a plant.
    /// - Parameters:
    ///   - plant: The `Plant` object associated with the task.
    ///   - taskType: The type of task to delete.
    /// - Throws: An error if the deletion process fails.
    public func execute(plant: Plant, taskType: TaskType) async throws {
        // Use the repository to delete the specified task type for the plant.
        try await taskRepository.deleteTask(for: plant, taskType: taskType)
    }
}
