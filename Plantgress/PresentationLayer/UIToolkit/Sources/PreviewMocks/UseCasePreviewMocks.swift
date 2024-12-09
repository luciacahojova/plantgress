//
//  UseCasePreviewMocks.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 09.12.2024.
//

import SharedDomain

class LogInUserUseCasePreviewMock: LogInUserUseCase {
    func execute(credentials: LoginCredentials) {}
}

class RegisterUserUseCaseImplePreviewMock: RegisterUserUseCase {
    func execute(credentials: RegistrationCredentials) {}
}

class IsUserLoggedInUseCasePreviewMock: IsUserLoggedInUseCase {
    func execute() -> Bool { return false }
}

class SendEmailVerificationUseCasePreviewMock: SendEmailVerificationUseCase {
    func execute() {}
}
