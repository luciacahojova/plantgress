//
//  HasPhotoLibraryAccessUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 15.12.2024.
//

import Foundation
import Photos

public protocol HasPhotoLibraryAccessUseCase {
    func execute() async throws
}

public struct HasPhotoLibraryAccessUseCaseImpl: HasPhotoLibraryAccessUseCase {
    
    public init() {}
    
    public func execute() async throws {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status {
        case .authorized, .limited:
            return
        case .notDetermined:
            let newStatus = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
            if newStatus != .authorized && newStatus != .limited {
                throw ImagesError.libraryAccessNotGranted
            }
        default:
            throw ImagesError.libraryAccessNotGranted
        }
    }
}

