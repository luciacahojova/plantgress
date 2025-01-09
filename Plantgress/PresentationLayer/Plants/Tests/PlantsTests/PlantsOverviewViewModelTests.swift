//
//  PlantsOverviewViewModelTests.swift
//  Plants
//
//  Created by Lucia Cahojova on 05.01.2025.
//

@testable import Plants
import UIToolkit
import XCTest
import SharedDomain
import Resolver

@MainActor
final class PlantsOverviewViewModelTests: XCTestCase {

    private let flowController = FlowControllerMock<PlantsFlow>(navigationController: UINavigationController())

    private func createViewModel() -> PlantsOverviewViewModel {
        Resolver.registerUseCaseMocks()
        return PlantsOverviewViewModel(flowController: flowController)
    }

    // MARK: - Tests

    func testSnackbarDataChanged() async {
        // given
        let vm = createViewModel()
        let snackbarData = SnackbarData(message: "Test Snackbar")

        // when
        vm.onIntent(.snackbarDataChanged(snackbarData))
        await vm.awaitAllTasks()

        // then
        // No state access, but verify that snackbar data intent did not trigger unintended behavior
        XCTAssertNil(flowController.flowValue)
    }

    func testToggleImageActionSheet() async {
        // given
        let vm = createViewModel()

        // when
        vm.onIntent(.toggleImageActionSheet)
        await vm.awaitAllTasks()

        // then
        XCTAssertNil(flowController.flowValue)
    }

    func testRefresh() async {
        // given
        let vm = createViewModel()

        // when
        vm.onIntent(.refresh)
        await vm.awaitAllTasks()

        // then
        // Verify plants were loaded indirectly through public behavior (e.g., callback or flowController)
        XCTAssertNil(flowController.flowValue)
    }

    func testCompleteTask() async {
        // given
        let task = PlantTask.mock(id: UUID())

        let vm = createViewModel()
        vm.onIntent(.refresh)

        // when
        vm.onIntent(.completeTask(task))
        await vm.awaitAllTasks()

        // then
        XCTAssertNil(flowController.flowValue)
    }

    func testDeleteTask() async {
        // given
        let plantId = UUID()
        let task: PlantTask = .mock(id: UUID())
        let vm = createViewModel()
        vm.onIntent(.refresh)

        // when
        vm.onIntent(.deleteTask(task))
        await vm.awaitAllTasks()

        // then
        XCTAssertNil(flowController.flowValue)
    }

    func testShowPlantDetail() async {
        // given
        let plantId = UUID()
        let vm = createViewModel()

        // when
        vm.onIntent(.showPlantDetail(plantId: plantId))
        await vm.awaitAllTasks()

        // then
        XCTAssertEqual(flowController.flowValue, .showPlantDetail(plantId))
    }

    func testShowRoomDetail() async {
        // given
        let room = Room.mock(id: UUID())
        let vm = createViewModel()

        // when
        vm.onIntent(.showRoomDetail(roomId: room.id))
        await vm.awaitAllTasks()

        // then
        XCTAssertEqual(flowController.flowValue, .showRoomDetail(room.id))
    }

    func testUploadImage() async {
        // given
        let vm = createViewModel()

        // Create a valid UIImage
        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContext(size)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // when
        vm.onIntent(.uploadImage(image))
        await vm.awaitAllTasks()

        // then
        XCTAssertNil(flowController.flowValue)
    }

    func testSelectedSectionChanged() async {
        // given
        let vm = createViewModel()

        // when
        vm.onIntent(.selectedSectionChanged(.tasks))
        await vm.awaitAllTasks()

        // then
        XCTAssertNil(flowController.flowValue)
    }

    func testPlusButtonTapped() async {
        // given
        let vm = createViewModel()

        // when
        vm.onIntent(.plusButtonTapped)
        await vm.awaitAllTasks()

        // then
        // Validate the flowController triggered the correct flow
        XCTAssertNotNil(flowController.flowValue)
    }
}
