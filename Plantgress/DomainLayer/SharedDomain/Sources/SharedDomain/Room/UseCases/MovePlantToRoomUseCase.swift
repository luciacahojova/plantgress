//
//  MovePlantToRoomUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

/// Protocol defining the use case for moving a plant from one room to another.
public protocol MovePlantToRoomUseCase {
    /// Executes the use case to move a plant from one room to another.
    /// - Parameters:
    ///   - plantId: The unique identifier of the plant to move.
    ///   - fromRoomId: The unique identifier of the room from which the plant is moved.
    ///   - toRoomId: The unique identifier of the room to which the plant is moved.
    /// - Throws: An error if the move process fails.
    func execute(plantId: UUID, fromRoomId: UUID, toRoomId: UUID) async throws
}

/// Implementation of the `MovePlantToRoomUseCase` protocol for moving a plant from one room to another.
public struct MovePlantToRoomUseCaseImpl: MovePlantToRoomUseCase {
    
    /// The repository for managing room-related data.
    private let roomRepository: RoomRepository
    
    /// Initializes a new instance of `MovePlantToRoomUseCaseImpl`.
    /// - Parameter roomRepository: The `RoomRepository` for interacting with room-related data.
    public init(
        roomRepository: RoomRepository
    ) {
        self.roomRepository = roomRepository
    }
    
    /// Executes the use case to move a plant from one room to another.
    /// - Parameters:
    ///   - plantId: The unique identifier of the plant to move.
    ///   - fromRoomId: The unique identifier of the room from which the plant is moved.
    ///   - toRoomId: The unique identifier of the room to which the plant is moved.
    /// - Throws: An error if the move process fails.
    public func execute(plantId: UUID, fromRoomId: UUID, toRoomId: UUID) async throws {
        // Use the repository to move the plant from one room to another.
        try await roomRepository.movePlantToRoom(plantId: plantId, fromRoomId: fromRoomId, toRoomId: toRoomId)
    }
}
