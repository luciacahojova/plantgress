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
    
    public init(
        copy: TaskConfiguration,
        taskType: TaskType? = nil,
        isTracked: Bool? = nil,
        hasNotifications: Bool? = nil,
        startDate: Date? = nil,
        periods: [TaskPeriod]? = nil
    ) {
        self.taskType = taskType ?? copy.taskType
        self.isTracked = isTracked ?? copy.isTracked
        self.hasNotifications = hasNotifications ?? copy.hasNotifications
        self.startDate = startDate ?? copy.startDate
        self.periods = periods ?? copy.periods
    }
}
