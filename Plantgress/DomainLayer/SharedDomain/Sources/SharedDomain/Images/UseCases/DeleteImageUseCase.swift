//
//  DeleteImageUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 28.12.2024.
//

import Foundation

public protocol DeleteImageUseCase {
    func execute(userId: String, imageId: UUID) async throws
}

public struct DeleteImageUseCaseImpl: DeleteImageUseCase {
    
    private let imagesRepository: ImagesRepository
    
    public init(
        imagesRepository: ImagesRepository
    ) {
        self.imagesRepository = imagesRepository
    }
    
    public func execute(userId: String, imageId: UUID) async throws {
        try await imagesRepository.delete(userId: userId, imageId: imageId.uuidString)
    }
}
