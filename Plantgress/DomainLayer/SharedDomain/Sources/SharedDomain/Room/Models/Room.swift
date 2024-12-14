//
//  Room.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import Foundation

public struct Room: Codable {
    public let id: UUID
    public let name: String
    public let plantIds: [UUID]
    public let imageUrls: [String]
}
