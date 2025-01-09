//
//  GetUpcomingTasksForAllPlantsUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 19.12.2024.
//

import Foundation

/// Protocol defining the use case for retrieving upcoming tasks for all plants.
public protocol GetUpcomingTasksForAllPlantsUseCase {
    /// Executes the use case to retrieve upcoming tasks for the specified plants within a given time frame.
    /// - Parameters:
    ///   - plants: An array of `Plant` objects for which to retrieve tasks.
    ///   - days: The number of days to look ahead for upcoming tasks.
    /// - Returns: An array of `PlantTask` objects representing the upcoming tasks.
    func execute(for plants: [Plant], days: Int) async -> [PlantTask]
}

/// Implementation of the `GetUpcomingTasksForAllPlantsUseCase` protocol for retrieving upcoming tasks for all plants.
public struct GetUpcomingTasksForAllPlantsUseCaseImpl: GetUpcomingTasksForAllPlantsUseCase {
    
    /// The repository for managing task-related data.
    private let taskRepository: TaskRepository

    /// Initializes a new instance of `GetUpcomingTasksForAllPlantsUseCaseImpl`.
    /// - Parameter taskRepository: The `TaskRepository` for interacting with task-related data.
    public init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }

    /// Executes the use case to retrieve upcoming tasks for the specified plants within a given time frame.
    /// - Parameters:
    ///   - plants: An array of `Plant` objects for which to retrieve tasks.
    ///   - days: The number of days to look ahead for upcoming tasks.
    /// - Returns: An array of `PlantTask` objects representing the upcoming tasks.
    public func execute(for plants: [Plant], days: Int) async -> [PlantTask] {
        // Use the repository to fetch upcoming tasks for the plants.
        await taskRepository.getUpcomingTasks(for: plants, days: days)
    }
}
