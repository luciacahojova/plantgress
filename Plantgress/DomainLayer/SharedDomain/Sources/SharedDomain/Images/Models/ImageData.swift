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
    public let isLoading: Bool
    
    public init(
        id: UUID,
        date: Date,
        urlString: String,
        isLoading: Bool = false
    ) {
        self.id = id
        self.date = date
        self.urlString = urlString
        self.isLoading = isLoading
    }
    
    public init(
        copy: ImageData,
        id: UUID? = nil,
        date: Date? = nil,
        urlString: String? = nil,
        isLoading: Bool? = nil
    ) {
        self.id = id ?? copy.id
        self.date = date ?? copy.date
        self.urlString = urlString ?? copy.urlString
        self.isLoading = isLoading ?? copy.isLoading
    }
}
