//
//  DownloadImageUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 15.12.2024.
//

import Foundation
import SwiftUI

/// Protocol defining the use case for downloading an image.
public protocol DownloadImageUseCase {
    /// Executes the use case to download an image from the specified URL.
    /// - Parameter urlString: The string representation of the image URL.
    /// - Returns: A `SwiftUI.Image` if the download succeeds, or `nil` if it fails.
    func execute(urlString: String) async -> Image?
}

/// Implementation of the `DownloadImageUseCase` protocol for downloading an image.
public struct DownloadImageUseCaseImpl: DownloadImageUseCase {
    
    /// The repository for managing image-related operations.
    private let imagesRepository: ImagesRepository
    
    /// Initializes a new instance of `DownloadImageUseCaseImpl`.
    /// - Parameter imagesRepository: The `ImagesRepository` for interacting with image data.
    public init(imagesRepository: ImagesRepository) {
        self.imagesRepository = imagesRepository
    }
    
    /// Executes the use case to download an image from the specified URL.
    /// - Parameter urlString: The string representation of the image URL.
    /// - Returns: A `SwiftUI.Image` if the download succeeds, or `nil` if it fails.
    public func execute(urlString: String) async -> Image? {
        // Use the repository to download the image and return it.
        await imagesRepository.downloadImage(urlString: urlString)
    }
}
