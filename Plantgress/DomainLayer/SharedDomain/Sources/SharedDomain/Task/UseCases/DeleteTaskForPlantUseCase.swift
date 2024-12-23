//
//  DeleteTaskForPlantUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 21.12.2024.
//

import Foundation

public protocol DeleteTaskForPlantUseCase {
    func execute(plant: Plant, taskType: TaskType) async throws
}

public struct DeleteTaskForPlantUseCaseImpl: DeleteTaskForPlantUseCase {
    
    private let taskRepository: TaskRepository

    public init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }

    public func execute(plant: Plant, taskType: TaskType) async throws {
        try await taskRepository.deleteTask(for: plant, taskType: taskType)
    }
}
