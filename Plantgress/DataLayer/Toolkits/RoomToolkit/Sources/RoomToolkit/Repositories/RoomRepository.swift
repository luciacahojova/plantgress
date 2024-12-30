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

public struct RoomRepositoryImpl: RoomRepository {
    
    private let firebaseFirestoreProvider: FirebaseFirestoreProvider

    public init(firebaseFirestoreProvider: FirebaseFirestoreProvider) {
        self.firebaseFirestoreProvider = firebaseFirestoreProvider
    }

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
    
    public func deleteRoom(roomId: String, plants: [Plant]) async throws {
        for plant in plants {
            try await firebaseFirestoreProvider.updateField(
                path: DatabaseConstants.plantsCollection,
                id: plant.id.uuidString,
                fields: ["roomId": ""]
            )
        }
        
        try await firebaseFirestoreProvider.delete(
            path: DatabaseConstants.roomsCollection,
            id: roomId
        )
    }
    
    public func updateRoom(room: Room, plants: [Plant]) async throws {
        let previewImages = plants.prefix(2).compactMap { $0.images.first?.urlString }
        let roomWithImages = Room(id: room.id, name: room.name, imageUrls: previewImages)
        
        try await firebaseFirestoreProvider.update(
            path: DatabaseConstants.roomsCollection,
            id: room.id.uuidString,
            data: room
        )

        for plant in plants {
            try await firebaseFirestoreProvider.updateField(
                path: DatabaseConstants.plantsCollection,
                id: plant.id.uuidString,
                fields: ["roomId": room.id.uuidString]
            )
        }
    }

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

    public func getRoom(roomId: UUID) async throws -> Room {
        return try await firebaseFirestoreProvider.get(
            path: DatabaseConstants.roomsCollection,
            id: roomId.uuidString,
            as: Room.self
        )
    }

    public func getPlantsForRoom(roomId: UUID) async throws -> [Plant] {
        return try await firebaseFirestoreProvider.get(
            path: DatabaseConstants.plantsCollection,
            filters: [FirestoreFilter(field: "roomId", operator: .isEqualTo, value: roomId.uuidString)],
            orderBy: nil,
            limit: nil,
            as: Plant.self
        )
    }
    
    public func getAllRooms() async throws -> [Room] {
        try await firebaseFirestoreProvider.getAll(
            path: DatabaseConstants.roomsCollection,
            as: Room.self
        )
    }

    public func updateRoomPreviewImages(roomId: UUID) async throws {
        // Step 1: Fetch the first two plants for the room
        let plants = try await firebaseFirestoreProvider.get(
            path: DatabaseConstants.plantsCollection,
            filters: [FirestoreFilter(field: "roomId", operator: .isEqualTo, value: roomId.uuidString)],
            orderBy: nil,
            limit: 2,
            as: Plant.self
        )

        // Step 2: Extract preview images from the fetched plants
        let previewImages = plants.compactMap { $0.images.first?.urlString }

        // Step 3: Update only the `imageUrls` field in the room document
        try await firebaseFirestoreProvider.updateField(
            path: DatabaseConstants.roomsCollection,
            id: roomId.uuidString,
            fields: ["imageUrls": previewImages]
        )
    }

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
