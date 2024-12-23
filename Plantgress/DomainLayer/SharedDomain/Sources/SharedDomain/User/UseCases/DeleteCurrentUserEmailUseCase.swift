//
//  DeleteCurrentUserEmailUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 13.12.2024.
//

import Foundation

public protocol DeleteCurrentUserEmailUseCase {
    func execute()
}

public struct DeleteCurrentUserEmailUseCaseImpl: DeleteCurrentUserEmailUseCase {
    
    private let userRepository: UserRepository
    
    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    public func execute() {
        try? userRepository.deleteUserEmailLocally()
    }
}
