//
//  GetPlantsForRoomUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

/// Protocol defining the use case for retrieving all plants in a specific room.
public protocol GetPlantsForRoomUseCase {
    /// Executes the use case to retrieve all plants for a specific room.
    /// - Parameter roomId: The unique identifier of the room.
    /// - Returns: An array of `Plant` objects associated with the room.
    /// - Throws: An error if the retrieval process fails.
    func execute(roomId: UUID) async throws -> [Plant]
}

/// Implementation of the `GetPlantsForRoomUseCase` protocol for retrieving all plants in a specific room.
public struct GetPlantsForRoomUseCaseImpl: GetPlantsForRoomUseCase {
    
    /// The repository for managing room-related data.
    private let roomRepository: RoomRepository
    
    /// Initializes a new instance of `GetPlantsForRoomUseCaseImpl`.
    /// - Parameter roomRepository: The `RoomRepository` for interacting with room-related data.
    public init(
        roomRepository: RoomRepository
    ) {
        self.roomRepository = roomRepository
    }
    
    /// Executes the use case to retrieve all plants for a specific room.
    /// - Parameter roomId: The unique identifier of the room.
    /// - Returns: An array of `Plant` objects associated with the room.
    /// - Throws: An error if the retrieval process fails.
    public func execute(roomId: UUID) async throws -> [Plant] {
        // Use the repository to fetch the plants for the specified room.
        try await roomRepository.getPlantsForRoom(roomId: roomId)
    }
}
