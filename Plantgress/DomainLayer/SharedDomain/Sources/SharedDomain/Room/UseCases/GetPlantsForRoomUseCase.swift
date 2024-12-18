//
//  GetPlantsForRoomUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

public protocol GetPlantsForRoomUseCase {
    func execute(roomId: UUID) async throws -> [Plant]
}

public struct GetPlantsForRoomUseCaseImpl: GetPlantsForRoomUseCase {
    
    private let roomRepository: RoomRepository
    
    public init(
        roomRepository: RoomRepository
    ) {
        self.roomRepository = roomRepository
    }
    
    public func execute(roomId: UUID) async throws -> [Plant] {
        return try await roomRepository.getPlantsForRoom(roomId: roomId)
    }
}
