//
//  GetCompletedTasksForAllPlantsUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 19.12.2024.
//

import Foundation


public protocol GetCompletedTasksForAllPlantsUseCase {
    func execute(for plantIds: [UUID]) async throws -> [PlantTask]
}

public struct GetCompletedTasksForAllPlantsUseCaseImpl: GetCompletedTasksForAllPlantsUseCase {
    private let taskRepository: TaskRepository

    public init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }

    public func execute(for plantIds: [UUID]) async throws -> [PlantTask] {
        try await taskRepository.getCompletedTasks(for: plantIds)
    }
}
