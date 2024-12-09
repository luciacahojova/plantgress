//
//  LoginCredentials.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 09.12.2024.
//

public struct LoginCredentials: Sendable {
    public let email: String
    public let password: String
    
    public init(
        email: String,
        password: String
    ) {
        self.email = email
        self.password = password
    }
}
