//
//  User.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 11.12.2024.
//

public struct User: Codable, Sendable, Equatable {
    public let id: String
    public let email: String
    public let name: String
    public let surname: String
    
    public init(
        id: String,
        email: String,
        name: String,
        surname: String
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.surname = surname
    }
}
