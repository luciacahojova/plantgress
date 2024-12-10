//
//  AuthError.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 09.12.2024.
//

import Foundation

public enum AuthError: Error {
    case `default`
    
    case userNotFound
    case emailNotVerified
    case emailAlreadyVerified
    
    case invalidEmail
    case wrongPassword
    
    case emailAlreadyInUse
    
    case invalidEmailFormat
    case invalidPasswordFormat
    
    case tooManyRequests
}
