//
//  TaskRepository.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

public protocol TaskRepository {
    func completeTask(for plant: Plant, taskType: TaskType, completionDate: Date) async throws
    func getUpcomingTasks(for plant: Plant, days: Int) -> [PlantTask]
    func getUpcomingTasks(for plants: [Plant], days: Int) -> [PlantTask]
    func getCompletedTasks(for plantId: UUID) async throws -> [PlantTask]
    func getCompletedTasks(for plantIds: [UUID]) async throws -> [PlantTask]
    func synchronizeNotifications(for plant: Plant) async throws
    func synchronizeAllNotifications(for plants: [Plant]) async throws
    func deleteTask(_ task: PlantTask) async throws
}
