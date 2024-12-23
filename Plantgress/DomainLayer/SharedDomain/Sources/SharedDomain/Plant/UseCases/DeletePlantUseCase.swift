//
//  DeletePlantUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

public protocol DeletePlantUseCase {
    func execute(id: UUID) async throws
}

public struct DeletePlantUseCaseImpl: DeletePlantUseCase {
    
    private let plantRepository: PlantRepository
    private let taskRepository: TaskRepository
    
    public init(
        plantRepository: PlantRepository,
        taskRepository: TaskRepository
    ) {
        self.plantRepository = plantRepository
        self.taskRepository = taskRepository
    }
    
    public func execute(id: UUID) async throws {
        try await plantRepository.deletePlant(id: id)
        taskRepository.deleteAllTasks(for: id)
    }
}
