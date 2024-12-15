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
        register { IsUserLoggedInUseCaseImpl(userRepository: resolve()) as IsUserLoggedInUseCase }
        register { IsEmailVerifiedUseCaseImpl(authRepository: resolve()) as IsEmailVerifiedUseCase }
        register { RegisterUserUseCaseImpl(authRepository: resolve(), userRepository: resolve()) as RegisterUserUseCase }
        register { LogInUserUseCaseImpl(authRepository: resolve(), userRepository: resolve()) as LogInUserUseCase }
        register { SendEmailVerificationUseCaseImpl(authRepository: resolve()) as SendEmailVerificationUseCase }
        register { ValidateEmailUseCaseImpl() as ValidateEmailUseCase }
        register { ValidatePasswordUseCaseImpl() as ValidatePasswordUseCase }
        register { GetCurrentUsersEmailUseCaseImpl(userRepository: resolve()) as GetCurrentUsersEmailUseCase }
        register { GetCurrentUserRemotelyUseCaseImpl(authRepository: resolve(), userRepository: resolve()) as GetCurrentUserRemotelyUseCase }
        register { GetCurrentUserLocallyUseCaseImpl(userRepository: resolve()) as GetCurrentUserLocallyUseCase }
        register { SendPasswordResetUseCaseImpl(authRepository: resolve(), userRepository: resolve()) as SendPasswordResetUseCase }
        register { LogOutUserUseCaseImpl(userRepository: resolve()) as LogOutUserUseCase }
        register { DeleteUserUseCaseImpl(authRepository: resolve(), userRepository: resolve()) as DeleteUserUseCase }
        register { SaveCurrentUserEmailUseCaseImpl(userRepository: resolve()) as SaveCurrentUserEmailUseCase }
        register { DeleteCurrentUserEmailUseCaseImpl(userRepository: resolve()) as DeleteCurrentUserEmailUseCase }
        
        // Images
        register { UploadImageUseCaseImpl(imagesRepository: resolve()) as UploadImageUseCase }
        register { HasCameraAccessUseCaseImpl() as HasCameraAccessUseCase }
        register { HasPhotoLibraryAccessUseCaseImpl() as HasPhotoLibraryAccessUseCase }

    }
}
