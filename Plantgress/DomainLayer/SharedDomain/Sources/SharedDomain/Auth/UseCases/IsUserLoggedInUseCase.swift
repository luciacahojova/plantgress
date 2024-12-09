//
//  IsUserLoggedInUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 08.12.2024.
//

import Foundation

public protocol IsUserLoggedInUseCase {
    func execute() -> Bool
}

public struct IsUserLoggedInUseCaseImpl: IsUserLoggedInUseCase {
    
    private let authRepository: AuthRepository
    
    public init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    public func execute() -> Bool {
        return authRepository.isUserLoggedIn()
    }
}
