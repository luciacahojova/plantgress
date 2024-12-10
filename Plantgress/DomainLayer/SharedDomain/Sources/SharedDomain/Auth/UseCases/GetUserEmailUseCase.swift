//
//  GetUserEmailUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 10.12.2024.
//

import Foundation

public protocol GetUserEmailUseCase {
    func execute() -> String?
}

public struct GetUserEmailUseCaseImpl: GetUserEmailUseCase {
    
    private let authRepository: AuthRepository
    
    public init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    public func execute() -> String? {
        return authRepository.getUserEmail()
    }
}
