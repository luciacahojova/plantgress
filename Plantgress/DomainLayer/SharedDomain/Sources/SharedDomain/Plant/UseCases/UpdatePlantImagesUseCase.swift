//
//  UpdatePlantImagesUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

public protocol UpdatePlantImagesUseCase {
    func execute(plantId: UUID, newImages: [ImageData]) async throws
}

public struct UpdatePlantImagesUseCaseImpl: UpdatePlantImagesUseCase {
    
    private let plantRepository: PlantRepository
    
    public init(plantRepository: PlantRepository) {
        self.plantRepository = plantRepository
    }
    
    public func execute(plantId: UUID, newImages: [ImageData]) async throws {
        var plant = try await plantRepository.getPlant(id: plantId)
        
        let updatedImages = plant.images + newImages
        plant = Plant(copy: plant, images: updatedImages)
        
        try await plantRepository.updatePlant(plant)
    }
}
