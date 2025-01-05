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
                time: Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date(),
                startDate: Date(),
                periods: []
            )
        }
    }
}
