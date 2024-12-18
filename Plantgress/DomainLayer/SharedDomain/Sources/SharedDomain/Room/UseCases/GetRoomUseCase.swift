//
//  GetRoomUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

public protocol GetRoomUseCase {
    func execute(roomId: UUID) async throws -> Room
}

public struct GetRoomUseCaseImpl: GetRoomUseCase {
    
    private let roomRepository: RoomRepository
    
    public init(
        roomRepository: RoomRepository
    ) {
        self.roomRepository = roomRepository
    }
    
    public func execute(roomId: UUID) async throws -> Room {
        return try await roomRepository.getRoom(roomId: roomId)
    }
}
