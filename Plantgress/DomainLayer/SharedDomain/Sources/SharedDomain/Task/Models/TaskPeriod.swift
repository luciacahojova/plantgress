//
//  TaskPeriod.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import Foundation

public struct TaskPeriod: Codable, Sendable {
    public let name: String // Name for the period, e.g. Period 1
    public let notificationId: String?
    public let interval: TaskInterval // Encapsulates the type and details of the period

    public init(
        name: String,
        notificationId: String?,
        interval: TaskInterval
    ) {
        self.name = name
        self.notificationId = notificationId
        self.interval = interval
    }
}
