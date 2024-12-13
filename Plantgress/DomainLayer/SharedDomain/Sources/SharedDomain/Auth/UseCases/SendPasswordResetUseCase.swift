//
//  SendPasswordResetUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 10.12.2024.
//

public protocol SendPasswordResetUseCase {
    func execute(email: String) async throws
}

public struct SendPasswordResetUseCaseImpl: SendPasswordResetUseCase {
    
    private let authRepository: AuthRepository
    private let userRepository: UserRepository
    
    public init(
        authRepository: AuthRepository,
        userRepository: UserRepository
    ) {
        self.authRepository = authRepository
        self.userRepository = userRepository
    }
    
    public func execute(email: String) async throws {
        try? userRepository.saveUserEmailLocally(email: email)
        
        try await authRepository.sendPasswordReset(email: email)
    }
}

