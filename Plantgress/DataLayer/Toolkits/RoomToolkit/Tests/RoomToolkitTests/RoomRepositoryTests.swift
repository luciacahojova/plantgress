//
//  RoomRepositoryTests.swift
//  RoomToolkit
//
//  Created by Lucia Cahojova on 05.01.2025.
//
@testable import RoomToolkit
import FirebaseFirestoreProviderMocks
import SharedDomain
import Utilities
import XCTest

final class RoomRepositoryTests: XCTestCase {
    
    // MARK: - Mocks
    
    private let firebaseFirestoreProvider = FirebaseFirestoreProviderMock()
    
    private func createRepository() -> RoomRepository {
        RoomRepositoryImpl(firebaseFirestoreProvider: firebaseFirestoreProvider)
    }
    
    // MARK: - Tests

    func testCreateRoom() async throws {
        // given
        let repository = createRepository()
        let room = Room.mock(id: UUID())
        let plants = [Plant].mock

        // when
        try await repository.createRoom(room: room, plants: plants)

        // then
        XCTAssertEqual(firebaseFirestoreProvider.createCallsCount, 1)
        XCTAssertEqual(firebaseFirestoreProvider.updateFieldCallsCount, plants.count)
    }
    
    func testDeleteRoom() async throws {
        // given
        let repository = createRepository()
        let roomId = UUID().uuidString
        let plants = [Plant].mock

        // when
        try await repository.deleteRoom(roomId: roomId, plants: plants)

        // then
        XCTAssertEqual(firebaseFirestoreProvider.deleteCallsCount, 1)
        XCTAssertEqual(firebaseFirestoreProvider.updateFieldCallsCount, plants.count)
    }
    
    func testUpdateRoom() async throws {
        // given
        let repository = createRepository()
        let room = Room.mock(id: UUID())
        let plants = [Plant].mock

        // when
        try await repository.updateRoom(room: room, plants: plants)

        // then
        XCTAssertEqual(firebaseFirestoreProvider.updateCallsCount, 1)
        XCTAssertEqual(firebaseFirestoreProvider.updateFieldCallsCount, plants.count)
    }
    
    func testAddPlantToRoom() async throws {
        // given
        let repository = createRepository()
        let roomId = UUID()
        let plantId = UUID()

        // when
        try await repository.addPlantToRoom(roomId: roomId, plantId: plantId)

        // then
        XCTAssertEqual(firebaseFirestoreProvider.updateFieldCallsCount, 2)
    }
    
    func testGetRoom() async throws {
        // given
        let repository = createRepository()
        let room = Room.mock(id: UUID())
        firebaseFirestoreProvider.getReturnValue = room

        // when
        let fetchedRoom = try await repository.getRoom(roomId: room.id)

        // then
        XCTAssertEqual(fetchedRoom, room)
        XCTAssertEqual(firebaseFirestoreProvider.getCallsCount, 1)
    }
    
    func testGetPlantsForRoom() async throws {
        // given
        let repository = createRepository()
        let roomId = UUID()
        let plants = [Plant].mock
        firebaseFirestoreProvider.getReturnValues = plants

        // when
        let fetchedPlants = try await repository.getPlantsForRoom(roomId: roomId)

        // then
        XCTAssertEqual(fetchedPlants, plants)
        XCTAssertEqual(firebaseFirestoreProvider.getCallsCount, 1)
    }
    
    func testGetAllRooms() async throws {
        // given
        let repository = createRepository()
        let rooms = [Room].mock
        firebaseFirestoreProvider.getAllReturnValue = rooms

        // when
        let fetchedRooms = try await repository.getAllRooms()

        // then
        XCTAssertEqual(fetchedRooms, rooms)
        XCTAssertEqual(firebaseFirestoreProvider.getAllCallsCount, 1)
    }
    
    func testMovePlantToRoom() async throws {
        // given
        let repository = createRepository()
        let plantId = UUID()
        let fromRoomId = UUID()
        let toRoomId = UUID()

        // when
        try await repository.movePlantToRoom(plantId: plantId, fromRoomId: fromRoomId, toRoomId: toRoomId)

        // then
        XCTAssertEqual(firebaseFirestoreProvider.updateFieldCallsCount, 3) // Plant and two room updates
    }
    
    func testRemovePlantFromRoom() async throws {
        // given
        let repository = createRepository()
        let plantId = UUID()
        let roomId = UUID()

        // when
        try await repository.removePlantFromRoom(plantId: plantId, roomId: roomId)

        // then
        XCTAssertEqual(firebaseFirestoreProvider.updateFieldCallsCount, 2) // Plant and room update
    }
}
