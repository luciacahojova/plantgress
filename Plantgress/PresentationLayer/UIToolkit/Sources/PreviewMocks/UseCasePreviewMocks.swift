//
//  UseCasePreviewMocks.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 09.12.2024.
//

import Foundation
import SharedDomain
import SwiftUI

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
    func execute() -> User { return .mock }
}

class GetCurrentUserLocallyUseCasePreviewMock: GetCurrentUserLocallyUseCase {
    func execute() -> User { return .mock }
}

class SendPasswordResetUseCasePreviewMock: SendPasswordResetUseCase {
    func execute(email: String) {}
}

class LogOutUserUseCasePreviewMock: LogOutUserUseCase {
    func execute() throws {}
}

class DeleteUserUseCasePreviewMock: DeleteUserUseCase {
    func execute(userId: String) async throws {}
}

class SaveCurrentUserEmailUseCasePreviewMock: SaveCurrentUserEmailUseCase {
    func execute(email: String) {}
}

class DeleteCurrentUserEmailUseCasePreviewMock: DeleteCurrentUserEmailUseCase {
    func execute() {}
}

class UploadImageUseCasePreviewMock: UploadImageUseCase {
    func execute(userId: String, imageId: String, imageData: Data) async throws -> URL {
        guard let url = URL(string: "") else {
            throw ImagesError.invalidUrl
        }
        
        return url
    }
}

class DownloadImageUseCasePreviewMock: DownloadImageUseCase {
    func execute(urlString: String) async -> Image? {
        do {
            guard let url = URL(string: urlString) else { return nil }
            let cache = URLCache.shared
            let urlRequest = URLRequest(url: url)
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            if cache.cachedResponse(for: urlRequest) == nil {
                cache.storeCachedResponse(CachedURLResponse(response: response, data: data), for: urlRequest)
            }
            
            guard let uiImage = UIImage(data: data) else { return nil }
            return Image(uiImage: uiImage)
        } catch {
            return nil
        }
    }
}

class HasPhotoLibraryAccessUseCasePreviewMock: HasPhotoLibraryAccessUseCase {
    func execute() {}
}

class HasCameraAccessUseCasePreviewMock: HasCameraAccessUseCase {
    func execute() {}
}
