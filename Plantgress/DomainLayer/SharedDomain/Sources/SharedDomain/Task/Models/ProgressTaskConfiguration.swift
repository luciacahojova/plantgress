//
//  ProgressTaskConfiguration.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import Foundation

public struct ProgressTaskConfiguration: Codable {
    public let isTracked: Bool
    public let hasAlert: Bool
    public let startDate: Date
    public let scheduledTime: DateComponents
    public let interval: TaskInterval
    
    public init(
        isTracked: Bool,
        hasAlert: Bool,
        startDate: Date,
        scheduledTime: DateComponents,
        interval: TaskInterval
    ) {
        self.isTracked = isTracked
        self.hasAlert = hasAlert
        self.startDate = startDate
        self.scheduledTime = scheduledTime
        self.interval = interval
    }
}
