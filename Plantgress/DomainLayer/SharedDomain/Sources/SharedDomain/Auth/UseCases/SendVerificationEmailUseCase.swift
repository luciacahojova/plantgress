//
//  SendVerificationEmailUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 09.12.2024.
//

public protocol SendEmailVerificationUseCase {
    func execute() async throws
}

public struct SendEmailVerificationUseCaseImpl: SendEmailVerificationUseCase {
    
    private let authRepository: AuthRepository
    
    public init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    public func execute() async throws {
        try await authRepository.sendEmailVerification()
    }
}

