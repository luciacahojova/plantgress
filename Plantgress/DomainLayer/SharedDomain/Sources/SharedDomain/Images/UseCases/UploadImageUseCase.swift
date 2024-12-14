//
//  UploadImageUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import Foundation

public protocol UploadImageUseCase {
    func execute(userId: String, imageId: String, imageData: Data) async throws -> URL
}

public struct UploadImageUseCaseImpl: UploadImageUseCase {
    
    private let imagesRepository: ImagesRepository
    
    public init(
        imagesRepository: ImagesRepository
    ) {
        self.imagesRepository = imagesRepository
    }
    
    public func execute(userId: String, imageId: String, imageData: Data) async throws -> URL {
        try await imagesRepository.uploadImage(userId: userId, imageId: imageId, imageData: imageData)
    }
}
