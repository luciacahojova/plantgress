//
//  TaskRepositoryTests.swift
//  TaskToolkit
//
//  Created by Lucia Cahojova on 05.01.2025.
//

@testable import TaskToolkit
import FirebaseFirestoreProviderMocks
import SharedDomain
import XCTest

final class TaskRepositoryTests: XCTestCase {
    
    // MARK: - Mocks
    
    private let firebaseFirestoreProvider = FirebaseFirestoreProviderMock()
    
    private func createRepository() -> TaskRepository {
        TaskRepositoryImpl(firebaseFirestoreProvider: firebaseFirestoreProvider)
    }
    
    // MARK: - Tests

    func testGetCompletedTasksForPlant() async throws {
        // given
        let repository = createRepository()
        let completedTask = PlantTask.mock(id: UUID())
        firebaseFirestoreProvider.getAllReturnValue = [completedTask]

        // when
        let tasks = try await repository.getCompletedTasks(for: completedTask.plantId)

        // then
        XCTAssertEqual(tasks.count, 1)
        XCTAssertEqual(tasks.first?.taskType, .watering)
        XCTAssertEqual(tasks.first?.plantId, completedTask.plantId)
        XCTAssertEqual(firebaseFirestoreProvider.getAllCallsCount, 1)
    }

    func testGetCompletedTasksForPlants() async throws {
        // given
        let repository = createRepository()
        let task1 = PlantTask.mock(id: UUID())
        let task2 = PlantTask.mock(id: UUID())
        firebaseFirestoreProvider.getAllReturnValue = [task1, task2]

        // when
        let tasks = try await repository.getCompletedTasks(for: [task2.plantId])

        // then
        XCTAssertEqual(tasks.count, 2)
        XCTAssertEqual(tasks.first?.taskType, .watering)
    }
}
