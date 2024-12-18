//
//  DeletePlantUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

public protocol DeletePlantUseCase {
    func execute(id: UUID) async throws
}

public struct DeletePlantUseCaseImpl: DeletePlantUseCase {
    
    private let plantRepository: PlantRepository
    
    public init(
        plantRepository: PlantRepository
    ) {
        self.plantRepository = plantRepository
    }
    
    public func execute(id: UUID) async throws {
        try await plantRepository.deletePlant(id: id)
    }
}
