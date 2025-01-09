//
//  GetCompletedTasksForPlantUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 19.12.2024.
//

import Foundation

/// Protocol defining the use case for retrieving completed tasks for a specific plant.
public protocol GetCompletedTasksForPlantUseCase {
    /// Executes the use case to retrieve all completed tasks for a specific plant.
    /// - Parameter plantId: The unique identifier of the plant.
    /// - Returns: An array of `PlantTask` objects representing the completed tasks.
    /// - Throws: An error if the retrieval process fails.
    func execute(for plantId: UUID) async throws -> [PlantTask]
}

/// Implementation of the `GetCompletedTasksForPlantUseCase` protocol for retrieving completed tasks for a specific plant.
public struct GetCompletedTasksForPlantUseCaseImpl: GetCompletedTasksForPlantUseCase {
    
    /// The repository for managing task-related data.
    private let taskRepository: TaskRepository

    /// Initializes a new instance of `GetCompletedTasksForPlantUseCaseImpl`.
    /// - Parameter taskRepository: The `TaskRepository` for interacting with task-related data.
    public init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }

    /// Executes the use case to retrieve all completed tasks for a specific plant.
    /// - Parameter plantId: The unique identifier of the plant.
    /// - Returns: An array of `PlantTask` objects representing the completed tasks.
    /// - Throws: An error if the retrieval process fails.
    public func execute(for plantId: UUID) async throws -> [PlantTask] {
        // Use the repository to fetch completed tasks for the specified plant.
        try await taskRepository.getCompletedTasks(for: plantId)
    }
}
