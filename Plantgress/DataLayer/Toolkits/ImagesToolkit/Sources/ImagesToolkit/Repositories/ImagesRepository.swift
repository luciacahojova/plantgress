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

public struct ImagesRepositoryImpl: ImagesRepository {
    
    private let firebaseStorageProvider: FirebaseStorageProvider
    
    public init(firebaseStorageProvider: FirebaseStorageProvider) {
        self.firebaseStorageProvider = firebaseStorageProvider
    }
    
    public func uploadImage(userId: String, imageId: String, imageData: Data) async throws -> URL {
        let imagePath = DatabaseConstants.imagePath(userId: userId, imageId: imageId)
        
        return try await firebaseStorageProvider.upload(
            path: imagePath,
            data: imageData,
            metadata: nil
        )
    }
    
    public func downloadImage(urlString: String) async -> Image? {
        do {
            guard let url = URL(string: urlString) else { return nil }
            let cache = URLCache.shared
            let urlRequest = URLRequest(url: url)
            
            // Step 1: Check the cache first
            if let cachedResponse = cache.cachedResponse(for: urlRequest) {
                if let uiImage = UIImage(data: cachedResponse.data) {
                    print("🏞️ Image loaded from cache")
                    return Image(uiImage: uiImage)
                }
            }
            
            // Step 2: Fetch the image from the network
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            // Step 3: Cache the response
            let cachedResponse = CachedURLResponse(response: response, data: data)
            cache.storeCachedResponse(cachedResponse, for: urlRequest)
            
            guard let uiImage = UIImage(data: data) else { return nil }
            
            print("🏞️ Image loaded from network")
            return Image(uiImage: uiImage)
            
        } catch {
            print("❌ Failed to download image: \(error.localizedDescription)")
            return nil
        }
    }
    
    public func delete(userId: String, imageId: String) async throws {
        let imagePath = DatabaseConstants.imagePath(userId: userId, imageId: imageId)
        
        try await firebaseStorageProvider.delete(path: imagePath)
    }
}
