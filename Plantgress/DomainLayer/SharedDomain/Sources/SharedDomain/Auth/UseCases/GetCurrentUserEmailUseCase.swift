//
//  GetCurrentUsersEmailUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 10.12.2024.
//

import Foundation

public protocol GetCurrentUsersEmailUseCase {
    func execute() -> String?
}

public struct GetCurrentUsersEmailUseCaseImpl: GetCurrentUsersEmailUseCase {
    
    private let userRepository: UserRepository
    
    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    public func execute() -> String? {
        return try? userRepository.getUserEmailLocally()
    }
}
