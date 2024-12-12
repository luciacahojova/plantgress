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
        register { IsEmailVerifiedUseCaseImpl(authRepository: resolve()) as IsEmailVerifiedUseCase }
        register { RegisterUserUseCaseImpl(authRepository: resolve(), userRepository: resolve()) as RegisterUserUseCase }
        register { LogInUserUseCaseImpl(authRepository: resolve(), userRepository: resolve()) as LogInUserUseCase }
        register { SendEmailVerificationUseCaseImpl(authRepository: resolve()) as SendEmailVerificationUseCase }
        register { ValidateEmailUseCaseImpl() as ValidateEmailUseCase }
        register { ValidatePasswordUseCaseImpl() as ValidatePasswordUseCase }
        register { GetCurrentUsersEmailUseCaseImpl(authRepository: resolve()) as GetCurrentUsersEmailUseCase }
        register { GetCurrentUserRemotelyUseCaseImpl(authRepository: resolve(), userRepository: resolve()) as GetCurrentUserRemotelyUseCase }
        register { GetCurrentUserLocallyUseCaseImpl(userRepository: resolve()) as GetCurrentUserLocallyUseCase }
        register { SendPasswordResetUseCaseImpl(authRepository: resolve()) as SendPasswordResetUseCase }
    }
}
