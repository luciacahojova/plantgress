//
//  UploadImageUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import Foundation

/// Protocol defining the use case for uploading an image.
public protocol UploadImageUseCase {
    /// Executes the use case to upload an image for a specified user.
    /// - Parameters:
    ///   - userId: The unique identifier of the user uploading the image.
    ///   - imageId: The unique identifier for the image.
    ///   - imageData: The image data to upload.
    /// - Returns: The URL of the uploaded image.
    /// - Throws: An error if the upload process fails.
    func execute(userId: String, imageId: String, imageData: Data) async throws -> URL
}

/// Implementation of the `UploadImageUseCase` protocol for uploading an image.
public struct UploadImageUseCaseImpl: UploadImageUseCase {
    
    /// The repository for managing image-related operations.
    private let imagesRepository: ImagesRepository
    
    /// Initializes a new instance of `UploadImageUseCaseImpl`.
    /// - Parameter imagesRepository: The `ImagesRepository` for interacting with image data.
    public init(imagesRepository: ImagesRepository) {
        self.imagesRepository = imagesRepository
    }
    
    /// Executes the use case to upload an image for a specified user.
    /// - Parameters:
    ///   - userId: The unique identifier of the user uploading the image.
    ///   - imageId: The unique identifier for the image.
    ///   - imageData: The image data to upload.
    /// - Returns: The URL of the uploaded image.
    /// - Throws: An error if the upload process fails.
    public func execute(userId: String, imageId: String, imageData: Data) async throws -> URL {
        // Upload the image using the repository and return its URL.
        try await imagesRepository.uploadImage(userId: userId, imageId: imageId, imageData: imageData)
    }
}
