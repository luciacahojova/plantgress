//
//  PlantSettings.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import Foundation

public struct PlantSettings: Codable, Sendable, Equatable {
    public let tasksConfiguartions: [TaskConfiguration]
    
    public init(
        tasksConfiguartions: [TaskConfiguration]
    ) {
        self.tasksConfiguartions = tasksConfiguartions
    }
}
