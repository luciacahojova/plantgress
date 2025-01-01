//
//  PrepareImagesForSharingUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 01.01.2025.
//

import Foundation
import UIKit

public protocol PrepareImagesForSharingUseCase {
    func execute(images: [ImageData]) async throws -> [UIImage]
}

public struct PrepareImagesForSharingUseCaseImpl: PrepareImagesForSharingUseCase {
    
    private let imagesRepository: ImagesRepository
    
    public init(
        imagesRepository: ImagesRepository
    ) {
        self.imagesRepository = imagesRepository
    }
    
    public func execute(images: [ImageData]) async throws -> [UIImage] {
        try await imagesRepository.prepareImagesForSharing(images: images)
    }
}
