//
//  PlantSettings.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import Foundation

public struct PlantSettings: Codable, Sendable, Equatable {
    public let tasksConfigurations: [TaskConfiguration]
    
    public init(
        tasksConfigurations: [TaskConfiguration]
    ) {
        self.tasksConfigurations = tasksConfigurations
    }
}
