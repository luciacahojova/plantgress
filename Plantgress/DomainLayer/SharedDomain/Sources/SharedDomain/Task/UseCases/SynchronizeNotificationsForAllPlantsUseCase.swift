//
//  SynchronizeNotificationsForAllPlantsUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 19.12.2024.
//

import Foundation

public protocol SynchronizeNotificationsForAllPlantsUseCase {
    func execute() async throws
}

public struct SynchronizeNotificationsForAllPlantsUseCaseImpl: SynchronizeNotificationsForAllPlantsUseCase {
    
    private let taskRepository: TaskRepository
    private let plantRepository: PlantRepository

    public init(
        taskRepository: TaskRepository,
        plantRepository: PlantRepository
    ) {
        self.taskRepository = taskRepository
        self.plantRepository = plantRepository
    }

    public func execute() async throws {
        let plants = try await plantRepository.getAllPlants()
        
        try await taskRepository.synchronizeAllNotifications(for: plants)
    }
}
