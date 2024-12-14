//
//  GetCurrentUserLocallyUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 12.12.2024.
//

import Foundation

public protocol GetCurrentUserLocallyUseCase {
    func execute() throws -> User
}

public struct GetCurrentUserLocallyUseCaseImpl: GetCurrentUserLocallyUseCase {
    
    private let userRepository: UserRepository
    
    public init(
        userRepository: UserRepository
    ) {
        self.userRepository = userRepository
    }
    
    public func execute() throws -> User {
        return try userRepository.getLocalUser()
    }
}
