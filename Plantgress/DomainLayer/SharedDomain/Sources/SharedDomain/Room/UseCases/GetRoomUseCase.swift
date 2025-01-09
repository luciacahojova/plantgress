//
//  GetRoomUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

/// Protocol defining the use case for retrieving a specific room by its ID.
public protocol GetRoomUseCase {
    /// Executes the use case to retrieve a room by its unique identifier.
    /// - Parameter roomId: The unique identifier of the room.
    /// - Returns: A `Room` object representing the room.
    /// - Throws: An error if the retrieval process fails.
    func execute(roomId: UUID) async throws -> Room
}

/// Implementation of the `GetRoomUseCase` protocol for retrieving a specific room by its ID.
public struct GetRoomUseCaseImpl: GetRoomUseCase {
    
    /// The repository for managing room-related data.
    private let roomRepository: RoomRepository
    
    /// Initializes a new instance of `GetRoomUseCaseImpl`.
    /// - Parameter roomRepository: The `RoomRepository` for interacting with room-related data.
    public init(
        roomRepository: RoomRepository
    ) {
        self.roomRepository = roomRepository
    }
    
    /// Executes the use case to retrieve a room by its unique identifier.
    /// - Parameter roomId: The unique identifier of the room.
    /// - Returns: A `Room` object representing the room.
    /// - Throws: An error if the retrieval process fails.
    public func execute(roomId: UUID) async throws -> Room {
        // Use the repository to fetch the room data.
        return try await roomRepository.getRoom(roomId: roomId)
    }
}
