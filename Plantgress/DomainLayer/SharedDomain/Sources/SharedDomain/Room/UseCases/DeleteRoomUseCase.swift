//
//  DeleteRoomUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 30.12.2024.
//

import Foundation

/// Protocol defining the use case for deleting a room and its associated plants.
public protocol DeleteRoomUseCase {
    /// Executes the use case to delete a room and dissociate its plants.
    /// - Parameters:
    ///   - roomId: The unique identifier of the room to delete.
    ///   - plants: An array of `Plant` objects to remove their association with the room.
    /// - Throws: An error if the deletion or dissociation process fails.
    func execute(roomId: UUID, plants: [Plant]) async throws
}

/// Implementation of the `DeleteRoomUseCase` protocol for deleting a room and its associated plants.
public struct DeleteRoomUseCaseImpl: DeleteRoomUseCase {
    
    /// The repository for managing room-related data.
    private let roomRepository: RoomRepository
    
    /// Initializes a new instance of `DeleteRoomUseCaseImpl`.
    /// - Parameter roomRepository: The `RoomRepository` for interacting with room-related data.
    public init(
        roomRepository: RoomRepository
    ) {
        self.roomRepository = roomRepository
    }
    
    /// Executes the use case to delete a room and dissociate its plants.
    /// - Parameters:
    ///   - roomId: The unique identifier of the room to delete.
    ///   - plants: An array of `Plant` objects to remove their association with the room.
    /// - Throws: An error if the deletion or dissociation process fails.
    public func execute(roomId: UUID, plants: [Plant]) async throws {
        // Delete the room and dissociate its plants using the repository.
        try await roomRepository.deleteRoom(roomId: roomId.uuidString, plants: plants)
    }
}
