//
//  RoomDetailViewModelTests.swift
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
final class RoomDetailViewModelTests: XCTestCase {
    
    private let flowController = FlowControllerMock<PlantsFlow>(navigationController: UINavigationController())
    
    private func createViewModel(room: Room) -> RoomDetailViewModel {
        Resolver.registerUseCaseMocks()
        return RoomDetailViewModel(flowController: flowController, room: room)
    }
    
    // MARK: - Tests
    
    func testShowPlantDetail() async {
        // given
        let room = Room.mock(id: UUID())
        let plantId = UUID()
        let vm = createViewModel(room: room)
        
        // when
        vm.onIntent(.showPlantDetail(plantId: plantId))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.flowValue, .showPlantDetail(plantId))
    }
    
    func testRefresh() async {
        // given
        let room = Room.mock(id: UUID())
        let vm = createViewModel(room: room)
        
        // when
        vm.onIntent(.refresh)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertNil(flowController.flowValue)
    }
    
    func testCompleteTaskForPlant() async {
        // given
        let room = Room.mock(id: UUID())
        let plant = Plant.mock(id: UUID())
        let taskType = TaskType.watering
        
        let vm = createViewModel(room: room)
        
        // when
        vm.onIntent(.completeTaskForPlant(plant: plant, taskType: taskType))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertNil(flowController.flowValue)
    }
    
    func testSnackbarDataChanged() async {
        // given
        let room = Room.mock(id: UUID())
        let snackbarData = SnackbarData(message: "Test Snackbar")
        let vm = createViewModel(room: room)
        
        // when
        vm.onIntent(.snackbarDataChanged(snackbarData))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertNil(flowController.flowValue)
    }
    
    func testUploadImage() async {
        // given
        let room = Room.mock(id: UUID())
        let vm = createViewModel(room: room)
        
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
    
    func testToggleImagePicker() async {
        // given
        let room = Room.mock(id: UUID())
        let vm = createViewModel(room: room)
        
        // when
        vm.onIntent(.toggleImagePicker)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertNil(flowController.flowValue)
    }
}
