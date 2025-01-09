//
//  AddPlantsToRoomUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

/// Protocol defining the use case for adding multiple plants to a specific room.
public protocol AddPlantsToRoomUseCase {
    /// Executes the use case to add multiple plants to a specific room.
    /// - Parameters:
    ///   - roomId: The unique identifier of the room.
    ///   - plantIds: An array of unique identifiers of the plants to add.
    /// - Throws: An error if the operation fails.
    func execute(roomId: UUID, plantIds: [UUID]) async throws
}

/// Implementation of the `AddPlantsToRoomUseCase` protocol for adding multiple plants to a specific room.
public struct AddPlantsToRoomUseCaseImpl: AddPlantsToRoomUseCase {
    
    /// The repository for managing room-related data.
    private let roomRepository: RoomRepository
    
    /// Initializes a new instance of `AddPlantsToRoomUseCaseImpl`.
    /// - Parameter roomRepository: The `RoomRepository` for interacting with room-related data.
    public init(roomRepository: RoomRepository) {
        self.roomRepository = roomRepository
    }
    
    /// Executes the use case to add multiple plants to a specific room.
    /// - Parameters:
    ///   - roomId: The unique identifier of the room.
    ///   - plantIds: An array of unique identifiers of the plants to add.
    /// - Throws: An error if the operation fails.
    public func execute(roomId: UUID, plantIds: [UUID]) async throws {
        // Iterate through the plant IDs and add each plant to the room.
        for plantId in plantIds {
            try await roomRepository.addPlantToRoom(roomId: roomId, plantId: plantId)
        }
    }
}
