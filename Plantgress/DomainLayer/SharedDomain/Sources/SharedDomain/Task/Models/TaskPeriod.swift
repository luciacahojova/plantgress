//
//  TaskPeriod.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import Foundation

public struct TaskPeriod: Codable, Sendable {
    public let id: UUID // Unique identifier for the period
    public let name: String // Name for the period, e.g., Period 1
    public let interval: TaskInterval // Encapsulates the type and details of the period

    public init(
        id: UUID,
        name: String,
        interval: TaskInterval
    ) {
        self.id = id
        self.name = name
        self.interval = interval
    }
}
