//
//  GetUpcomingTasksForPlantUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 19.12.2024.
//

import Foundation

/// Protocol defining the use case for retrieving upcoming tasks for a specific plant.
public protocol GetUpcomingTasksForPlantUseCase {
    /// Executes the use case to retrieve upcoming tasks for a specific plant.
    /// - Parameters:
    ///   - plant: The `Plant` object for which to retrieve tasks.
    ///   - days: The number of days to look ahead for upcoming tasks.
    /// - Returns: An array of `PlantTask` objects representing the upcoming tasks.
    func execute(for plant: Plant, days: Int) async -> [PlantTask]
}

/// Implementation of the `GetUpcomingTasksForPlantUseCase` protocol for retrieving upcoming tasks for a specific plant.
public struct GetUpcomingTasksForPlantUseCaseImpl: GetUpcomingTasksForPlantUseCase {
    
    /// The repository for managing task-related data.
    private let taskRepository: TaskRepository

    /// Initializes a new instance of `GetUpcomingTasksForPlantUseCaseImpl`.
    /// - Parameter taskRepository: The `TaskRepository` for interacting with task-related data.
    public init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }

    /// Executes the use case to retrieve upcoming tasks for a specific plant.
    /// - Parameters:
    ///   - plant: The `Plant` object for which to retrieve tasks.
    ///   - days: The number of days to look ahead for upcoming tasks.
    /// - Returns: An array of `PlantTask` objects representing the upcoming tasks.
    public func execute(for plant: Plant, days: Int) async -> [PlantTask] {
        // Use the repository to fetch upcoming tasks for the specified plant.
        await taskRepository.getUpcomingTasks(for: plant, days: days)
    }
}
