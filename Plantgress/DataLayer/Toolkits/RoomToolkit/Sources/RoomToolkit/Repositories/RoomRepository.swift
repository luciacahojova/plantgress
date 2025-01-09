//
//  RoomRepository.swift
//  RoomToolkit
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import FirebaseFirestoreProvider
import Foundation
import SharedDomain
import Utilities

/// Implementation of the `RoomRepository` protocol for managing rooms and plants in Firestore.
public struct RoomRepositoryImpl: RoomRepository {
    
    /// Firebase Firestore provider for database operations.
    private let firebaseFirestoreProvider: FirebaseFirestoreProvider

    /// Initializes a new instance of `RoomRepositoryImpl`.
    /// - Parameter firebaseFirestoreProvider: The Firestore provider for handling database operations.
    public init(firebaseFirestoreProvider: FirebaseFirestoreProvider) {
        self.firebaseFirestoreProvider = firebaseFirestoreProvider
    }

    /// Creates a new room and assigns plants to it.
    /// - Parameters:
    ///   - room: The room to be created.
    ///   - plants: The list of plants to associate with the room.
    /// - Throws: An error if the operation fails.
    public func createRoom(room: Room, plants: [Plant]) async throws {
        // Extract preview images from the first two plants
        let previewImages = plants.prefix(2).compactMap { $0.images.first?.urlString }
        let roomWithImages = Room(id: room.id, name: room.name, imageUrls: previewImages)

        // Create the room in Firestore
        try await firebaseFirestoreProvider.create(
            path: DatabaseConstants.roomsCollection,
            id: room.id.uuidString,
            data: roomWithImages
        )

        // Update the `roomId` field for each plant
        for plant in plants {
            try await firebaseFirestoreProvider.updateField(
                path: DatabaseConstants.plantsCollection,
                id: plant.id.uuidString,
                fields: ["roomId": room.id.uuidString]
            )
        }
    }
    
    /// Deletes a room and removes its association with plants.
    /// - Parameters:
    ///   - roomId: The ID of the room to delete.
    ///   - plants: The list of plants associated with the room.
    /// - Throws: An error if the operation fails.
    public func deleteRoom(roomId: String, plants: [Plant]) async throws {
        // Remove room association from all plants
        for plant in plants {
            try await firebaseFirestoreProvider.updateField(
                path: DatabaseConstants.plantsCollection,
                id: plant.id.uuidString,
                fields: ["roomId": NSNull()]
            )
        }
        
        // Delete the room in Firestore
        try await firebaseFirestoreProvider.delete(
            path: DatabaseConstants.roomsCollection,
            id: roomId
        )
    }
    
    /// Updates an existing room and its associated plants.
    /// - Parameters:
    ///   - room: The updated room information.
    ///   - plants: The list of plants to associate with the room.
    /// - Throws: An error if the operation fails.
    public func updateRoom(room: Room, plants: [Plant]) async throws {
        // Extract preview images from the first two plants
        let previewImages = plants.prefix(2).compactMap { $0.images.first?.urlString }
        let roomWithImages = Room(id: room.id, name: room.name, imageUrls: previewImages)
        
        // Update the room in Firestore
        try await firebaseFirestoreProvider.update(
            path: DatabaseConstants.roomsCollection,
            id: room.id.uuidString,
            data: roomWithImages
        )

        // Update the `roomId` field for each plant
        for plant in plants {
            try await firebaseFirestoreProvider.updateField(
                path: DatabaseConstants.plantsCollection,
                id: plant.id.uuidString,
                fields: ["roomId": room.id.uuidString]
            )
        }
    }

    /// Adds a plant to a specific room.
    /// - Parameters:
    ///   - roomId: The ID of the room.
    ///   - plantId: The ID of the plant to add.
    /// - Throws: An error if the operation fails.
    public func addPlantToRoom(roomId: UUID, plantId: UUID) async throws {
        // Update the `roomId` field of the plant document
        try await firebaseFirestoreProvider.updateField(
            path: DatabaseConstants.plantsCollection,
            id: plantId.uuidString,
            fields: ["roomId": roomId.uuidString]
        )

        // Update room preview images
        try await updateRoomPreviewImages(roomId: roomId)
    }

    /// Retrieves a room by its ID.
    /// - Parameter roomId: The ID of the room.
    /// - Returns: The room object.
    /// - Throws: An error if the operation fails.
    public func getRoom(roomId: UUID) async throws -> Room {
        return try await firebaseFirestoreProvider.get(
            path: DatabaseConstants.roomsCollection,
            id: roomId.uuidString,
            as: Room.self
        )
    }

    /// Retrieves all plants associated with a specific room.
    /// - Parameter roomId: The ID of the room.
    /// - Returns: A list of plants in the room.
    /// - Throws: An error if the operation fails.
    public func getPlantsForRoom(roomId: UUID) async throws -> [Plant] {
        return try await firebaseFirestoreProvider.get(
            path: DatabaseConstants.plantsCollection,
            filters: [FirestoreFilter(field: "roomId", operator: .isEqualTo, value: roomId.uuidString)],
            orderBy: nil,
            limit: nil,
            as: Plant.self
        )
    }
    
    /// Retrieves all rooms from the database.
    /// - Returns: A list of all rooms.
    /// - Throws: An error if the operation fails.
    public func getAllRooms() async throws -> [Room] {
        try await firebaseFirestoreProvider.getAll(
            path: DatabaseConstants.roomsCollection,
            as: Room.self
        )
    }

    /// Updates the preview images for a specific room.
    /// - Parameter roomId: The ID of the room.
    /// - Throws: An error if the operation fails.
    public func updateRoomPreviewImages(roomId: UUID) async throws {
        // Fetch the first two plants for the room
        let plants = try await firebaseFirestoreProvider.get(
            path: DatabaseConstants.plantsCollection,
            filters: [FirestoreFilter(field: "roomId", operator: .isEqualTo, value: roomId.uuidString)],
            orderBy: nil,
            limit: 2,
            as: Plant.self
        )

        // Extract preview images from the fetched plants
        let previewImages = plants.compactMap { $0.images.first?.urlString }

        // Update only the `imageUrls` field in the room document
        try await firebaseFirestoreProvider.updateField(
            path: DatabaseConstants.roomsCollection,
            id: roomId.uuidString,
            fields: ["imageUrls": previewImages]
        )
    }

    /// Moves a plant from one room to another.
    /// - Parameters:
    ///   - plantId: The ID of the plant to move.
    ///   - fromRoomId: The ID of the current room.
    ///   - toRoomId: The ID of the destination room.
    /// - Throws: An error if the operation fails.
    public func movePlantToRoom(plantId: UUID, fromRoomId: UUID, toRoomId: UUID) async throws {
        // Update the `roomId` field for the plant document
        try await firebaseFirestoreProvider.updateField(
            path: DatabaseConstants.plantsCollection,
            id: plantId.uuidString,
            fields: ["roomId": toRoomId.uuidString]
        )

        // Update preview images for both rooms
        try await updateRoomPreviewImages(roomId: fromRoomId)
        try await updateRoomPreviewImages(roomId: toRoomId)
    }

    /// Removes a plant from a room.
    /// - Parameters:
    ///   - plantId: The ID of the plant to remove.
    ///   - roomId: The ID of the room.
    /// - Throws: An error if the operation fails.
    public func removePlantFromRoom(plantId: UUID, roomId: UUID) async throws {
        // Update the `roomId` field to `nil` for the specified plant
        try await firebaseFirestoreProvider.updateField(
            path: DatabaseConstants.plantsCollection,
            id: plantId.uuidString,
            fields: ["roomId": NSNull()]
        )

        // Update the room's preview images
        try await updateRoomPreviewImages(roomId: roomId)
    }
}
