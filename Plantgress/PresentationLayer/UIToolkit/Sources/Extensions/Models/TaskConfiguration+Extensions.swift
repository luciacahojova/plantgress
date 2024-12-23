//
//  TaskConfiguration+Extensions.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import Foundation
import SharedDomain

public extension [TaskConfiguration] {
    static var mock: [TaskConfiguration] {
        return TaskType.allCases.map { taskType in
            return TaskConfiguration(
                taskType: taskType,
                isTracked: true,
                hasNotifications: false,
                startDate: Date(),
                periods: []
            )
        }
    }
    
    static var `default`: [TaskConfiguration] {
        TaskType.allCases.filter { $0 != .progressTracking }.map { taskType in
            TaskConfiguration(
                taskType: taskType,
                isTracked: true,
                hasNotifications: true,
                startDate: Date(),
                periods: [
                    TaskPeriod(id: UUID(), name: "Period 1", interval: .daily(interval: 3))
                ]
            )
        }
    }
}
