//
//  RegistrationViewModelTests.swift
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
final class RegistrationViewModelTests: XCTestCase {
    
    private let flowController = FlowControllerMock<OnboardingFlow>(navigationController: UINavigationController())
    
    private func createViewModel() -> RegistrationViewModel {
        Resolver.registerUseCaseMocks()
        return RegistrationViewModel(flowController: flowController)
    }
    
    // MARK: - Tests
    
    func testRegisterUser() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.registerUser)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.flowValue, .showVerificationLink)
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
    
    func testNameChanged() async {
        // given
        let vm = createViewModel()
        let name = "Test"
        
        // when
        vm.onIntent(.nameChanged(name))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.name, name)
    }
    
    func testSurnameChanged() async {
        // given
        let vm = createViewModel()
        let surname = "User"
        
        // when
        vm.onIntent(.surnameChanged(surname))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.surname, surname)
    }
    
    func testPasswordChanged() async {
        // given
        let vm = createViewModel()
        let password = "Password123"
        
        // when
        vm.onIntent(.passwordChanged(password))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.password, password)
    }
    
    func testRepeatPasswordChanged() async {
        // given
        let vm = createViewModel()
        let repeatPassword = "Password123"
        
        // when
        vm.onIntent(.repeatPasswordChanged(repeatPassword))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(vm.state.repeatPassword, repeatPassword)
    }
}

