//
//  GetAllPlantsUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

/// Protocol defining the use case for retrieving all plants.
public protocol GetAllPlantsUseCase {
    /// Executes the use case to retrieve all plants.
    /// - Returns: An array of `Plant` objects.
    /// - Throws: An error if the retrieval process fails.
    func execute() async throws -> [Plant]
}

/// Implementation of the `GetAllPlantsUseCase` protocol for retrieving all plants.
public struct GetAllPlantsUseCaseImpl: GetAllPlantsUseCase {
    
    /// The repository for managing plant data.
    private let plantRepository: PlantRepository
    
    /// Initializes a new instance of `GetAllPlantsUseCaseImpl`.
    /// - Parameter plantRepository: The `PlantRepository` for interacting with plant data.
    public init(plantRepository: PlantRepository) {
        self.plantRepository = plantRepository
    }
    
    /// Executes the use case to retrieve all plants.
    /// - Returns: An array of `Plant` objects.
    /// - Throws: An error if the retrieval process fails.
    public func execute() async throws -> [Plant] {
        // Use the repository to fetch all plants.
        try await plantRepository.getAllPlants()
    }
}
