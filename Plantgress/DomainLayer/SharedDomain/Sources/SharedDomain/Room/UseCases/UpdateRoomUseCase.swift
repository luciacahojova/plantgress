//
//  UpdateRoomUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 30.12.2024.
//

import Foundation

public protocol UpdateRoomUseCase {
    func execute(room: Room, plants: [Plant]) async throws
}

public struct UpdateRoomUseCaseImpl: UpdateRoomUseCase {
    
    private let roomRepository: RoomRepository
    
    public init(
        roomRepository: RoomRepository
    ) {
        self.roomRepository = roomRepository
    }
    
    public func execute(room: Room, plants: [Plant]) async throws {
        try await roomRepository.updateRoom(room: room, plants: plants)
    }
}
