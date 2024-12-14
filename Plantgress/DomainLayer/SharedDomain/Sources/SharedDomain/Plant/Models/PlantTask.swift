//
//  PlantTask.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import Foundation

public struct PlantTask: Codable {
    public let plantId: String
    public let plantName: String
    public let taskType: TaskType
    public let dueDate: Date
    public let isCompleted: Bool
    
    public init(
        plantId: String,
        plantName: String,
        taskType: TaskType,
        dueDate: Date,
        isCompleted: Bool
    ) {
        self.plantId = plantId
        self.plantName = plantName
        self.taskType = taskType
        self.dueDate = dueDate
        self.isCompleted = isCompleted
    }
}
