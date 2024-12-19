//
//  GetUpcomingTasksForAllPlantsUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 19.12.2024.
//

import Foundation

public protocol GetUpcomingTasksForAllPlantsUseCase {
    func execute(for plants: [Plant], days: Int) -> [PlantTask]
}

public struct GetUpcomingTasksForAllPlantsUseCaseImpl: GetUpcomingTasksForAllPlantsUseCase {
    private let taskRepository: TaskRepository

    public init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }

    public func execute(for plants: [Plant], days: Int) -> [PlantTask] {
        return taskRepository.getUpcomingTasks(for: plants, days: days)
    }
}
