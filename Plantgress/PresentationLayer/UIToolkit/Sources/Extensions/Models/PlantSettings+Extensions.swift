//
//  PlantSettings+Extensions.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import SharedDomain

public extension PlantSettings {
    static var mock: PlantSettings {
        PlantSettings(
            tasksConfiguartions: .mock
        )
    }
    
    static var `default`: PlantSettings {
        PlantSettings(
            tasksConfiguartions: .default
        )
    }
}
