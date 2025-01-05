//
//  VerificationLinkViewModelTests.swift
//  Onboarding
//
//  Created by Lucia Cahojova on 05.01.2025.
//

@testable import Onboarding
import UIToolkit
import UIKit
import XCTest
import Resolver

@MainActor
final class VerificationLinkViewModelTests: XCTestCase {
    
    private let flowController = FlowControllerMock<OnboardingFlow>(navigationController: UINavigationController())
    
    private func createViewModel() -> VerificationLinkViewModel {
        Resolver.registerUseCaseMocks()
        return VerificationLinkViewModel(flowController: flowController, onDismiss: {})
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
    
    func testResendLink() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.resendLink)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertNotNil(vm.state.snackbarData)
        XCTAssertFalse(vm.state.isResendVerificationButtonLoading)
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
    
    func testDismiss() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.dismiss)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.flowValue, .dismiss)
    }
}
