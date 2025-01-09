//
//  PlantDetailViewModelTests.swift
//  Plants
//
//  Created by Lucia Cahojova on 05.01.2025.
//

@testable import Plants
import SharedDomain
import UIToolkit
import XCTest
import Resolver

@MainActor
final class PlantDetailViewModelTests: XCTestCase {
    
    private let flowController = FlowControllerMock<PlantsFlow>(navigationController: UINavigationController())
    
    private func createViewModel(plantId: UUID = UUID()) -> PlantDetailViewModel {
        Resolver.registerUseCaseMocks()
        return PlantDetailViewModel(
            flowController: flowController,
            plantId: plantId,
            onShouldRefresh: {}
        )
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
        XCTAssertEqual(vm.state.snackbarData?.message, snackbarData.message)
    }
    
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
    
    func testRefresh() async {
        // given
        let plantId = UUID()
        let vm = createViewModel(plantId: plantId)
        
        // when
        vm.onIntent(.refresh)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.plant?.id, plantId)
    }
    
    func testNavigateBack() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.navigateBack)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.flowValue, .pop)
    }
    
    func testSelectedSectionChanged() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.selectedSectionChanged(.tasks))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.selectedSection, .tasks)
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
        XCTAssertNil(vm.state.snackbarData)
    }
    
    func testCompleteTask() async {
        // given
        let plantId = UUID()
        let vm = createViewModel(plantId: plantId)
        let taskType = TaskType.watering
        
        // when
        vm.onIntent(.completeTask(taskType: taskType))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertNotNil(vm.state.upcomingTasks)
    }
}

