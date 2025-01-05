//
//  ExploreOverviewViewModelTests.swift
//  Explore
//
//  Created by Lucia Cahojova on 05.01.2025.
//

@testable import Explore
@testable import SharedDomain
import UIToolkit
import UIKit
import XCTest

@MainActor
final class ExploreOverviewViewModelTests: XCTestCase {
    
    private let flowController = FlowControllerMock<ExploreFlow>(navigationController: UINavigationController())
    
    private func createViewModel() -> ExploreOverviewViewModel {
        return ExploreOverviewViewModel(flowController: flowController)
    }
    
    // MARK: - Tests
    
    func testShowLuxmeter() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.showLuxmeter)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.flowValue, .showLuxmeter)
    }
    
    func testShowPlantDiagnostics() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.showPlantDiagnostics)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.flowValue, .showPlantDiagnostics)
    }
}
