//
//  DeleteTaskUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 19.12.2024.
//

import Foundation

public protocol DeleteTaskUseCase {
    func execute(task: PlantTask) async throws
}

public struct DeleteTaskUseCaseImpl: DeleteTaskUseCase {
    
    private let taskRepository: TaskRepository
    private let plantRepository: PlantRepository

    public init(
        taskRepository: TaskRepository,
        plantRepository: PlantRepository
    ) {
        self.taskRepository = taskRepository
        self.plantRepository = plantRepository
    }

    public func execute(task: PlantTask) async throws {
        let plant = try await plantRepository.getPlant(id: task.plantId)
        
        try await taskRepository.deleteTask(task, plant: plant)
    }
}
