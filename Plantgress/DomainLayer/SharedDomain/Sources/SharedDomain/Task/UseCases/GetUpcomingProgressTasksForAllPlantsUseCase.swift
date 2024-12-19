//
//  GetUpcomingProgressTasksForAllPlantsUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 19.12.2024.
//

import Foundation

public protocol GetUpcomingProgressTasksForAllPlantsUseCase {
    func execute(for plants: [Plant], days: Int) -> [ProgressTask]
}

public struct GetUpcomingProgressTasksForAllPlantsUseCaseImpl: GetUpcomingProgressTasksForAllPlantsUseCase {
    private let taskRepository: TaskRepository

    public init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }

    public func execute(for plants: [Plant], days: Int) -> [ProgressTask] {
        return taskRepository.getUpcomingProgressTasks(for: plants, days: days)
    }
}
