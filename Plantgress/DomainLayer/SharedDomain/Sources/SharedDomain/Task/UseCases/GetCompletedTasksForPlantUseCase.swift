//
//  GetCompletedTasksForPlantUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 19.12.2024.
//

import Foundation

public protocol GetCompletedTasksForPlantUseCase {
    func execute(for plantId: UUID) async throws -> [PlantTask]
}

public struct GetCompletedTasksForPlantUseCaseImpl: GetCompletedTasksForPlantUseCase {
    private let taskRepository: TaskRepository

    public init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }

    public func execute(for plantId: UUID) async throws -> [PlantTask] {
        try await taskRepository.getCompletedTasks(for: plantId)
    }
}
