//
//  CompleteTaskUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 19.12.2024.
//

import Foundation

/// Protocol defining the use case for completing a task for a plant.
public protocol CompleteTaskUseCase {
    /// Executes the use case to complete a task for a specific plant.
    /// - Parameters:
    ///   - plant: The `Plant` object for which the task is being completed.
    ///   - taskType: The type of task being completed.
    ///   - completionDate: The date when the task was completed.
    /// - Throws: An error if the task completion process fails.
    func execute(for plant: Plant, taskType: TaskType, completionDate: Date) async throws
}

/// Implementation of the `CompleteTaskUseCase` protocol for completing a task for a plant.
public struct CompleteTaskUseCaseImpl: CompleteTaskUseCase {
    
    /// The repository for managing task-related data.
    private let taskRepository: TaskRepository

    /// Initializes a new instance of `CompleteTaskUseCaseImpl`.
    /// - Parameter taskRepository: The `TaskRepository` for interacting with task-related data.
    public init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }

    /// Executes the use case to complete a task for a specific plant.
    /// - Parameters:
    ///   - plant: The `Plant` object for which the task is being completed.
    ///   - taskType: The type of task being completed.
    ///   - completionDate: The date when the task was completed.
    /// - Throws: An error if the task completion process fails.
    public func execute(for plant: Plant, taskType: TaskType, completionDate: Date) async throws {
        // Use the repository to mark the task as completed.
        try await taskRepository.completeTask(
            for: plant,
            taskType: taskType,
            dueDate: nil,
            completionDate: completionDate
        )
    }
}
