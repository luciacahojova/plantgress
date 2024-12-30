//
//  DeleteRoomUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 30.12.2024.
//

import Foundation

public protocol DeleteRoomUseCase {
    func execute(roomId: UUID, plants: [Plant]) async throws
}

public struct DeleteRoomUseCaseImpl: DeleteRoomUseCase {
    
    private let roomRepository: RoomRepository
    
    public init(
        roomRepository: RoomRepository
    ) {
        self.roomRepository = roomRepository
    }
    
    public func execute(roomId: UUID, plants: [Plant]) async throws {
        try await roomRepository.deleteRoom(roomId: roomId.uuidString, plants: plants)
    }
}
