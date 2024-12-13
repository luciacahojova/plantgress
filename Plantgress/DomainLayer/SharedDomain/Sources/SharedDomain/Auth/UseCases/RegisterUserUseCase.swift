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
    private let userRepository: UserRepository
    
    public init(
        authRepository: AuthRepository,
        userRepository: UserRepository
    ) {
        self.authRepository = authRepository
        self.userRepository = userRepository
    }
    
    public func execute(credentials: RegistrationCredentials) async throws {
        try? userRepository.saveUserEmailLocally(email: credentials.email)
        
        let userId = try await authRepository.registerUser(credentials: credentials)
        
        let user = User(
            id: userId,
            email: credentials.email,
            name: credentials.name,
            surname: credentials.surname
        )
        
        try await userRepository.createUser(user)
    }
}
