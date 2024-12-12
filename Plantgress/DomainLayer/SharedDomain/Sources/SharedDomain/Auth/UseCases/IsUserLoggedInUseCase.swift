//
//  IsUserLoggedInUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 08.12.2024.
//

import Foundation

public protocol IsUserLoggedInUseCase {
    func execute() -> Bool
}

public struct IsUserLoggedInUseCaseImpl: IsUserLoggedInUseCase {
    
    private let userRepository: UserRepository
    
    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    public func execute() -> Bool {
        return userRepository.isUserLoggedIn()
    }
}
