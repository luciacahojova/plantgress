//
//  ProfileOverviewViewModelTests.swift
//  Profile
//
//  Created by Lucia Cahojova on 05.01.2025.
//

@testable import Profile
import UIToolkit
import XCTest
import Resolver

@MainActor
final class ProfileOverviewViewModelTests: XCTestCase {
    
    private let flowController = FlowControllerMock<ProfileFlow>(navigationController: UINavigationController())
    
    private func createViewModel() -> ProfileOverviewViewModel {
        Resolver.registerUseCaseMocks()
        return ProfileOverviewViewModel(flowController: flowController)
    }
    
    // MARK: - Tests

    func testShowChangeEmail() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.showChangeEmail)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.flowValue, .showChangeEmail)
    }
    
    func testShowChangeName() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.showChangeName)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.flowValue, .showChangeName)
    }
    
    func testShowChangePassword() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.showChangePassword)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.flowValue, .showChangePassword)
    }
    
    func testAlertDataChanged() async {
        // given
        let vm = createViewModel()
        let alertData = AlertData(title: "Test Alert")
        
        // when
        vm.onIntent(.alertDataChanged(alertData))
        await vm.awaitAllTasks()
        
        // then
        XCTAssertEqual(flowController.flowValue, nil)
    }
    
    func testLogoutUser() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.logoutUser)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertNotNil(vm.state.alertData)
    }
    
    func testDeleteUser() async {
        // given
        let vm = createViewModel()
        
        // when
        vm.onIntent(.deleteUser)
        await vm.awaitAllTasks()
        
        // then
        XCTAssertNotNil(vm.state.alertData)
    }
}
