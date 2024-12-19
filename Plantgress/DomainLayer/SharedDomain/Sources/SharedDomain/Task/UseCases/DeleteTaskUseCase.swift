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

    public init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }

    public func execute(task: PlantTask) async throws {
        try await taskRepository.deleteTask(task)
    }
}
