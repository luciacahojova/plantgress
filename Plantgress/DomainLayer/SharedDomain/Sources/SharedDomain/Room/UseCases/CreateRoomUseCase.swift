//
//  CreateRoomUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

public protocol CreateRoomUseCase {
    func execute(room: Room, plants: [Plant]) async throws
}

public struct CreateRoomUseCaseImpl: CreateRoomUseCase {
    
    private let roomRepository: RoomRepository
    
    public init(
        roomRepository: RoomRepository
    ) {
        self.roomRepository = roomRepository
    }
    
    public func execute(room: Room, plants: [Plant]) async throws {
        try await roomRepository.createRoom(room: room, plants: plants)
    }
}
