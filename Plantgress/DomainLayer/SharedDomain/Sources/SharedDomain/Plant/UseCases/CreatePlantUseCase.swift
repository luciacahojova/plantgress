//
//  CreatePlantUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

public protocol CreatePlantUseCase {
    func execute(plant: Plant) async throws
}

public struct CreatePlantUseCaseImpl: CreatePlantUseCase {
    
    private let plantRepository: PlantRepository
    
    public init(
        plantRepository: PlantRepository
    ) {
        self.plantRepository = plantRepository
    }
    
    public func execute(plant: Plant) async throws {
        try await plantRepository.createPlant(plant)
    }
}
