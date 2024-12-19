//
//  CreatePlantUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

public protocol CreatePlantUseCase {
    func execute(plant: Plant) async throws
}

public struct CreatePlantUseCaseImpl: CreatePlantUseCase {
    
    private let plantRepository: PlantRepository
    private let roomRepository: RoomRepository
    
    public init(
        plantRepository: PlantRepository,
        roomRepository: RoomRepository
    ) {
        self.plantRepository = plantRepository
        self.roomRepository = roomRepository
    }
    
    public func execute(plant: Plant) async throws {
        try await plantRepository.createPlant(plant)
        
        guard let roomId = plant.roomId else { return }
        try await roomRepository.updateRoomPreviewImages(roomId: roomId)
    }
}
