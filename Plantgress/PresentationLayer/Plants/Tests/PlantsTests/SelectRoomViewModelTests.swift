//
//  SelectRoomViewModelTests.swift
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
final class SelectRoomViewModelTests: XCTestCase {
    
    private let flowController = FlowControllerMock<PlantsFlow>(navigationController: UINavigationController())
    
    private func createViewModel() -> SelectRoomViewModel {
        Resolver.registerUseCaseMocks()
        return SelectRoomViewModel(
            flowController: flowController,
            selectedRoom: nil,
            onSave: { _ in }
        )
    }
    
    // MARK: - Tests
    
    func testSelectRoom() async {
        // given
        let room = Room.mock(id: UUID())
        let vm = createViewModel()
        
        // when
        vm.onIntent(.selectRoom(room))
        await vm.awaitAllTasks()
        
        // deselect the same room
        vm.onIntent(.selectRoom(room))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertNil(flowController.flowValue)
    }
    
    func testSave() async {
        // given
        let room = Room.mock(id: UUID())
        let vm = createViewModel()
        
        // select a room
        vm.onIntent(.selectRoom(room))
        await vm.awaitAllTasks()
        
        // when
        vm.onIntent(.save)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.flowValue, .dismiss)
    }
    
    func testDismiss() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.dismiss)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.flowValue, .dismiss)
    }
    
    func testRefresh() async {
        // given
        let room = Room.mock(id: UUID())
        let vm = createViewModel()
        
        // when
        vm.onIntent(.refresh)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertNil(flowController.flowValue)
    }
}
