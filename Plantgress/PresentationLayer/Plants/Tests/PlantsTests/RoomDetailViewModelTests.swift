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
    
    private func createViewModel(roomId: UUID) -> RoomDetailViewModel {
        Resolver.registerUseCaseMocks()
        return RoomDetailViewModel(flowController: flowController, roomId: roomId)
    }
    
    // MARK: - Tests
    
    func testShowPlantDetail() async {
        // given
        let plantId = UUID()
        let vm = createViewModel(roomId: UUID())
        
        // when
        vm.onIntent(.showPlantDetail(plantId: plantId))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.flowValue, .showPlantDetail(plantId))
    }
    
    func testRefresh() async {
        // given
        let room = Room.mock(id: UUID())
        let vm = createViewModel(roomId: UUID())
        
        // when
        vm.onIntent(.refresh)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertNil(flowController.flowValue)
    }
    
    func testCompleteTaskForPlant() async {
        // given
        let plant = Plant.mock(id: UUID())
        let taskType = TaskType.watering
        
        let vm = createViewModel(roomId: UUID())
        
        // when
        vm.onIntent(.completeTaskForPlant(plant: plant, taskType: taskType))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertNil(flowController.flowValue)
    }
    
    func testSnackbarDataChanged() async {
        // given
        let snackbarData = SnackbarData(message: "Test Snackbar")
        let vm = createViewModel(roomId: UUID())
        
        // when
        vm.onIntent(.snackbarDataChanged(snackbarData))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertNil(flowController.flowValue)
    }
    
    func testUploadImage() async {
        // given
        let vm = createViewModel(roomId: UUID())
        
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
        let vm = createViewModel(roomId: UUID())
        
        // when
        vm.onIntent(.toggleImagePicker)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertNil(flowController.flowValue)
    }
}
