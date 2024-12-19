//
//  GetUpcomingProgressTasksForPlantUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 19.12.2024.
//

import Foundation

public protocol GetUpcomingProgressTasksForPlantUseCase {
    func execute(for plant: Plant, days: Int) -> [ProgressTask]
}

public struct GetUpcomingProgressTasksForPlantUseCaseImpl: GetUpcomingProgressTasksForPlantUseCase {
    private let taskRepository: TaskRepository

    public init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }

    public func execute(for plant: Plant, days: Int) -> [ProgressTask] {
        return taskRepository.getUpcomingProgressTasks(for: plant, days: days)
    }
}
