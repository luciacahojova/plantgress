//
//  PeriodSettingsViewModelTests.swift
//  Plants
//
//  Created by Lucia Cahojova on 05.01.2025.
//

@testable import Plants
import UIToolkit
import SharedDomain
import XCTest

@MainActor
final class PeriodSettingsViewModelTests: XCTestCase {
    
    private let flowController = FlowControllerMock<PlantsFlow>(navigationController: UINavigationController())
    private var onSaveCalledWith: [TaskPeriod]?
    
    private func createViewModel(periods: [TaskPeriod] = []) -> PeriodSettingsViewModel {
        PeriodSettingsViewModel(
            flowController: flowController,
            periods: periods,
            onSave: { [weak self] periods in
                self?.onSaveCalledWith = periods
            }
        )
    }
    
    // MARK: - Tests
    
    func testLoadData() async {
        // given
        let periods = [
            TaskPeriod(id: UUID(), name: "Period 1", interval: .daily(interval: 7)),
            TaskPeriod(id: UUID(), name: "Period 2", interval: .weekly(interval: 2, weekday: 1))
        ]
        let vm = createViewModel(periods: periods)
        
        // then
        XCTAssertEqual(vm.state.periods, periods)
    }
    
    func testSave() async {
        // given
        let periods = [
            TaskPeriod(id: UUID(), name: "Period 1", interval: .daily(interval: 7))
        ]
        let vm = createViewModel(periods: periods)
        
        // when
        vm.onIntent(.save)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(onSaveCalledWith, periods)
        XCTAssertEqual(flowController.flowValue, .dismiss)
    }
    
    func testUpdatePeriod() async {
        // given
        let id = UUID()
        let initialPeriods = [
            TaskPeriod(id: id, name: "Period 1", interval: .daily(interval: 7))
        ]
        let vm = createViewModel(periods: initialPeriods)
        let updatedInterval = TaskInterval.weekly(interval: 2, weekday: 1)
        
        // when
        vm.onIntent(.updatePeriod(id, updatedInterval))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.periods.first?.interval, updatedInterval)
    }
    
    func testAddPeriod() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.addPeriod)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.periods.count, 1)
        XCTAssertEqual(vm.state.periods.first?.name, Strings.plantCreationPeriodFormat(1))
        XCTAssertEqual(vm.state.periods.first?.interval, .daily(interval: 10))
    }
    
    func testRemovePeriod() async {
        // given
        let id = UUID()
        let initialPeriods = [
            TaskPeriod(id: id, name: "Period 1", interval: .daily(interval: 7)),
            TaskPeriod(id: UUID(), name: "Period 2", interval: .weekly(interval: 2, weekday: 1))
        ]
        let vm = createViewModel(periods: initialPeriods)
        
        // when
        vm.onIntent(.removePeriod(id))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.periods.count, 1)
        XCTAssertEqual(vm.state.periods.first?.name, Strings.plantCreationPeriodFormat(1))
    }
}

