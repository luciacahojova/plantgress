//
//  PrepareImagesForSharingUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 01.01.2025.
//

import Foundation
import UIKit

/// Protocol defining the use case for preparing images for sharing.
public protocol PrepareImagesForSharingUseCase {
    /// Executes the use case to prepare images for sharing.
    /// - Parameter images: An array of `ImageData` objects to process.
    /// - Returns: An array of `UIImage` objects ready for sharing.
    /// - Throws: An error if the preparation process fails.
    func execute(images: [ImageData]) async throws -> [UIImage]
}

/// Implementation of the `PrepareImagesForSharingUseCase` protocol for preparing images for sharing.
public struct PrepareImagesForSharingUseCaseImpl: PrepareImagesForSharingUseCase {
    
    /// The repository for managing image-related operations.
    private let imagesRepository: ImagesRepository
    
    /// Initializes a new instance of `PrepareImagesForSharingUseCaseImpl`.
    /// - Parameter imagesRepository: The `ImagesRepository` for interacting with image data.
    public init(imagesRepository: ImagesRepository) {
        self.imagesRepository = imagesRepository
    }
    
    /// Executes the use case to prepare images for sharing.
    /// - Parameter images: An array of `ImageData` objects to process.
    /// - Returns: An array of `UIImage` objects ready for sharing.
    /// - Throws: An error if the preparation process fails.
    public func execute(images: [ImageData]) async throws -> [UIImage] {
        // Use the repository to prepare the images for sharing.
        try await imagesRepository.prepareImagesForSharing(images: images)
    }
}
