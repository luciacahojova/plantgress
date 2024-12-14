//
//  ProgressTaskConfiguration+Extensions.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import Foundation
import SharedDomain

public extension ProgressTaskConfiguration {
    static var mock: ProgressTaskConfiguration {
        ProgressTaskConfiguration(
            isTracked: true,
            hasAlert: true,
            startDate: Date(),
            scheduledTime: DateComponents(hour: 9, minute: 0),
            interval: .daily(interval: 10)
        )
    }
}
