//
//  TaskRepository.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

public protocol TaskRepository {
    func synchronizeAllNotifications(for plants: [Plant]) async throws
    func synchronizeNotifications(for plant: Plant) async throws
    func completeTask(for plant: Plant, taskType: TaskType, periodId: UUID, completionDate: Date) async throws
    func getUpcomingTasks(for plants: [Plant], days: Int) -> [PlantTask]
    func getUpcomingTasks(for plant: Plant, days: Int) -> [PlantTask]
    func getUpcomingProgressTasks(for plant: Plant, days: Int) -> [ProgressTask]
    func getUpcomingProgressTasks(for plants: [Plant], days: Int) -> [ProgressTask]
}
