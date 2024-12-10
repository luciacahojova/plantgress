//
//  File.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 10.12.2024.
//

import Foundation

public protocol IsEmailVerifiedUseCase {
    func execute() -> Bool
}

public struct IsEmailVerifiedUseCaseImpl: IsEmailVerifiedUseCase {
    
    private let authRepository: AuthRepository
    
    public init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    public func execute() -> Bool {
        return authRepository.isEmailVerified()
    }
}
