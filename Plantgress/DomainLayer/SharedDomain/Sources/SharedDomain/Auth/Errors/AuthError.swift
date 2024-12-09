//
//  AuthError.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 09.12.2024.
//

import Foundation

public enum AuthError: Error {
    case userNotFound
    case emailNotVerified
    case emailAlreadyVerified
    
    case invalidEmailFormat
    case invalidPasswordFormat
}
