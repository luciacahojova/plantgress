//
//  PlantTask.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import Foundation

public struct PlantTask: Codable, Sendable, Equatable {
    public let id: UUID
    public let plantId: UUID
    public let plantName: String
    public let imageUrl: String
    public let taskType: TaskType
    public let dueDate: Date
    public let completionDate: Date?
    public let isCompleted: Bool
    
    public init(
        id: UUID,
        plantId: UUID,
        plantName: String,
        imageUrl: String,
        taskType: TaskType,
        dueDate: Date,
        completionDate: Date?,
        isCompleted: Bool
    ) {
        self.id = id
        self.plantId = plantId
        self.plantName = plantName
        self.imageUrl = imageUrl
        self.taskType = taskType
        self.dueDate = dueDate
        self.completionDate = completionDate
        self.isCompleted = isCompleted
    }
}
