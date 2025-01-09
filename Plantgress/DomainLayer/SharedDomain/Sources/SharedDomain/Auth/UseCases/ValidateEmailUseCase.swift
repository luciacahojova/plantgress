//
//  ValidateEmailUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 09.12.2024.
//

import Foundation

/// Protocol defining the use case for validating an email address.
public protocol ValidateEmailUseCase {
    /// Executes the use case to validate an email address.
    /// - Parameter email: The email address to validate.
    /// - Throws: `AuthError.invalidEmailFormat` if the email address is not in a valid format.
    func execute(email: String) throws
}

/// Implementation of the `ValidateEmailUseCase` protocol for validating email addresses.
public struct ValidateEmailUseCaseImpl: ValidateEmailUseCase {
    
    /// Initializes a new instance of `ValidateEmailUseCaseImpl`.
    public init() {}
    
    /// Executes the use case to validate an email address.
    /// - Parameter email: The email address to validate.
    /// - Throws: `AuthError.invalidEmailFormat` if the email address is not in a valid format.
    public func execute(email: String) throws {
        let emailRegex = "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        guard emailPredicate.evaluate(with: email) else {
            throw AuthError.invalidEmailFormat
        }
    }
}
