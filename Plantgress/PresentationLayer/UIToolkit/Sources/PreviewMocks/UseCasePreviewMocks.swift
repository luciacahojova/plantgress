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

class IsEmailVerifiedUseCasePreviewMock: IsEmailVerifiedUseCase {
    func execute() -> Bool { return false }
}

class SendEmailVerificationUseCasePreviewMock: SendEmailVerificationUseCase {
    func execute() {}
}

class ValidateEmailUseCasePreviewMock: ValidateEmailUseCase {
    func execute(email: String) throws {}
}

class ValidatePasswordUseCasePreviewMock: ValidatePasswordUseCase {
    func execute(password: String) throws {}
}

class GetCurrentUsersEmailUseCasePreviewMock: GetCurrentUsersEmailUseCase {
    func execute() -> String? { return nil }
}

class GetCurrentUserRemotelyUseCasePreviewMock: GetCurrentUserRemotelyUseCase {
    func execute() -> User { return User(id: "", email: "", name: "", surname: "") } // TODO: .mock
}

class GetCurrentUserLocallyUseCasePreviewMock: GetCurrentUserLocallyUseCase {
    func execute() -> User { return User(id: "", email: "", name: "", surname: "") } // TODO: .mock
}

class SendPasswordResetUseCasePreviewMock: SendPasswordResetUseCase {
    func execute(email: String) {}
}
