//
//  HasCameraAccessUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 15.12.2024.
//

import Foundation
import AVFoundation

public protocol HasCameraAccessUseCase {
    func execute() async throws
}

public struct HasCameraAccessUseCaseImpl: HasCameraAccessUseCase {
    
    public init() {}
    
    public func execute() async throws {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
                
        switch status {
        case .authorized:
            return
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            if !granted {
                throw ImagesError.cameraAccessNotGranted
            }
        default:
            throw ImagesError.cameraAccessNotGranted
        }
    }
}
