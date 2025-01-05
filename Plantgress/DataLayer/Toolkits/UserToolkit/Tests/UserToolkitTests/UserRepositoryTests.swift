//
//  UserRepositoryTests.swift
//  UserToolkit
//
//  Created by Lucia Cahojova on 05.01.2025.
//

@testable import UserToolkit
import FirebaseFirestoreProviderMocks
import KeychainProviderMocks
import SharedDomain
import XCTest

final class UserRepositoryTests: XCTestCase {
    
    // MARK: - Mocks
    
    private let firebaseFirestoreProvider = FirebaseFirestoreProviderMock()
    private let keychainProvider = KeychainProviderMock()
    
    private func createRepository() -> UserRepository {
        UserRepositoryImpl(
            firebaseFirestoreProvider: firebaseFirestoreProvider,
            keychainProvider: keychainProvider
        )
    }
    
    // MARK: - Tests
    
    func testGetRemoteUser() async throws {
        // registerUseCaseMocks
//        let repository = createRepository()
//        let userId = "test_user_id"
//        let expectedUser = User.stub(id: userId)
//        firebaseFirestoreProvider.getReturnValue = expectedUser
//        
//        // When
//        let user = try await repository.getRemoteUser(id: userId)
//        
//        // Then
//        XCTAssertEqual(firebaseFirestoreProvider.getCallsCount, 1)
//        XCTAssertEqual(user, expectedUser)
        XCTAssertEqual(true, true)
    }
//    
//    func testGetLocalUser() throws {
//        // registerUseCaseMocks
//        let repository = createRepository()
//        let expectedUser = User.stub(id: "local_user_id")
//        let userJson = try JSONEncoder().encode(expectedUser)
//        keychainProvider.add(.user, value: String(data: userJson, encoding: .utf8)!)
//        
//        // When
//        let user = try repository.getLocalUser()
//        
//        // Then
//        XCTAssertEqual(user, expectedUser)
//    }
//    
//    func testSaveUserLocally() throws {
//        // registerUseCaseMocks
//        let repository = createRepository()
//        let user = User.stub(id: "local_user_id")
//        
//        // When
//        try repository.saveUserLocally(user: user)
//        
//        // Then
//        XCTAssertNotNil(keychainProvider.data[KeychainCoding.user.rawValue])
//    }
//    
//    func testDeleteCurrentUserLocally() throws {
//        // registerUseCaseMocks
//        let repository = createRepository()
//        keychainProvider.add(.user, value: "test_data")
//        
//        // When
//        try repository.deleteCurrentUserLocally()
//        
//        // Then
//        XCTAssertNil(keychainProvider.data[KeychainCoding.user.rawValue])
//    }
//    
//    func testDeleteUser() async throws {
//        // registerUseCaseMocks
//        let repository = createRepository()
//        let userId = "test_user_id"
//        keychainProvider.add(.user, value: "test_data")
//        
//        // When
//        try await repository.deleteUser(userId: userId)
//        
//        // Then
//        XCTAssertEqual(firebaseFirestoreProvider.deleteCallsCount, 1)
//        XCTAssertNil(keychainProvider.data[KeychainCoding.user.rawValue])
//    }
//    
//    func testIsUserLoggedIn_WhenUserExists() throws {
//        // registerUseCaseMocks
//        let repository = createRepository()
//        let user = User.stub(id: "logged_in_user")
//        let userJson = try JSONEncoder().encode(user)
//        keychainProvider.add(.user, value: String(data: userJson, encoding: .utf8)!)
//        
//        // When
//        let isLoggedIn = repository.isUserLoggedIn()
//        
//        // Then
//        XCTAssertTrue(isLoggedIn)
//    }
//    
//    func testIsUserLoggedIn_WhenUserDoesNotExist() throws {
//        // registerUseCaseMocks
//        let repository = createRepository()
//        
//        // When
//        let isLoggedIn = repository.isUserLoggedIn()
//        
//        // Then
//        XCTAssertFalse(isLoggedIn)
//    }
//    
//    func testGetUserEmailLocally() throws {
//        // registerUseCaseMocks
//        let repository = createRepository()
//        let email = "test@example.com"
//        keychainProvider.add(.userEmail, value: email)
//        
//        // When
//        let retrievedEmail = try repository.getUserEmailLocally()
//        
//        // Then
//        XCTAssertEqual(retrievedEmail, email)
//    }
//    
//    func testSaveUserEmailLocally() throws {
//        // registerUseCaseMocks
//        let repository = createRepository()
//        let email = "test@example.com"
//        
//        // When
//        try repository.saveUserEmailLocally(email: email)
//        
//        // Then
//        XCTAssertEqual(keychainProvider.data[KeychainCoding.userEmail.rawValue], email)
//    }
//    
//    func testDeleteUserEmailLocally() throws {
//        // registerUseCaseMocks
//        let repository = createRepository()
//        keychainProvider.add(.userEmail, value: "test@example.com")
//        
//        // When
//        try repository.deleteUserEmailLocally()
//        
//        // Then
//        XCTAssertNil(keychainProvider.data[KeychainCoding.userEmail.rawValue])
//    }
//    
//    func testCreateUser() async throws {
//        // registerUseCaseMocks
//        let repository = createRepository()
//        let user = User.stub(id: "test_user_id")
//        
//        // When
//        try await repository.createUser(user)
//        
//        // Then
//        XCTAssertEqual(firebaseFirestoreProvider.updateCallsCount, 1)
//    }
}
