//
//  CreatePlantUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

/// Protocol defining the use case for creating a new plant.
public protocol CreatePlantUseCase {
    /// Executes the use case to create a new plant.
    /// - Parameter plant: The `Plant` object to be created.
    /// - Throws: An error if the creation process fails.
    func execute(plant: Plant) async throws
}

/// Implementation of the `CreatePlantUseCase` protocol for creating a new plant.
public struct CreatePlantUseCaseImpl: CreatePlantUseCase {
    
    /// The repository for managing plant data.
    private let plantRepository: PlantRepository
    
    /// The repository for managing room data.
    private let roomRepository: RoomRepository
    
    /// The repository for managing task data.
    private let taskRepository: TaskRepository
    
    /// Initializes a new instance of `CreatePlantUseCaseImpl`.
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
    
    /// Executes the use case to create a new plant.
    /// - Parameter plant: The `Plant` object to be created.
    /// - Throws: An error if the creation process or any related updates fail.
    public func execute(plant: Plant) async throws {
        // Save the plant in the plant repository.
        try await plantRepository.createPlant(plant)
        
        // Initialize notifications for tasks associated with the plant.
        try await taskRepository.initializeNotifications(for: plant)
        
        // If the plant is associated with a room, update the room's data.
        guard let roomId = plant.roomId else { return }
        try await roomRepository.addPlantToRoom(roomId: roomId, plantId: plant.id)
        try await roomRepository.updateRoomPreviewImages(roomId: roomId)
    }
}
