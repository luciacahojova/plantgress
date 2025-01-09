//
//  ValidatePasswordUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 09.12.2024.
//

import Foundation

/// Protocol defining the use case for validating a password.
public protocol ValidatePasswordUseCase {
    /// Executes the use case to validate a password.
    /// - Parameter password: The password to validate.
    /// - Throws: `AuthError.invalidPasswordFormat` if the password does not meet the required format.
    func execute(password: String) throws
}

/// Implementation of the `ValidatePasswordUseCase` protocol for validating passwords.
public struct ValidatePasswordUseCaseImpl: ValidatePasswordUseCase {
    
    /// Initializes a new instance of `ValidatePasswordUseCaseImpl`.
    public init() {}
    
    /// Executes the use case to validate a password.
    /// - Parameter password: The password to validate.
    /// - Throws: `AuthError.invalidPasswordFormat` if the password does not meet the required format.
    ///
    /// ### Validation Requirements:
    /// - At least 8 characters.
    /// - At least one uppercase letter.
    /// - At least one lowercase letter.
    /// - At least one numeric digit.
    public func execute(password: String) throws {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        
        guard passwordPredicate.evaluate(with: password) else {
            throw AuthError.invalidPasswordFormat
        }
    }
}
