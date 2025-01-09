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

/// Implementation of the `PlantRepository` protocol for managing plants in Firestore.
public struct PlantRepositoryImpl: PlantRepository {
    /// Firebase Firestore provider for database operations.
    private let firebaseFirestoreProvider: FirebaseFirestoreProvider

    /// Initializes a new instance of `PlantRepositoryImpl`.
    /// - Parameter firebaseFirestoreProvider: The Firestore provider for handling database operations.
    public init(firebaseFirestoreProvider: FirebaseFirestoreProvider) {
        self.firebaseFirestoreProvider = firebaseFirestoreProvider
    }

    /// Creates a new plant in the database.
    /// - Parameter plant: The plant object to be created.
    /// - Throws: An error if the operation fails.
    public func createPlant(_ plant: Plant) async throws {
        try await firebaseFirestoreProvider.create(
            path: DatabaseConstants.plantsCollection,
            id: plant.id.uuidString,
            data: plant
        )
    }

    /// Updates an existing plant in the database.
    /// - Parameter plant: The updated plant object.
    /// - Throws: An error if the operation fails.
    public func updatePlant(_ plant: Plant) async throws {
        try await firebaseFirestoreProvider.update(
            path: DatabaseConstants.plantsCollection,
            id: plant.id.uuidString,
            data: plant
        )
    }

    /// Retrieves a plant by its ID.
    /// - Parameter id: The unique identifier of the plant.
    /// - Returns: The plant object corresponding to the given ID.
    /// - Throws: An error if the operation fails.
    public func getPlant(id: UUID) async throws -> Plant {
        try await firebaseFirestoreProvider.get(
            path: DatabaseConstants.plantsCollection,
            id: id.uuidString,
            as: Plant.self
        )
    }

    /// Deletes a plant by its ID.
    /// - Parameter id: The unique identifier of the plant to delete.
    /// - Throws: An error if the operation fails.
    public func deletePlant(id: UUID) async throws {
        try await firebaseFirestoreProvider.delete(
            path: DatabaseConstants.plantsCollection,
            id: id.uuidString
        )
    }

    /// Retrieves all plants associated with a specific room.
    /// - Parameter roomId: The unique identifier of the room.
    /// - Returns: A list of plants that belong to the specified room.
    /// - Throws: An error if the operation fails.
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

    /// Retrieves preview image URLs for a specific room.
    /// - Parameters:
    ///   - roomId: The unique identifier of the room.
    ///   - limit: The maximum number of preview images to retrieve. Defaults to 3.
    /// - Returns: A list of URLs for preview images of plants in the room.
    /// - Throws: An error if the operation fails.
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
    
    /// Retrieves all plants from the database.
    /// - Returns: A list of all plants.
    /// - Throws: An error if the operation fails.
    public func getAllPlants() async throws -> [Plant] {
        try await firebaseFirestoreProvider.getAll(
            path: DatabaseConstants.plantsCollection,
            as: Plant.self
        )
    }
}
