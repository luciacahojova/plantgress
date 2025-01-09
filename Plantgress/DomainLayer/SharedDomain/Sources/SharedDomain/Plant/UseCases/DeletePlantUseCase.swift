//
//  DeletePlantUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

/// Protocol defining the use case for deleting a plant.
public protocol DeletePlantUseCase {
    /// Executes the use case to delete a plant by its unique identifier.
    /// - Parameters:
    ///   - plantId: The unique identifier of the plant to delete.
    ///   - roomId: The unique identifier of the room associated with the plant, if any.
    /// - Throws: An error if the deletion process fails.
    func execute(plantId: UUID, roomId: UUID?) async throws
}

/// Implementation of the `DeletePlantUseCase` protocol for deleting a plant.
public struct DeletePlantUseCaseImpl: DeletePlantUseCase {
    
    /// The repository for managing plant data.
    private let plantRepository: PlantRepository
    
    /// The repository for managing room data.
    private let roomRepository: RoomRepository
    
    /// The repository for managing task data.
    private let taskRepository: TaskRepository
    
    /// Initializes a new instance of `DeletePlantUseCaseImpl`.
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
    
    /// Executes the use case to delete a plant by its unique identifier.
    /// - Parameters:
    ///   - plantId: The unique identifier of the plant to delete.
    ///   - roomId: The unique identifier of the room associated with the plant, if any.
    /// - Throws: An error if the deletion process fails.
    public func execute(plantId: UUID, roomId: UUID?) async throws {
        // Delete the plant from the plant repository.
        try await plantRepository.deletePlant(id: plantId)
        
        // If the plant belongs to a room, update the room's preview images.
        if let roomId {
            try await roomRepository.updateRoomPreviewImages(roomId: roomId)
        }
        
        // Delete all tasks associated with the plant.
        taskRepository.deleteAllTasks(for: plantId)
    }
}
