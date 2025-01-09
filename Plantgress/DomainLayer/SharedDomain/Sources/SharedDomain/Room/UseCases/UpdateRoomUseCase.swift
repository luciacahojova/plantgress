//
//  UpdateRoomUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 30.12.2024.
//

import Foundation

/// Protocol defining the use case for updating an existing room and its associated plants.
public protocol UpdateRoomUseCase {
    /// Executes the use case to update a room and its associated plants.
    /// - Parameters:
    ///   - room: The `Room` object containing the updated room data.
    ///   - plants: An array of `Plant` objects to update their association with the room.
    /// - Throws: An error if the update process fails.
    func execute(room: Room, plants: [Plant]) async throws
}

/// Implementation of the `UpdateRoomUseCase` protocol for updating an existing room and its associated plants.
public struct UpdateRoomUseCaseImpl: UpdateRoomUseCase {
    
    /// The repository for managing room-related data.
    private let roomRepository: RoomRepository
    
    /// Initializes a new instance of `UpdateRoomUseCaseImpl`.
    /// - Parameter roomRepository: The `RoomRepository` for interacting with room-related data.
    public init(
        roomRepository: RoomRepository
    ) {
        self.roomRepository = roomRepository
    }
    
    /// Executes the use case to update a room and its associated plants.
    /// - Parameters:
    ///   - room: The `Room` object containing the updated room data.
    ///   - plants: An array of `Plant` objects to update their association with the room.
    /// - Throws: An error if the update process fails.
    public func execute(room: Room, plants: [Plant]) async throws {
        // Use the repository to update the room and its plants.
        try await roomRepository.updateRoom(room: room, plants: plants)
    }
}
