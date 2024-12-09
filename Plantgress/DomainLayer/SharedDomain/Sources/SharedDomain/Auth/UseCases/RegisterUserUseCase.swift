//
//  RegisterUserUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 09.12.2024.
//

public protocol RegisterUserUseCase {
    func execute(credentials: RegistrationCredentials) async throws
}

public struct RegisterUserUseCaseImpl: RegisterUserUseCase {
    
    private let authRepository: AuthRepository
    
    public init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    public func execute(credentials: RegistrationCredentials) async throws {
        try await authRepository.registerUser(credentials: credentials)
    }
}
