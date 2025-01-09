//
//  DeleteImageUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 28.12.2024.
//

import Foundation

/// Protocol defining the use case for deleting an image.
public protocol DeleteImageUseCase {
    /// Executes the use case to delete an image for a specified user.
    /// - Parameters:
    ///   - userId: The unique identifier of the user.
    ///   - imageId: The unique identifier of the image to delete.
    /// - Throws: An error if the deletion process fails.
    func execute(userId: String, imageId: UUID) async throws
}

/// Implementation of the `DeleteImageUseCase` protocol for deleting an image.
public struct DeleteImageUseCaseImpl: DeleteImageUseCase {
    
    /// The repository for managing image-related operations.
    private let imagesRepository: ImagesRepository
    
    /// Initializes a new instance of `DeleteImageUseCaseImpl`.
    /// - Parameter imagesRepository: The `ImagesRepository` for interacting with image data.
    public init(imagesRepository: ImagesRepository) {
        self.imagesRepository = imagesRepository
    }
    
    /// Executes the use case to delete an image for a specified user.
    /// - Parameters:
    ///   - userId: The unique identifier of the user.
    ///   - imageId: The unique identifier of the image to delete.
    /// - Throws: An error if the deletion process fails.
    public func execute(userId: String, imageId: UUID) async throws {
        // Delete the image using the repository.
        try await imagesRepository.delete(userId: userId, imageId: imageId.uuidString)
    }
}
