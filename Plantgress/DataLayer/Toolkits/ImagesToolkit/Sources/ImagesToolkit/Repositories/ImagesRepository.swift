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
    
    public func uploadImage(userId: UUID, imageName: String, imageData: Data) async throws -> URL {
        let imagePath = DatabaseConstants.imagePath(userId: userId.uuidString, imageName: imageName)
        
        return try await firebaseStorageProvider.upload(
            path: imagePath,
            data: imageData,
            metadata: nil
        )
    }
    
    public func downloadImage(urlString: String) async throws -> Image {
        guard let url = URL(string: urlString) else {
            throw DatabaseError.invalidUrl
        }
        
        let data = try await firebaseStorageProvider.download(url: url)
        
        guard let uiImage = UIImage(data: data) else {
            throw DatabaseError.default
        }
                
        return Image(uiImage: uiImage)
    }
    
    public func delete(userId: UUID, imageName: String) async throws {
        let imagePath = DatabaseConstants.imagePath(userId: userId.uuidString, imageName: imageName)
        
        try await firebaseStorageProvider.delete(path: imagePath)
    }
}
