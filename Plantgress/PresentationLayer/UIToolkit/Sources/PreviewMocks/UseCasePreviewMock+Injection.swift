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
        register { SendEmailVerificationUseCasePreviewMock() as SendEmailVerificationUseCase }
    }
}
