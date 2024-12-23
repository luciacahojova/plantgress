//
//  AddPlantsToRoomUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

public protocol AddPlantsToRoomUseCase {
    func execute(roomId: UUID, plantIds: [UUID]) async throws
}

public struct AddPlantsToRoomUseCaseImpl: AddPlantsToRoomUseCase {
    
    private let roomRepository: RoomRepository
    
    public init(
        roomRepository: RoomRepository
    ) {
        self.roomRepository = roomRepository
    }
    
    public func execute(roomId: UUID, plantIds: [UUID]) async throws {
        for plantId in plantIds {
            try await roomRepository.addPlantToRoom(roomId: roomId, plantId: plantId)
        }
    }
}
