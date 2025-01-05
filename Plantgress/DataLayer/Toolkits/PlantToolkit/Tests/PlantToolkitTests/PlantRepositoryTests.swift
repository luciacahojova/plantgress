//
//  PlantRepositoryTests.swift
//  PlantToolkit
//
//  Created by Lucia Cahojova on 05.01.2025.
//

import Foundation

@testable import PlantToolkit
import FirebaseFirestoreProviderMocks
import SharedDomain
import XCTest

final class PlantRepositoryTests: XCTestCase {
    
    // MARK: - Mocks
    
    private let firebaseFirestoreProvider = FirebaseFirestoreProviderMock()
    
    private func createRepository() -> PlantRepository {
        PlantRepositoryImpl(firebaseFirestoreProvider: firebaseFirestoreProvider)
    }
    
    // MARK: - Tests

    func testCreatePlant() async throws {
        // given
        let repository = createRepository()
        let plant = Plant.mock(id: UUID())

        // when
        try await repository.createPlant(plant)

        // then
        XCTAssertEqual(firebaseFirestoreProvider.createCallsCount, 1)
    }

    func testUpdatePlant() async throws {
        // given
        let repository = createRepository()
        let plant = Plant.mock(id: UUID())

        // when
        try await repository.updatePlant(plant)

        // then
        XCTAssertEqual(firebaseFirestoreProvider.updateCallsCount, 1)
    }

    func testGetPlant() async throws {
        // given
        let repository = createRepository()
        let plant = Plant.mock(id: UUID())
        firebaseFirestoreProvider.getReturnValue = plant

        // when
        let fetchedPlant = try await repository.getPlant(id: plant.id)

        // then
        XCTAssertEqual(fetchedPlant, plant)
        XCTAssertEqual(firebaseFirestoreProvider.getCallsCount, 1)
    }

    func testDeletePlant() async throws {
        // given
        let repository = createRepository()
        let plantId = UUID()

        // when
        try await repository.deletePlant(id: plantId)

        // then
        XCTAssertEqual(firebaseFirestoreProvider.deleteCallsCount, 1)
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

    func testGetPlantPreviewsForRoom() async throws {
        // given
        let repository = createRepository()
        let roomId = UUID()
        let plants = [Plant].mock
        firebaseFirestoreProvider.getReturnValues = plants

        // when
        let previews = try await repository.getPlantPreviewsForRoom(roomId: roomId, limit: 3)

        // then
        XCTAssertEqual(previews, plants.compactMap { $0.images.first?.urlString })
        XCTAssertEqual(firebaseFirestoreProvider.getCallsCount, 1)
    }

    func testGetAllPlants() async throws {
        // given
        let repository = createRepository()
        let plants = [Plant].mock
        firebaseFirestoreProvider.getAllReturnValue = plants

        // when
        let fetchedPlants = try await repository.getAllPlants()

        // then
        XCTAssertEqual(fetchedPlants, plants)
        XCTAssertEqual(firebaseFirestoreProvider.getAllCallsCount, 1)
    }
}
