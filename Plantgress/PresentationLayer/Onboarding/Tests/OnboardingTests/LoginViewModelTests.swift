//
//  LoginViewModelTests.swift
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
final class LoginViewModelTests: XCTestCase {
    
    private let flowController = FlowControllerMock<OnboardingFlow>(navigationController: UINavigationController())
    
    private func createViewModel() -> LoginViewModel {
        Resolver.registerUseCaseMocks()
        return LoginViewModel(flowController: flowController)
    }
    
    // MARK: - Tests
    
    func testShowForgottenPassword() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.showForgottenPassword)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.flowValue, .showForgottenPassword)
    }
    
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
    
    func testPasswordChanged() async {
        // given
        let vm = createViewModel()
        let password = "password123"
        
        // when
        vm.onIntent(.passwordChanged(password))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.password, password)
    }
    
    func testSendEmailVerification() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.sendEmailVerification)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.flowValue, .showVerificationLink)
    }
    
    func testLogInUser() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.logInUser)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.flowValue, .setupMain)
    }
}

