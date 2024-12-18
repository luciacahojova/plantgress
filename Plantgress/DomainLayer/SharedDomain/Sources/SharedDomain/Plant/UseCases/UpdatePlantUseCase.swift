//
//  UpdatePlantUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

public protocol UpdatePlantUseCase {
    func execute(plant: Plant) async throws
}

public struct UpdatePlantUseCaseImpl: UpdatePlantUseCase {
    
    private let plantRepository: PlantRepository
    
    public init(
        plantRepository: PlantRepository
    ) {
        self.plantRepository = plantRepository
    }
    
    public func execute(plant: Plant) async throws {
        try await plantRepository.updatePlant(plant)
    }
}
