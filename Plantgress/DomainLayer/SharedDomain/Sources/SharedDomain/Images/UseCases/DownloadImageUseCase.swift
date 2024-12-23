//
//  DownloadImageUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 15.12.2024.
//

import Foundation
import SwiftUI

public protocol DownloadImageUseCase {
    func execute(urlString: String) async -> Image?
}

public struct DownloadImageUseCaseImpl: DownloadImageUseCase {
    
    private let imagesRepository: ImagesRepository
    
    public init(
        imagesRepository: ImagesRepository
    ) {
        self.imagesRepository = imagesRepository
    }
    
    public func execute(urlString: String) async -> Image? {
        await imagesRepository.downloadImage(urlString: urlString)
    }
}
