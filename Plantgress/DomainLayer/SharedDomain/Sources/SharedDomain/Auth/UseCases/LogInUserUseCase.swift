//
//  LogInUserUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 09.12.2024.
//

public protocol LogInUserUseCase {
    func execute(credentials: LoginCredentials) async throws
}

public struct LogInUserUseCaseImpl: LogInUserUseCase {
    
    private let authRepository: AuthRepository
    
    public init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    public func execute(credentials: LoginCredentials) async throws {
        try await authRepository.logInUser(credentials: credentials)
    }
}
