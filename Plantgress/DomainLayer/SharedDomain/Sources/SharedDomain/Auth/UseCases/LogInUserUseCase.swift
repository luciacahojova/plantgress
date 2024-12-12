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
    private let userRepository: UserRepository
    
    public init(
        authRepository: AuthRepository,
        userRepository: UserRepository
    ) {
        self.authRepository = authRepository
        self.userRepository = userRepository
    }
    
    public func execute(credentials: LoginCredentials) async throws {
        try await authRepository.logInUser(credentials: credentials)
        
        guard let userId = authRepository.getUserId() else {
            throw UserError.notFound
        }
        
        let user = try await userRepository.getRemoteUser(id: userId)
        
        try userRepository.saveUserLocally(user: user)
    }
}
