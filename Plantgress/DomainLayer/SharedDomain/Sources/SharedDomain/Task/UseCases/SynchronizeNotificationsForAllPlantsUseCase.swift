//
//  SynchronizeNotificationsForAllPlantsUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 19.12.2024.
//

import Foundation

/// Protocol defining the use case for synchronizing notifications for all plants.
public protocol SynchronizeNotificationsForAllPlantsUseCase {
    /// Executes the use case to synchronize notifications for all plants.
    /// - Throws: An error if the synchronization process fails.
    func execute() async throws
}

/// Implementation of the `SynchronizeNotificationsForAllPlantsUseCase` protocol for synchronizing notifications for all plants.
public struct SynchronizeNotificationsForAllPlantsUseCaseImpl: SynchronizeNotificationsForAllPlantsUseCase {
    
    /// The repository for managing task-related data.
    private let taskRepository: TaskRepository
    
    /// The repository for managing plant-related data.
    private let plantRepository: PlantRepository

    /// Initializes a new instance of `SynchronizeNotificationsForAllPlantsUseCaseImpl`.
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

    /// Executes the use case to synchronize notifications for all plants.
    /// - Throws: An error if the synchronization process fails.
    public func execute() async throws {
        // Retrieve all plants from the repository.
        let plants = try await plantRepository.getAllPlants()
        
        // Synchronize notifications for the retrieved plants.
        try await taskRepository.synchronizeAllNotifications(for: plants)
    }
}
