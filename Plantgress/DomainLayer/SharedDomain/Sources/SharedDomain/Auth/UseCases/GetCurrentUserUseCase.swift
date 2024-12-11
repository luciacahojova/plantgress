//
//  GetCurrentUserUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 11.12.2024.
//

import Foundation

public protocol GetCurrentUserUseCase {
    func execute() async throws -> User
}

public struct GetCurrentUserUseCaseImpl: GetCurrentUserUseCase {
    
    private let authRepository: AuthRepository
    private let userRepository: UserRepository
    
    public init(
        authRepository: AuthRepository,
        userRepository: UserRepository
    ) {
        self.authRepository = authRepository
        self.userRepository = userRepository
    }
    
    public func execute() async throws -> User {
        guard let userId = authRepository.getUserId() else {
            throw UserError.notFound
        }
        
        return try await userRepository.getUser(id: userId)
    }
}
