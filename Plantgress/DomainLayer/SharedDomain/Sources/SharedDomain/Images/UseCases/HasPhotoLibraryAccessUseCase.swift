//
//  HasPhotoLibraryAccessUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 15.12.2024.
//

import Foundation
import Photos

/// Protocol defining the use case for checking photo library access permissions.
public protocol HasPhotoLibraryAccessUseCase {
    /// Executes the use case to check if the app has access to the photo library.
    /// - Throws: `ImagesError.libraryAccessNotGranted` if access is denied or not granted after a prompt.
    func execute() async throws
}

/// Implementation of the `HasPhotoLibraryAccessUseCase` protocol for checking photo library access permissions.
public struct HasPhotoLibraryAccessUseCaseImpl: HasPhotoLibraryAccessUseCase {
    
    /// Initializes a new instance of `HasPhotoLibraryAccessUseCaseImpl`.
    public init() {}
    
    /// Executes the use case to check if the app has access to the photo library.
    /// - Throws: `ImagesError.libraryAccessNotGranted` if access is denied or not granted after a prompt.
    public func execute() async throws {
        // Retrieve the current authorization status for the photo library.
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status {
        case .authorized, .limited:
            // Access already granted.
            return
        case .notDetermined:
            // Prompt the user for access if not previously determined.
            let newStatus = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
            if newStatus != .authorized && newStatus != .limited {
                throw ImagesError.libraryAccessNotGranted
            }
        default:
            // Access denied or restricted.
            throw ImagesError.libraryAccessNotGranted
        }
    }
}
