//
//  OnboardingOverviewViewModelTests.swift
//  Onboarding
//
//  Created by Lucia Cahojova on 05.01.2025.
//

@testable import Onboarding
import UIToolkit
import UIKit
import XCTest

@MainActor
final class OnboardingOverviewViewModelTests: XCTestCase {
    
    private let flowController = FlowControllerMock<OnboardingFlow>(navigationController: UINavigationController())
    
    private func createViewModel(message: String? = nil) -> OnboardingOverviewViewModel {
        return OnboardingOverviewViewModel(flowController: flowController, message: message)
    }
    
    // MARK: - Tests
    
    func testShowLogin() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.showLogin)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.flowValue, .showLogin)
    }
    
    func testShowRegistration() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.showRegistration)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.flowValue, .showRegistration)
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
    
    func testDismissAlert() async {
        // given
        let vm = createViewModel(message: "Test Alert")
        
        // when
        vm.onIntent(.alertDataChanged(nil))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertNil(vm.state.alertData)
    }
}

