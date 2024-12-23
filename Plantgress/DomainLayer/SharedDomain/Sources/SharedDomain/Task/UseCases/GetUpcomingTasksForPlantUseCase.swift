//
//  GetUpcomingTasksForPlantUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 19.12.2024.
//

import Foundation

public protocol GetUpcomingTasksForPlantUseCase {
    func execute(for plant: Plant, days: Int) async -> [PlantTask]
}

public struct GetUpcomingTasksForPlantUseCaseImpl: GetUpcomingTasksForPlantUseCase {
    private let taskRepository: TaskRepository

    public init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }

    public func execute(for plant: Plant, days: Int) async -> [PlantTask] {
        return await taskRepository.getUpcomingTasks(for: plant, days: days)
    }
}
