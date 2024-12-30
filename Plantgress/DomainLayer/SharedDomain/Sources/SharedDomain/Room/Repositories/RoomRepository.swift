//
//  RoomRepository.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

public protocol RoomRepository {
    func createRoom(room: Room, plants: [Plant]) async throws
    func deleteRoom(roomId: String, plants: [Plant]) async throws
    func updateRoom(room: Room, plants: [Plant]) async throws
    func addPlantToRoom(roomId: UUID, plantId: UUID) async throws
    func getRoom(roomId: UUID) async throws -> Room
    func getPlantsForRoom(roomId: UUID) async throws -> [Plant]
    func getAllRooms() async throws -> [Room]
    func removePlantFromRoom(plantId: UUID, roomId: UUID) async throws
    func movePlantToRoom(plantId: UUID, fromRoomId: UUID, toRoomId: UUID) async throws
    func updateRoomPreviewImages(roomId: UUID) async throws
}
