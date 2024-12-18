//
//  Plant.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import Foundation
import SwiftUI

public struct Plant: Codable, Identifiable, Sendable { // TODO: Past tasks, upcoming tasks
    public let id: UUID
    public let name: String
    public let roomId: UUID?
    public let images: [ImageData]
    public let settings: PlantSettings

    public init(
        id: UUID,
        name: String,
        roomId: UUID?,
        images: [ImageData],
        settings: PlantSettings
    ) {
        self.id = id
        self.name = name
        self.roomId = roomId
        self.images = images
        self.settings = settings
    }
    
    public init(
        copy: Plant,
        id: UUID? = nil,
        name: String? = nil,
        roomId: UUID? = nil,
        images: [ImageData]? = nil,
        settings: PlantSettings? = nil
    ) {
        self.id = id ?? copy.id
        self.name = name ?? copy.name
        self.roomId = roomId ?? copy.roomId
        self.images = images ?? copy.images
        self.settings = settings ?? copy.settings
    }
}
