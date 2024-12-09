//
//  ValidatePasswordUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 09.12.2024.
//

import Foundation

public protocol ValidatePasswordUseCase {
    func execute(password: String) throws
}

public struct ValidatePasswordUseCaseImpl: ValidatePasswordUseCase {
    
    public init() {}
    
    public func execute(password: String) throws {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        
        guard passwordPredicate.evaluate(with: password) else {
            throw AuthError.invalidPasswordFormat
        }
    }
}
