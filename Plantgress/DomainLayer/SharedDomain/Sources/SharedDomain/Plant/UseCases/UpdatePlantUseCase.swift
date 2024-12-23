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
    private let taskRepository: TaskRepository
    
    public init(
        plantRepository: PlantRepository,
        taskRepository: TaskRepository
    ) {
        self.plantRepository = plantRepository
        self.taskRepository = taskRepository
    }
    
    public func execute(plant: Plant) async throws {
        try await plantRepository.updatePlant(plant)
        try await taskRepository.synchronizeNotifications(for: plant)
    }
}
