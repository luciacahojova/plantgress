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
    public let time: Date
    public let startDate: Date
    public let periods: [TaskPeriod]
    
    public init(
        taskType: TaskType,
        isTracked: Bool,
        hasNotifications: Bool,
        time: Date,
        startDate: Date,
        periods: [TaskPeriod]
    ) {
        self.taskType = taskType
        self.isTracked = isTracked
        self.hasNotifications = hasNotifications
        self.time = time
        self.startDate = startDate
        self.periods = periods
    }
    
    public static func == (lhs: TaskConfiguration, rhs: TaskConfiguration) -> Bool {
        return lhs.taskType == rhs.taskType &&
               lhs.isTracked == rhs.isTracked &&
               lhs.hasNotifications == rhs.hasNotifications &&
               lhs.time == rhs.time &&
               lhs.startDate == rhs.startDate &&
               lhs.periods == rhs.periods
    }
    
    public init(
        copy: TaskConfiguration,
        taskType: TaskType? = nil,
        isTracked: Bool? = nil,
        hasNotifications: Bool? = nil,
        time: Date? = nil,
        startDate: Date? = nil,
        periods: [TaskPeriod]? = nil
    ) {
        self.taskType = taskType ?? copy.taskType
        self.isTracked = isTracked ?? copy.isTracked
        self.hasNotifications = hasNotifications ?? copy.hasNotifications
        self.time = time ?? copy.time 
        self.startDate = startDate ?? copy.startDate
        self.periods = periods ?? copy.periods
    }
}
