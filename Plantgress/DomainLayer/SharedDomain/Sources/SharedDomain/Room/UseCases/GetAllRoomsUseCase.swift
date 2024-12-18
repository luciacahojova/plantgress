//
//  GetAllRoomsUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

public protocol GetAllRoomsUseCase {
    func execute() async throws -> [Room]
}

public struct GetAllRoomsUseCaseImpl: GetAllRoomsUseCase {
    
    private let roomRepository: RoomRepository
    
    public init(
        roomRepository: RoomRepository
    ) {
        self.roomRepository = roomRepository
    }
    
    public func execute() async throws -> [Room] {
        return try await roomRepository.getAllRooms()
    }
}
