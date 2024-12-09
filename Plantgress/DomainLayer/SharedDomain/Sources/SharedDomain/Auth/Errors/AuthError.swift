//
//  AuthError.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 09.12.2024.
//

public enum AuthError: Error {
    case userNotFound
    case userNotVerified
    case emailAlreadyVerified
}
