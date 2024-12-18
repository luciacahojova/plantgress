//
//  PlantRepository.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

public protocol PlantRepository {
    func createPlant(_ plant: Plant) async throws
    func updatePlant(_ plant: Plant) async throws
    func deletePlant(id: UUID) async throws
    func getPlant(id: UUID) async throws -> Plant
    func getAllPlants() async throws -> [Plant]
    func getPlantsForRoom(roomId: UUID) async throws -> [Plant]
    func getPlantPreviewsForRoom(roomId: UUID, limit: Int) async throws -> [String]
}
