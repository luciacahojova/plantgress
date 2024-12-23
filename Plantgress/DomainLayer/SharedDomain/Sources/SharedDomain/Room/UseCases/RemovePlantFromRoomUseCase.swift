//
//  RemovePlantFromRoomUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

public protocol RemovePlantFromRoomUseCase {
    func execute(plantId: UUID, roomId: UUID) async throws
}

public struct RemovePlantFromRoomUseCaseImpl: RemovePlantFromRoomUseCase {
    
    private let roomRepository: RoomRepository
    
    public init(
        roomRepository: RoomRepository
    ) {
        self.roomRepository = roomRepository
    }
    
    public func execute(plantId: UUID, roomId: UUID) async throws {
        try await roomRepository.removePlantFromRoom(plantId: plantId, roomId: roomId)
    }
}
