//
//  TaskConfiguration.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import Foundation

public struct TaskConfiguration: Codable {
    public let taskType: TaskType
    public let isTracked: Bool
    public let hasNotifications: Bool
    public let startDate: Date
    public let periods: [TaskPeriod]
    
    public init(
        taskType: TaskType,
        isTracked: Bool,
        hasNotifications: Bool,
        startDate: Date,
        periods: [TaskPeriod]
    ) {
        self.taskType = taskType
        self.isTracked = isTracked
        self.hasNotifications = hasNotifications
        self.startDate = startDate
        self.periods = periods
    }
}
