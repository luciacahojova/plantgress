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
    private let taskRepository: TaskRepository
    
    public init(
        plantRepository: PlantRepository,
        roomRepository: RoomRepository,
        taskRepository: TaskRepository
    ) {
        self.plantRepository = plantRepository
        self.roomRepository = roomRepository
        self.taskRepository = taskRepository
    }
    
    public func execute(plant: Plant) async throws {
        try await plantRepository.createPlant(plant)
        try await taskRepository.initializeNotifications(for: plant)
        
        guard let roomId = plant.roomId else { return }
        try await roomRepository.updateRoomPreviewImages(roomId: roomId)
    }
}
