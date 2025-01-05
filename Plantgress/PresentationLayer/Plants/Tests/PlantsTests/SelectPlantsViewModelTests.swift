//
//  SelectPlantsViewModelTests.swift
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
final class SelectPlantsViewModelTests: XCTestCase {
    
    private let flowController = FlowControllerMock<PlantsFlow>(navigationController: UINavigationController())
    
    private func createViewModel(selectedPlants: [Plant] = []) -> SelectPlantsViewModel {
        Resolver.registerUseCaseMocks()
        return SelectPlantsViewModel(flowController: flowController, selectedPlants: selectedPlants, onSave: { _ in })
    }
    
    // MARK: - Tests
    
    func testSelectPlant() async {
        // given
        let plant = Plant.mock(id: UUID())
        let vm = createViewModel(selectedPlants: [])
        
        // when
        vm.onIntent(.selectPlant(plant))
        await vm.awaitAllTasks()
        
        // when deselecting the same plant
        vm.onIntent(.selectPlant(plant))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertNil(flowController.flowValue)
    }
    
    func testSave() async {
        // given
        let plant = Plant.mock(id: UUID())
        let vm = createViewModel(selectedPlants: [plant])
        
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
        let plant = Plant.mock(id: UUID())
        let vm = createViewModel(selectedPlants: [])
        
        // when
        vm.onIntent(.refresh)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertNil(flowController.flowValue)
    }
}

