//
//  UseCases+Injection.swift
//  Plantgress
//
//  Created by Lucia Cahojova on 03.12.2024.
//

import Resolver
import SharedDomain

public extension Resolver {
    static func registerUseCases() {
        
        register { IsUserLoggedInUseCaseImpl(authRepository: resolve()) as IsUserLoggedInUseCase }
        
    }
}
