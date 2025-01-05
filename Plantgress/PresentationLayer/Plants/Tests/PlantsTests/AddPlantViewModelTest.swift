//
//  AddPlantViewModelTest.swift
//  Plants
//
//  Created by Lucia Cahojova on 05.01.2025.
//

@testable import Plants
import Resolver
import SharedDomain
import UIToolkit
import UIKit
import XCTest

@MainActor
final class AddPlantViewModelTest: XCTestCase {
    
    private let flowController = FlowControllerMock<PlantsFlow>(navigationController: UINavigationController())
    
    private func createViewModel() -> AddPlantViewModel {
        Resolver.registerUseCaseMocks()
        return AddPlantViewModel(flowController: flowController, editingId: nil, onShouldRefresh: {})
    }
    
    // MARK: - Tests
    
    func testAlertDataChanged() async {
        // given
        let vm = createViewModel()
        let alertData = AlertData(title: "Test Alert")
        
        // when
        vm.onIntent(.alertDataChanged(alertData))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.alertData?.title, alertData.title)
    }
    
    func testSnackbarDataChanged() async {
        // given
        let vm = createViewModel()
        let snackbarData = SnackbarData(message: "Test Snackbar")
        
        // when
        vm.onIntent(.snackbarDataChanged(snackbarData))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.snackbarData?.message, snackbarData.message)
    }
    
    func testNavigateBack() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.navigateBack)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertNotNil(vm.state.alertData)
        XCTAssertEqual(vm.state.alertData?.title, Strings.plantCreationCancelAlertTitle)
    }
    
    func testPickRoom() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.pickRoom)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.flowValue, .presentPickRoom(onSave: { _ in }))
    }
    
    func testShowPeriodSettings() async {
        // given
        let vm = createViewModel()
        let taskType = TaskType.watering
        
        // when
        vm.onIntent(.showPeriodSettings(taskType: taskType))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(
            flowController.flowValue,
            .showPeriodSettings(periods: vm.state.tasks[taskType]?.periods ?? [], onSave: { _ in })
        )
    }
    
    func testCreatePlant() async {
        // given
        let vm = createViewModel()
        vm.onIntent(.nameChanged("Test Plant"))
        vm.onIntent(.uploadImage(UIImage()))
        
        // when
        vm.onIntent(.createPlant)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.flowValue, .pop)
    }
    
    func testDeletePlant() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.deletePlant)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertNotNil(vm.state.alertData)
        XCTAssertEqual(vm.state.alertData?.title, Strings.plantCreationDeleteAlertTitle)
    }
    
    func testNameChanged() async {
        // given
        let vm = createViewModel()
        let name = "Test Plant"
        
        // when
        vm.onIntent(.nameChanged(name))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.name, name)
    }
    
    func testUploadImage() async {
        // given
        let vm = createViewModel()
        
        // Create a valid UIImage
        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContext(size)
        let validImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let image = validImage else {
            XCTFail("Failed to create a valid UIImage")
            return
        }
        
        // when
        vm.onIntent(.uploadImage(image))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertFalse(vm.state.uploadedImages.isEmpty)
    }
    
    func testToggleImagePicker() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.toggleImagePicker)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertTrue(vm.state.isImagePickerPresented)
    }
    
    func testToggleCameraPicker() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.toggleCameraPicker)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertTrue(vm.state.isCameraPickerPresented)
    }
}
