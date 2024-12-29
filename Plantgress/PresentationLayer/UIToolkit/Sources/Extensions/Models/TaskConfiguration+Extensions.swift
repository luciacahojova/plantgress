//
//  TaskConfiguration+Extensions.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import Foundation
import SharedDomain

public extension TaskConfiguration {
    static func `default`(for taskType: TaskType) -> TaskConfiguration {
        if taskType == .progressTracking {
            return TaskConfiguration(
                taskType: taskType,
                isTracked: true,
                hasNotifications: true,
                time: Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date(),
                startDate: Date(),
                periods: [
                    TaskPeriod(id: UUID(), name: "Period 1", interval: .daily(interval: 10))
                ]
            )
        } else {
            return TaskConfiguration(
                taskType: taskType,
                isTracked: false,
                hasNotifications: false,
                time: Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date(),
                startDate: Date(),
                periods: [
                    TaskPeriod(id: UUID(), name: "Period 1", interval: .daily(interval: 10))
                ]
            )
        }
    }
}

public extension [TaskConfiguration] {
    static var mock: [TaskConfiguration] {
        return TaskType.allCases.map { taskType in
            return TaskConfiguration(
                taskType: taskType,
                isTracked: true,
                hasNotifications: false,
                time: Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date(),
                startDate: Date(),
                periods: []
            )
        }
    }
    
    static var `default`: [TaskConfiguration] {
        TaskType.allCases.map { taskType in
            if taskType == .progressTracking {
                return TaskConfiguration(
                    taskType: taskType,
                    isTracked: true,
                    hasNotifications: true,
                    time: Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date(),
                    startDate: Date(),
                    periods: [
                        TaskPeriod(id: UUID(), name: "Period 1", interval: .daily(interval: 10))
                    ]
                )
            } else {
                return TaskConfiguration(
                    taskType: taskType,
                    isTracked: false,
                    hasNotifications: false,
                    time: Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date(),
                    startDate: Date(),
                    periods: [
                        TaskPeriod(id: UUID(), name: "Period 1", interval: .daily(interval: 10))
                    ]
                )
            }
        }
    }
    
    static var defaultRoomConfiguration: [TaskConfiguration] {
        TaskType.allCases.filter { $0 != .progressTracking }.map { taskType in
            TaskConfiguration(
                taskType: taskType,
                isTracked: true,
                hasNotifications: false,
                time: Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date(),
                startDate: Date(),
                periods: []
            )
        }
    }
}
