//
//  LogOutUserUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 12.12.2024.
//

public protocol LogOutUserUseCase {
    func execute() throws
}

public struct LogOutUserUseCaseImpl: LogOutUserUseCase {
    
    private let userRepository: UserRepository
    
    public init(
        userRepository: UserRepository
    ) {
        self.userRepository = userRepository
    }
    
    public func execute() throws {
        try userRepository.deleteCurrentUserLocally()
    }
}
