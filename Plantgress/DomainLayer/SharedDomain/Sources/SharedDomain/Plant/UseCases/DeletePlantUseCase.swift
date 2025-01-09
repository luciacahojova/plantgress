//
//  DeletePlantUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

public protocol DeletePlantUseCase {
    func execute(plantId: UUID, roomId: UUID?) async throws
}

public struct DeletePlantUseCaseImpl: DeletePlantUseCase {
    
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
    
    public func execute(plantId: UUID, roomId: UUID?) async throws {
        try await plantRepository.deletePlant(id: plantId)
        
        if let roomId {
            try await roomRepository.updateRoomPreviewImages(roomId: roomId)
        }
        
        taskRepository.deleteAllTasks(for: plantId)
    }
}
