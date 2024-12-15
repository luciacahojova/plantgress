//
//  UseCasePreviewMock+Injection.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 09.12.2024.
//

import Resolver
import SharedDomain

public extension Resolver {
    static func registerUseCasesForPreviews() {
        // Authentication
        register { LogInUserUseCasePreviewMock() as LogInUserUseCase }
        register { RegisterUserUseCaseImplePreviewMock() as RegisterUserUseCase }
        register { IsUserLoggedInUseCasePreviewMock() as IsUserLoggedInUseCase }
        register { IsEmailVerifiedUseCasePreviewMock() as IsEmailVerifiedUseCase }
        register { SendEmailVerificationUseCasePreviewMock() as SendEmailVerificationUseCase }
        register { ValidateEmailUseCasePreviewMock() as ValidateEmailUseCase }
        register { ValidatePasswordUseCasePreviewMock() as ValidatePasswordUseCase }
        register { GetCurrentUsersEmailUseCasePreviewMock() as GetCurrentUsersEmailUseCase }
        register { GetCurrentUserRemotelyUseCasePreviewMock() as GetCurrentUserRemotelyUseCase }
        register { GetCurrentUserLocallyUseCasePreviewMock() as GetCurrentUserLocallyUseCase }
        register { SendPasswordResetUseCasePreviewMock() as SendPasswordResetUseCase }
        register { LogOutUserUseCasePreviewMock() as LogOutUserUseCase }
        register { DeleteUserUseCasePreviewMock() as DeleteUserUseCase }
        register { SaveCurrentUserEmailUseCasePreviewMock() as SaveCurrentUserEmailUseCase }
        
        register { DeleteCurrentUserEmailUseCasePreviewMock() as DeleteCurrentUserEmailUseCase }
        register { UploadImageUseCasePreviewMock() as UploadImageUseCase }
        register { HasCameraAccessUseCasePreviewMock() as HasCameraAccessUseCase }
        register { HasPhotoLibraryAccessUseCasePreviewMock() as HasPhotoLibraryAccessUseCase }
    }
}
