//
//  PlantRepository.swift
//  PlantToolkit
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import FirebaseFirestoreProvider
import Foundation
import SharedDomain
import Utilities

public struct PlantRepositoryImpl: PlantRepository {
    private let firebaseFirestoreProvider: FirebaseFirestoreProvider

    public init(firebaseFirestoreProvider: FirebaseFirestoreProvider) {
        self.firebaseFirestoreProvider = firebaseFirestoreProvider
    }

    public func createPlant(_ plant: Plant) async throws {
        try await firebaseFirestoreProvider.create(
            path: DatabaseConstants.plantsCollection,
            id: plant.id.uuidString,
            data: plant
        )
    }

    public func updatePlant(_ plant: Plant) async throws {
        try await firebaseFirestoreProvider.update(
            path: DatabaseConstants.plantsCollection,
            id: plant.id.uuidString,
            data: plant
        )
    }

    public func getPlant(id: UUID) async throws -> Plant {
        try await firebaseFirestoreProvider.get(
            path: DatabaseConstants.plantsCollection,
            id: id.uuidString,
            as: Plant.self
        )
    }

    public func deletePlant(id: UUID) async throws {
        try await firebaseFirestoreProvider.delete(
            path: DatabaseConstants.plantsCollection,
            id: id.uuidString
        )
    }

    public func getPlantsForRoom(roomId: UUID) async throws -> [Plant] {
        let filters: [FirestoreFilter] = [
            FirestoreFilter(field: "roomId", operator: .isEqualTo, value: roomId.uuidString)
        ]
        
        return try await firebaseFirestoreProvider.get(
            path: DatabaseConstants.plantsCollection,
            filters: filters,
            orderBy: nil,
            limit: nil,
            as: Plant.self
        )
    }

    public func getPlantPreviewsForRoom(roomId: UUID, limit: Int = 3) async throws -> [String] {
        let filters = [
            FirestoreFilter(field: "roomId", operator: .isEqualTo, value: roomId.uuidString)
        ]
        
        let orders = [
            FirestoreOrder(field: "createdAt", descending: false)
        ]
        
        let plants = try await firebaseFirestoreProvider.get(
            path: DatabaseConstants.plantsCollection,
            filters: filters,
            orderBy: orders,
            limit: limit,
            as: Plant.self
        )
        
        return plants.compactMap { $0.images.first?.urlString }
    }
    
    public func getAllPlants() async throws -> [Plant] {
        try await firebaseFirestoreProvider.getAll(
            path: DatabaseConstants.plantsCollection,
            as: Plant.self
        )
    }
}
