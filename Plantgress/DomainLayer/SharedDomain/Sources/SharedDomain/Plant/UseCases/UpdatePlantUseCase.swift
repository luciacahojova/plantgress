//
//  UpdatePlantUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

/// Protocol defining the use case for updating an existing plant.
public protocol UpdatePlantUseCase {
    /// Executes the use case to update an existing plant.
    /// - Parameter plant: The `Plant` object containing the updated data.
    /// - Throws: An error if the update process fails.
    func execute(plant: Plant) async throws
}

/// Implementation of the `UpdatePlantUseCase` protocol for updating an existing plant.
public struct UpdatePlantUseCaseImpl: UpdatePlantUseCase {
    
    /// The repository for managing plant data.
    private let plantRepository: PlantRepository
    
    /// The repository for managing room data.
    private let roomRepository: RoomRepository
    
    /// The repository for managing task data.
    private let taskRepository: TaskRepository
    
    /// Initializes a new instance of `UpdatePlantUseCaseImpl`.
    /// - Parameters:
    ///   - plantRepository: The `PlantRepository` for interacting with plant data.
    ///   - roomRepository: The `RoomRepository` for interacting with room data.
    ///   - taskRepository: The `TaskRepository` for managing task data.
    public init(
        plantRepository: PlantRepository,
        roomRepository: RoomRepository,
        taskRepository: TaskRepository
    ) {
        self.plantRepository = plantRepository
        self.roomRepository = roomRepository
        self.taskRepository = taskRepository
    }
    
    /// Executes the use case to update an existing plant.
    /// - Parameter plant: The `Plant` object containing the updated data.
    /// - Throws: An error if the update process or any related updates fail.
    public func execute(plant: Plant) async throws {
        // Update the plant in the plant repository.
        try await plantRepository.updatePlant(plant)
        
        // Synchronize task notifications for the updated plant.
        try await taskRepository.synchronizeNotifications(for: plant)
        
        // If the plant is associated with a room, update the room's data.
        guard let roomId = plant.roomId else { return }
        try await roomRepository.addPlantToRoom(roomId: roomId, plantId: plant.id)
    }
}
