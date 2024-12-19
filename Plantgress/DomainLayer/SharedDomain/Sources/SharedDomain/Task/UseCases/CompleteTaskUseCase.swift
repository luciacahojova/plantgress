//
//  CompleteTaskUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 19.12.2024.
//

import Foundation

public protocol CompleteTaskUseCase {
    func execute(for plant: Plant, taskType: TaskType, periodId: UUID, completionDate: Date) async throws
}

public struct CompleteTaskUseCaseImpl: CompleteTaskUseCase {
    private let taskRepository: TaskRepository

    public init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }

    public func execute(for plant: Plant, taskType: TaskType, periodId: UUID, completionDate: Date) async throws {
        try await taskRepository.completeTask(
            for: plant,
            taskType: taskType,
            periodId: periodId,
            completionDate: completionDate
        )
        
        // TODO: Add task to firebase
    }
}
