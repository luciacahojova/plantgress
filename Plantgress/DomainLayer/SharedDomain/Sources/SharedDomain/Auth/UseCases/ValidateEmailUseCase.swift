//
//  ValidateEmailUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 09.12.2024.
//

import Foundation

public protocol ValidateEmailUseCase {
    func execute(email: String) throws
}

public struct ValidateEmailUseCaseImpl: ValidateEmailUseCase {
    
    public init() {}
    
    public func execute(email: String) throws {
        let emailRegex = "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        
        guard emailPredicate.evaluate(with: email) else {
            throw AuthError.invalidEmailFormat
        }
    }
}
