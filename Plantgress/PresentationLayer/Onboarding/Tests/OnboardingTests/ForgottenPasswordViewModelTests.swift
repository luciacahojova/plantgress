//
//  ForgottenPasswordViewModelTests.swift
//  Onboarding
//
//  Created by Lucia Cahojova on 05.01.2025.
//

@testable import Onboarding
@testable import SharedDomain
import UIToolkit
import UIKit
import XCTest
import Resolver

@MainActor
final class ForgottenPasswordViewModelTests: XCTestCase {
    
    private let flowController = FlowControllerMock<OnboardingFlow>(navigationController: UINavigationController())
    
    private func createViewModel() -> ForgottenPasswordViewModel {
        Resolver.registerUseCaseMocks()
        return ForgottenPasswordViewModel(flowController: flowController, onDismiss: {})
    }
    
    // MARK: - Tests
    
    func testEmailChanged() async {
        // given
        let vm = createViewModel()
        let email = "test@test.com"
        
        // when
        vm.onIntent(.emailChanged(email))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.email, email)
    }
    
    func testSnackbarDataChanged() async {
        // given
        let vm = createViewModel()
        let snackbarData: SnackbarData = .init(message: "")
        
        // when
        vm.onIntent(.snackbarDataChanged(snackbarData))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.snackbarData?.message, snackbarData.message)
    }
    
    func testShowLogin() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.showLogin)
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
    
    func testSendResetPasswordLink() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.sendResetPasswordLink)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertNil(vm.state.errorMessage)
        XCTAssertFalse(vm.state.isResetPasswordButtonLoading)
        XCTAssertNotNil(vm.state.snackbarData)
    }
}
