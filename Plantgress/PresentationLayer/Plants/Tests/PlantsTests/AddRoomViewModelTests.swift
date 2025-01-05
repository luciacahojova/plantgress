//
//  AddRoomViewModelTests.swift
//  Plants
//
//  Created by Lucia Cahojova on 05.01.2025.
//

@testable import Plants
import UIToolkit
import XCTest
import Resolver
import SharedDomain

@MainActor
final class AddRoomViewModelTests: XCTestCase {
    
    private let flowController = FlowControllerMock<PlantsFlow>(navigationController: UINavigationController())
    
    private func createViewModel() -> AddRoomViewModel {
        Resolver.registerUseCaseMocks()
        return AddRoomViewModel(
            flowController: flowController,
            editingId: nil,
            onShouldRefresh: {},
            onDelete: {}
        )
    }
    
    // MARK: - Tests
    
    func testNameChanged() async {
        // given
        let vm = createViewModel()
        let name = "Living Room"
        
        // when
        vm.onIntent(.nameChanged(name))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.name, name)
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
    
    func testDeleteRoom() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.deleteRoom)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertNotNil(vm.state.alertData)
        XCTAssertEqual(vm.state.alertData?.title, Strings.roomDeletionAlertTitle)
    }
    
    func testCreateRoom() async {
        // given
        let vm = createViewModel()
        vm.onIntent(.nameChanged("New Room"))
        
        // when
        vm.onIntent(.createRoom)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.flowValue, .pop)
    }
    
    func testAddPlant() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.addPlant)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.flowValue, .presentPickPlants(selectedPlants: [], onSave: { _ in }))
    }
    
    func testRefresh() async {
        // given
        let editingId = UUID()
        let vm = AddRoomViewModel(
            flowController: flowController,
            editingId: editingId,
            onShouldRefresh: {},
            onDelete: {}
        )
        
        // when
        vm.onIntent(.refresh)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.editingId, editingId)
        XCTAssertNotNil(vm.state.name)
        XCTAssertNotNil(vm.state.plants)
    }
}
