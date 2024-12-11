//
//  GetCurrentUsersEmailUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 10.12.2024.
//

import Foundation

public protocol GetCurrentUsersEmailUseCase {
    func execute() -> String?
}

public struct GetCurrentUsersEmailUseCaseImpl: GetCurrentUsersEmailUseCase {
    
    private let authRepository: AuthRepository
    
    public init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    public func execute() -> String? {
        return authRepository.getUserEmail()
    }
}
