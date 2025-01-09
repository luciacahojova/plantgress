//
//  UpdatePlantImagesUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

/// Protocol defining the use case for updating a plant's images.
public protocol UpdatePlantImagesUseCase {
    /// Executes the use case to update the images of a plant.
    /// - Parameters:
    ///   - plantId: The unique identifier of the plant.
    ///   - newImages: An array of `ImageData` representing the new images to add.
    /// - Throws: An error if the update process fails.
    func execute(plantId: UUID, newImages: [ImageData]) async throws
}

/// Implementation of the `UpdatePlantImagesUseCase` protocol for updating a plant's images.
public struct UpdatePlantImagesUseCaseImpl: UpdatePlantImagesUseCase {
    
    /// The repository for managing plant data.
    private let plantRepository: PlantRepository
    
    /// Initializes a new instance of `UpdatePlantImagesUseCaseImpl`.
    /// - Parameter plantRepository: The `PlantRepository` for interacting with plant data.
    public init(plantRepository: PlantRepository) {
        self.plantRepository = plantRepository
    }
    
    /// Executes the use case to update the images of a plant.
    /// - Parameters:
    ///   - plantId: The unique identifier of the plant.
    ///   - newImages: An array of `ImageData` representing the new images to add.
    /// - Throws: An error if the update process fails.
    public func execute(plantId: UUID, newImages: [ImageData]) async throws {
        // Retrieve the plant by its ID.
        var plant = try await plantRepository.getPlant(id: plantId)
        
        // Combine existing images with the new ones.
        let updatedImages = plant.images + newImages
        
        // Create an updated plant instance with the new images.
        plant = Plant(copy: plant, images: updatedImages)
        
        // Update the plant in the repository.
        try await plantRepository.updatePlant(plant)
    }
}
