//
//  RegistrationCredentials.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 09.12.2024.
//

public struct RegistrationCredentials: Sendable {
    public let email: String
    public let name: String
    public let surname: String
    public let password: String
    
    public init(
        email: String,
        name: String,
        surname: String,
        password: String
    ) {
        self.email = email
        self.name = name
        self.surname = surname
        self.password = password
    }
}
