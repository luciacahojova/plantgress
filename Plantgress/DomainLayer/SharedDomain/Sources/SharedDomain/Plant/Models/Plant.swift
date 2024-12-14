//
//  Plant.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import Foundation
import SwiftUI

public struct Plant: Codable, Identifiable { // TODO: Past tasks, upcoming tasks
    public let id: UUID
    public let name: String
    public let images: [ImageData]
    public let settings: PlantSettings

    public init(
        id: UUID,
        name: String,
        images: [ImageData],
        settings: PlantSettings
    ) {
        self.id = id
        self.name = name
        self.images = images
        self.settings = settings
    }
}
