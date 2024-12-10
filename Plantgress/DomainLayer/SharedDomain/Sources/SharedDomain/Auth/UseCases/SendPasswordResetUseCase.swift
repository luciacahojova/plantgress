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
    
    public init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    public func execute(email: String) async throws {
        try await authRepository.sendPasswordReset(email: email)
    }
}

