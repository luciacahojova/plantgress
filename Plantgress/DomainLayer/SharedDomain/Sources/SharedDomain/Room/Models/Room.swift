//
//  Room.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import Foundation

public struct Room: Codable, Sendable, Equatable {
    public let id: UUID
    public let name: String
    public let imageUrls: [String]
    
    public init(
        id: UUID,
        name: String,
        imageUrls: [String] = []
    ) {
        self.id = id
        self.name = name
        self.imageUrls = imageUrls
    }
}
