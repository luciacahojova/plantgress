//
//  GetPlantUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

public protocol GetPlantUseCase {
    func execute(id: UUID) async throws -> Plant
}

public struct GetPlantUseCaseImpl: GetPlantUseCase {
    
    private let plantRepository: PlantRepository
    
    public init(
        plantRepository: PlantRepository
    ) {
        self.plantRepository = plantRepository
    }
    
    public func execute(id: UUID) async throws -> Plant {
        try await plantRepository.getPlant(id: id)
    }
}
