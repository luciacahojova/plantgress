//
//  TaskConfiguration.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import Foundation

public struct TaskConfiguration: Codable, Sendable, Equatable {
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
    
    public static func == (lhs: TaskConfiguration, rhs: TaskConfiguration) -> Bool {
        return lhs.taskType == rhs.taskType &&
               lhs.isTracked == rhs.isTracked &&
               lhs.hasNotifications == rhs.hasNotifications &&
               lhs.startDate == rhs.startDate &&
               lhs.periods == rhs.periods
    }
}
