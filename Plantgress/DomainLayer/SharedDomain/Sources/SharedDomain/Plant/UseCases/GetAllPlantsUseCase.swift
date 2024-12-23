//
//  GetAllPlantsUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

public protocol GetAllPlantsUseCase {
    func execute() async throws -> [Plant]
}

public struct GetAllPlantsUseCaseImpl: GetAllPlantsUseCase {
    
    private let plantRepository: PlantRepository
    
    public init(
        plantRepository: PlantRepository
    ) {
        self.plantRepository = plantRepository
    }
    
    public func execute() async throws -> [Plant] {
        try await plantRepository.getAllPlants()
    }
}
