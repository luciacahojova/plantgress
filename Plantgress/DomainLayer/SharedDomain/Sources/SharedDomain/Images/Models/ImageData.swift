//
//  ImageData.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import Foundation

public struct ImageData: Codable, Sendable {
    public let id: UUID
    public let date: Date
    public let urlString: String
    
    public init(
        id: UUID,
        date: Date,
        urlString: String
    ) {
        self.id = id
        self.date = date
        self.urlString = urlString
    }
}
