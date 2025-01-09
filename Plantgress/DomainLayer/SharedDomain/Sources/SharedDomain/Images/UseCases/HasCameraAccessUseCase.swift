//
//  HasCameraAccessUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 15.12.2024.
//

import Foundation
import AVFoundation

/// Protocol defining the use case for checking camera access permissions.
public protocol HasCameraAccessUseCase {
    /// Executes the use case to check if the app has access to the camera.
    /// - Throws: `ImagesError.cameraAccessNotGranted` if access is denied.
    func execute() async throws
}

/// Implementation of the `HasCameraAccessUseCase` protocol for checking camera access permissions.
public struct HasCameraAccessUseCaseImpl: HasCameraAccessUseCase {
    
    /// Initializes a new instance of `HasCameraAccessUseCaseImpl`.
    public init() {}
    
    /// Executes the use case to check if the app has access to the camera.
    /// - Throws: `ImagesError.cameraAccessNotGranted` if access is denied or not granted after a prompt.
    public func execute() async throws {
        // Retrieve the current authorization status for the camera.
        let status = AVCaptureDevice.authorizationStatus(for: .video)
                
        switch status {
        case .authorized:
            // Access already granted.
            return
        case .notDetermined:
            // Prompt the user for access if not previously determined.
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            if !granted {
                throw ImagesError.cameraAccessNotGranted
            }
        default:
            // Access denied or restricted.
            throw ImagesError.cameraAccessNotGranted
        }
    }
}
