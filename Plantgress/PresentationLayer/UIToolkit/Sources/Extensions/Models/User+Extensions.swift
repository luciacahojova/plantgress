//
//  User+Extensions.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 12.12.2024.
//

import SharedDomain

public extension User {
    static var mock: User {
        User(
            id: "0",
            email: "test@test.test",
            name: "Test",
            surname: "Tester"
        )
    }
}
