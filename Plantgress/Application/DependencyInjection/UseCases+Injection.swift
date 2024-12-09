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
        // Authentication
        register { IsUserLoggedInUseCaseImpl(authRepository: resolve()) as IsUserLoggedInUseCase }
        register { RegisterUserUseCaseImpl(authRepository: resolve()) as RegisterUserUseCase }
        register { LogInUserUseCaseImpl(authRepository: resolve()) as LogInUserUseCase }
        register { SendEmailVerificationUseCaseImpl(authRepository: resolve()) as SendEmailVerificationUseCase }
        register { ValidateEmailUseCaseImpl() as ValidateEmailUseCase }
        register { ValidatePasswordUseCaseImpl() as ValidatePasswordUseCase }
    }
}
