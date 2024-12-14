//
//  TaskPeriod+Extensions.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import SharedDomain

public extension [TaskPeriod] { // TODO: Delete
    static func `default`(for taskType: TaskType) -> [TaskPeriod] {
        switch taskType {
        case .watering:
            return [
                TaskPeriod(name: "Period 1", notificationId: nil, interval: .monthly(interval: 5, months: [5, 6, 7, 8])),
                TaskPeriod(name: "Period 1", notificationId: nil, interval: .monthly(interval: 7, months: [3, 4, 9, 10])),
                TaskPeriod(name: "Period 1", notificationId: nil, interval: .monthly(interval: 9, months: [11, 12, 1, 2])),
            ]
        case .pestInspection:
            return [TaskPeriod(name: "Period 1", notificationId: nil, interval: .daily(interval: 10))]
        case .fertilizing:
            return [TaskPeriod(name: "Period 1", notificationId: nil, interval: .monthly(interval: 14, months: [4, 5, 6, 7, 8, 9]))]
        case .cleaning:
            return [TaskPeriod(name: "Period 1", notificationId: nil, interval: .daily(interval: 7))]
        case .repotting:
            return [TaskPeriod(name: "Period 1", notificationId: nil, interval: .yearly(dates: [.init(day: 1, month: 4)]))]
        case .propagation:
            return [TaskPeriod(name: "Period 1", notificationId: nil, interval: .yearly(dates: [.init(day: 1, month: 3)]))]
        }
    }
}
