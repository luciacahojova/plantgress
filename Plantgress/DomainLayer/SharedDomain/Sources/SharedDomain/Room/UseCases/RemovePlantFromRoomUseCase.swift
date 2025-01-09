//
//  RemovePlantFromRoomUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

/// Protocol defining the use case for removing a plant from a specific room.
public protocol RemovePlantFromRoomUseCase {
    /// Executes the use case to remove a plant from a specific room.
    /// - Parameters:
    ///   - plantId: The unique identifier of the plant to remove.
    ///   - roomId: The unique identifier of the room from which to remove the plant.
    /// - Throws: An error if the removal process fails.
    func execute(plantId: UUID, roomId: UUID) async throws
}

/// Implementation of the `RemovePlantFromRoomUseCase` protocol for removing a plant from a specific room.
public struct RemovePlantFromRoomUseCaseImpl: RemovePlantFromRoomUseCase {
    
    /// The repository for managing room-related data.
    private let roomRepository: RoomRepository
    
    /// Initializes a new instance of `RemovePlantFromRoomUseCaseImpl`.
    /// - Parameter roomRepository: The `RoomRepository` for interacting with room-related data.
    public init(
        roomRepository: RoomRepository
    ) {
        self.roomRepository = roomRepository
    }
    
    /// Executes the use case to remove a plant from a specific room.
    /// - Parameters:
    ///   - plantId: The unique identifier of the plant to remove.
    ///   - roomId: The unique identifier of the room from which to remove the plant.
    /// - Throws: An error if the removal process fails.
    public func execute(plantId: UUID, roomId: UUID) async throws {
        // Use the repository to remove the plant from the specified room.
        try await roomRepository.removePlantFromRoom(plantId: plantId, roomId: roomId)
    }
}
