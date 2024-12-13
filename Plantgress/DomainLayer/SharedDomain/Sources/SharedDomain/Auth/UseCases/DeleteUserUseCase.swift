//
//  DeleteUserUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 12.12.2024.
//

import Foundation

public protocol DeleteUserUseCase {
    func execute(userId: String) async throws
}

public struct DeleteUserUseCaseImpl: DeleteUserUseCase {
    
    private let authRepository: AuthRepository
    private let userRepository: UserRepository
    
    public init(
        authRepository: AuthRepository,
        userRepository: UserRepository
    ) {
        self.authRepository = authRepository
        self.userRepository = userRepository
    }
    
    public func execute(userId: String) async throws {
        authRepository.deleteUser()
        try await userRepository.deleteUser(userId: userId)
        try? userRepository.deleteUserEmailLocally()
    }
}
