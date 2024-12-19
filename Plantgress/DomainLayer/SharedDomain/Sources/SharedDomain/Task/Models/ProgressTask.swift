//
//  ProgressTask.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 19.12.2024.
//

import Foundation

public struct ProgressTask: Codable, TaskItem {
    public let id: UUID
    public let plantId: UUID
    public let plantName: String
    public let imageUrl: String
    public let dueDate: Date
    public let isCompleted: Bool
    
    public init(
        id: UUID,
        plantId: UUID,
        plantName: String,
        imageUrl: String,
        dueDate: Date,
        isCompleted: Bool
    ) {
        self.id = id
        self.plantId = plantId
        self.plantName = plantName
        self.imageUrl = imageUrl
        self.dueDate = dueDate
        self.isCompleted = isCompleted
    }
}
