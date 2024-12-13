//
//  SaveCurrentUserEmailUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 13.12.2024.
//

import Foundation

public protocol SaveCurrentUserEmailUseCase {
    func execute(email: String)
}

public struct SaveCurrentUserEmailUseCaseImpl: SaveCurrentUserEmailUseCase {
    
    private let userRepository: UserRepository
    
    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    public func execute(email: String) {
        try? userRepository.saveUserEmailLocally(email: email)
    }
}
