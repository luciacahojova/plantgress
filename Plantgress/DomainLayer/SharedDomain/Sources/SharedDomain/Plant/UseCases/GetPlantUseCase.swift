//
//  GetPlantUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

/// Protocol defining the use case for retrieving a plant by its ID.
public protocol GetPlantUseCase {
    /// Executes the use case to retrieve a plant by its unique identifier.
    /// - Parameter id: The unique identifier of the plant.
    /// - Returns: The `Plant` object corresponding to the given ID.
    /// - Throws: An error if the retrieval process fails or the plant is not found.
    func execute(id: UUID) async throws -> Plant
}

/// Implementation of the `GetPlantUseCase` protocol for retrieving a plant by its ID.
public struct GetPlantUseCaseImpl: GetPlantUseCase {
    
    /// The repository for managing plant data.
    private let plantRepository: PlantRepository
    
    /// Initializes a new instance of `GetPlantUseCaseImpl`.
    /// - Parameter plantRepository: The `PlantRepository` for interacting with plant data.
    public init(plantRepository: PlantRepository) {
        self.plantRepository = plantRepository
    }
    
    /// Executes the use case to retrieve a plant by its unique identifier.
    /// - Parameter id: The unique identifier of the plant.
    /// - Returns: The `Plant` object corresponding to the given ID.
    /// - Throws: An error if the retrieval process fails or the plant is not found.
    public func execute(id: UUID) async throws -> Plant {
        // Use the repository to fetch the plant data.
        try await plantRepository.getPlant(id: id)
    }
}
