//
//  ImagesRepository.swift
//  ImagesToolkit
//
//  Created by Lucia Cahojova on 11.12.2024.
//

import FirebaseStorageProvider
import Foundation
import SharedDomain
import SwiftUI
import Utilities

/// Implementation of the `ImagesRepository` protocol for managing image storage and processing in Firestore.
public struct ImagesRepositoryImpl: ImagesRepository {
    
    /// Firebase Storage provider for image storage operations.
    private let firebaseStorageProvider: FirebaseStorageProvider
    
    /// Initializes a new instance of `ImagesRepositoryImpl`.
    /// - Parameter firebaseStorageProvider: The Firebase Storage provider for handling image-related operations.
    public init(firebaseStorageProvider: FirebaseStorageProvider) {
        self.firebaseStorageProvider = firebaseStorageProvider
    }
    
    /// Uploads an image to Firebase Storage.
    /// - Parameters:
    ///   - userId: The user ID associated with the image.
    ///   - imageId: The unique identifier for the image.
    ///   - imageData: The image data to upload.
    /// - Returns: The URL of the uploaded image.
    /// - Throws: An error if the upload fails.
    public func uploadImage(userId: String, imageId: String, imageData: Data) async throws -> URL {
        let imagePath = DatabaseConstants.imagePath(userId: userId, imageId: imageId)
        
        return try await firebaseStorageProvider.upload(
            path: imagePath,
            data: imageData,
            metadata: nil
        )
    }
    
    /// Prepares images for sharing by adding text overlays with their associated dates.
    /// - Parameter images: The list of images containing metadata such as URLs and dates.
    /// - Returns: A list of processed `UIImage` objects ready for sharing.
    /// - Throws: An error if the preparation process fails.
    public func prepareImagesForSharing(images: [ImageData]) async throws -> [UIImage] {
        var imagesToShare: [UIImage] = []
        
        for image in images {
            guard let urlString = image.urlString else {
                throw ImagesError.invalidUrl
            }
            
            guard let uiImage = try await downloadUiImage(urlString: urlString) else {
                throw ImagesError.preparingImageFailed
            }
            
            guard let imageWithDate = addTextOverlayToImage(image: uiImage, date: image.date) else {
                throw ImagesError.preparingImageFailed
            }
            
            imagesToShare.append(imageWithDate)
        }
        
        return imagesToShare
    }
    
    /// Downloads a `UIImage` from a given URL string.
    /// - Parameter urlString: The URL string of the image to download.
    /// - Returns: The downloaded `UIImage`, or `nil` if the operation fails.
    /// - Throws: An error if the download fails.
    func downloadUiImage(urlString: String) async throws -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        let cache = URLCache.shared
        let urlRequest = URLRequest(url: url)
        
        if let cachedResponse = cache.cachedResponse(for: urlRequest) {
            return UIImage(data: cachedResponse.data)
        }
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        let cachedResponse = CachedURLResponse(response: response, data: data)
        cache.storeCachedResponse(cachedResponse, for: urlRequest)
        
        return UIImage(data: data)
    }
    
    /// Resizes an image to a specified target width while maintaining its aspect ratio.
    /// - Parameters:
    ///   - image: The original `UIImage` to resize.
    ///   - targetWidth: The desired width of the resized image.
    /// - Returns: The resized `UIImage`, or `nil` if resizing fails.
    func resizeImage(image: UIImage, targetWidth: CGFloat) -> UIImage? {
        let aspectRatio = image.size.height / image.size.width
        let targetHeight = targetWidth * aspectRatio
        let targetSize = CGSize(width: targetWidth, height: targetHeight)
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }

    /// Adds a text overlay with date information to an image.
    /// - Parameters:
    ///   - image: The original `UIImage` to modify.
    ///   - date: The date to display as a text overlay.
    /// - Returns: The modified `UIImage` with the text overlay, or `nil` if the operation fails.
    func addTextOverlayToImage(image: UIImage, date: Date) -> UIImage? {
        let targetWidth: CGFloat = 1024
        guard let resizedImage = resizeImage(image: image, targetWidth: targetWidth) else {
            return nil
        }
        
        let renderer = UIGraphicsImageRenderer(size: resizedImage.size)
        return renderer.image { context in
            // Draw the resized image
            resizedImage.draw(at: .zero)
            
            // Configure text attributes
            let attributesTop: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 40, weight: .semibold),
                .foregroundColor: UIColor.white
            ]
            let attributesBottom: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 30, weight: .medium),
                .foregroundColor: UIColor.white
            ]
            
            // Inline Date Formatting
            let dateFormatter = DateFormatter()
            
            // Format for top text (e.g., "Dec 30, 2024")
            dateFormatter.dateFormat = "MMM d, yyyy"
            let dateTopText = dateFormatter.string(from: date)
            
            // Format for bottom text (e.g., "15:30")
            dateFormatter.dateFormat = "HH:mm"
            let dateBottomText = dateFormatter.string(from: date)
            
            // Calculate text positions
            let textTopPosition = CGPoint(x: 16, y: resizedImage.size.height - 120)
            let textBottomPosition = CGPoint(x: 16, y: resizedImage.size.height - 80)
            
            // Draw the text
            dateTopText.draw(at: textTopPosition, withAttributes: attributesTop)
            dateBottomText.draw(at: textBottomPosition, withAttributes: attributesBottom)
        }
    }
    
    /// Downloads an image and converts it into a SwiftUI `Image`.
    /// - Parameter urlString: The URL string of the image to download.
    /// - Returns: A SwiftUI `Image` object, or `nil` if the operation fails.
    public func downloadImage(urlString: String) async -> Image? {
        do {
            guard let url = URL(string: urlString) else { return nil }
            let cache = URLCache.shared
            let urlRequest = URLRequest(url: url)
            
            // Step 1: Check the cache first
            if let cachedResponse = cache.cachedResponse(for: urlRequest) {
                if let uiImage = UIImage(data: cachedResponse.data) {
                    return Image(uiImage: uiImage)
                }
            }
            
            // Step 2: Fetch the image from the network
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            // Step 3: Cache the response
            let cachedResponse = CachedURLResponse(response: response, data: data)
            cache.storeCachedResponse(cachedResponse, for: urlRequest)
            
            guard let uiImage = UIImage(data: data) else { return nil }
            
            return Image(uiImage: uiImage)
            
        } catch {
            print("❌ Failed to download image: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Deletes an image from Firebase Storage.
    /// - Parameters:
    ///   - userId: The user ID associated with the image.
    ///   - imageId: The unique identifier of the image to delete.
    /// - Throws: An error if the deletion fails.
    public func delete(userId: String, imageId: String) async throws {
        let imagePath = DatabaseConstants.imagePath(userId: userId, imageId: imageId)
        
        try await firebaseStorageProvider.delete(path: imagePath)
    }
}
