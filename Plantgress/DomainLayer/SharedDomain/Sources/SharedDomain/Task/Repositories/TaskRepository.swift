//
//  TaskRepository.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

public protocol TaskRepository {
    func synchronizeNotifications(for plant: Plant) async throws
    func synchronizeAllNotifications(for plants: [Plant]) async throws
    func scheduleNextNotification(for plant: Plant, taskType: TaskType, dueDate: Date, completionDate: Date) async throws
    func initializeNotifications(for plant: Plant) async throws

    func getUpcomingTasks(for plant: Plant, days: Int) async -> [PlantTask]
    func getUpcomingTasks(for plants: [Plant], days: Int) async -> [PlantTask]
    func getCompletedTasks(for plantId: UUID) async throws -> [PlantTask]
    func getCompletedTasks(for plantIds: [UUID]) async throws -> [PlantTask]

    func completeTask(for plant: Plant, taskType: TaskType, dueDate: Date?, completionDate: Date) async throws
    func completeTaskForRoom(plants: [Plant], taskType: TaskType, completionDate: Date) async throws
    func deleteTask(_ task: PlantTask, plant: Plant) async throws
    func deleteTask(for plant: Plant, taskType: TaskType) async throws
    func deleteAllTasks(for plantId: UUID)
}
