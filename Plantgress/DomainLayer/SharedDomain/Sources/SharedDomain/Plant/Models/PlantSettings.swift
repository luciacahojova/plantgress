//
//  PlantSettings.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import Foundation

public struct PlantSettings: Codable, Sendable {
    public let progressTracking: ProgressTaskConfiguration
    public let tasksConfiguartions: [TaskConfiguration]
    
    public init(
        progressTracking: ProgressTaskConfiguration,
        tasksConfiguartions: [TaskConfiguration]
    ) {
        self.progressTracking = progressTracking
        self.tasksConfiguartions = tasksConfiguartions
    }
}
