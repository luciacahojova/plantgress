//
//  CreateRoomUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

/// Protocol defining the use case for creating a new room and assigning plants to it.
public protocol CreateRoomUseCase {
    /// Executes the use case to create a new room and assign plants to it.
    /// - Parameters:
    ///   - room: The `Room` object to be created.
    ///   - plants: An array of `Plant` objects to be associated with the room.
    /// - Throws: An error if the creation or assignment process fails.
    func execute(room: Room, plants: [Plant]) async throws
}

/// Implementation of the `CreateRoomUseCase` protocol for creating a new room and assigning plants to it.
public struct CreateRoomUseCaseImpl: CreateRoomUseCase {
    
    /// The repository for managing room-related data.
    private let roomRepository: RoomRepository
    
    /// Initializes a new instance of `CreateRoomUseCaseImpl`.
    /// - Parameter roomRepository: The `RoomRepository` for interacting with room-related data.
    public init(
        roomRepository: RoomRepository
    ) {
        self.roomRepository = roomRepository
    }
    
    /// Executes the use case to create a new room and assign plants to it.
    /// - Parameters:
    ///   - room: The `Room` object to be created.
    ///   - plants: An array of `Plant` objects to be associated with the room.
    /// - Throws: An error if the creation or assignment process fails.
    public func execute(room: Room, plants: [Plant]) async throws {
        // Create the room and associate the plants with it using the repository.
        try await roomRepository.createRoom(room: room, plants: plants)
    }
}
