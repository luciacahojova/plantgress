//
//  SynchronizeNotificationsForAllPlantsUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 19.12.2024.
//

import Foundation

public protocol SynchronizeNotificationsForAllPlantsUseCase {
    func execute(for plants: [Plant]) async throws
}

public struct SynchronizeNotificationsForAllPlantsUseCaseImpl: SynchronizeNotificationsForAllPlantsUseCase {
    private let taskRepository: TaskRepository

    public init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }

    public func execute(for plants: [Plant]) async throws {
        try await taskRepository.synchronizeAllNotifications(for: plants)
    }
}
