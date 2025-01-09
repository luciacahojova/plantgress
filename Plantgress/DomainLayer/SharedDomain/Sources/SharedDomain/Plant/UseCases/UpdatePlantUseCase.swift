//
//  UpdatePlantUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

public protocol UpdatePlantUseCase {
    func execute(plant: Plant) async throws
}

public struct UpdatePlantUseCaseImpl: UpdatePlantUseCase {
    
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
        try await plantRepository.updatePlant(plant)
        try await taskRepository.synchronizeNotifications(for: plant)
        
        guard let roomId = plant.roomId else { return }
        try await roomRepository.addPlantToRoom(roomId: roomId, plantId: plant.id)
    }
}
