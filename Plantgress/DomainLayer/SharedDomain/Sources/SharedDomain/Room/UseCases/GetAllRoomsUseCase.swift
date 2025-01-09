//
//  GetAllRoomsUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

/// Protocol defining the use case for retrieving all rooms.
public protocol GetAllRoomsUseCase {
    /// Executes the use case to retrieve all rooms.
    /// - Returns: An array of `Room` objects.
    /// - Throws: An error if the retrieval process fails.
    func execute() async throws -> [Room]
}

/// Implementation of the `GetAllRoomsUseCase` protocol for retrieving all rooms.
public struct GetAllRoomsUseCaseImpl: GetAllRoomsUseCase {
    
    /// The repository for managing room-related data.
    private let roomRepository: RoomRepository
    
    /// Initializes a new instance of `GetAllRoomsUseCaseImpl`.
    /// - Parameter roomRepository: The `RoomRepository` for interacting with room-related data.
    public init(
        roomRepository: RoomRepository
    ) {
        self.roomRepository = roomRepository
    }
    
    /// Executes the use case to retrieve all rooms.
    /// - Returns: An array of `Room` objects.
    /// - Throws: An error if the retrieval process fails.
    public func execute() async throws -> [Room] {
        // Use the repository to fetch all rooms.
        try await roomRepository.getAllRooms()
    }
}
