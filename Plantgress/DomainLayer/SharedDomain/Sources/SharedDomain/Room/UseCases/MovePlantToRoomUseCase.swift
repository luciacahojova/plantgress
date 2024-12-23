//
//  MovePlantToRoomUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

public protocol MovePlantToRoomUseCase {
    func execute(plantId: UUID, fromRoomId: UUID, toRoomId: UUID) async throws
}

public struct MovePlantToRoomUseCaseImpl: MovePlantToRoomUseCase {
    
    private let roomRepository: RoomRepository
    
    public init(
        roomRepository: RoomRepository
    ) {
        self.roomRepository = roomRepository
    }
    
    public func execute(plantId: UUID, fromRoomId: UUID, toRoomId: UUID) async throws {
        try await roomRepository.movePlantToRoom(plantId: plantId, fromRoomId: fromRoomId, toRoomId: toRoomId)
    }
}
