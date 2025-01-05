//
//  UserRepositoryTests.swift
//  UserToolkit
//
//  Created by Lucia Cahojova on 05.01.2025.
//

@testable import UserToolkit
import FirebaseFirestoreProviderMocks
import KeychainProviderMocks
import KeychainProvider
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
        let repository = createRepository()
        firebaseFirestoreProvider.getReturnValue = User.mock
        
        let user = try await repository.getRemoteUser(id: User.mock.id)
        
        XCTAssertEqual(user, User.mock)
        XCTAssertEqual(firebaseFirestoreProvider.getCallsCount, 1)
    }
    
    func testGetLocalUser() throws {
        let repository = createRepository()
        let userJson = try JSONEncoder().encode(User.mock)
        try keychainProvider.add(.user, value: String(data: userJson, encoding: .utf8)!)
        
        let user = try repository.getLocalUser()
        
        XCTAssertEqual(user, User.mock)
    }
    
    func testSaveUserLocally() throws {
        let repository = createRepository()
        
        try repository.saveUserLocally(user: User.mock)
        
        let storedJson = keychainProvider.data[KeychainCoding.user.rawValue]
        let storedUser = try? JSONDecoder().decode(User.self, from: storedJson!.data(using: .utf8)!)
        XCTAssertEqual(storedUser, User.mock)
    }
    
    func testDeleteCurrentUserLocally() throws {
        let repository = createRepository()
        try keychainProvider.add(.user, value: "test_data")
        
        try repository.deleteCurrentUserLocally()
        
        XCTAssertNil(keychainProvider.data[KeychainCoding.user.rawValue])
    }
    
    func testDeleteUser() async throws {
        let repository = createRepository()
        try keychainProvider.add(.user, value: "test_data")
        
        try await repository.deleteUser(userId: User.mock.id)
        
        XCTAssertEqual(firebaseFirestoreProvider.deleteCallsCount, 1)
        XCTAssertNil(keychainProvider.data[KeychainCoding.user.rawValue])
    }
    
    func testIsUserLoggedIn() throws {
        let repository = createRepository()
        let userJson = try JSONEncoder().encode(User.mock)
        try keychainProvider.add(.user, value: String(data: userJson, encoding: .utf8)!)
        
        XCTAssertTrue(repository.isUserLoggedIn())
    }
    
    func testGetUserEmailLocally() throws {
        let repository = createRepository()
        try keychainProvider.add(.userEmail, value: "test@example.com")
        
        let email = try repository.getUserEmailLocally()
        
        XCTAssertEqual(email, "test@example.com")
    }
    
    func testSaveUserEmailLocally() throws {
        let repository = createRepository()
        
        try repository.saveUserEmailLocally(email: "test@example.com")
        
        XCTAssertEqual(keychainProvider.data[KeychainCoding.userEmail.rawValue], "test@example.com")
    }
    
    func testDeleteUserEmailLocally() throws {
        let repository = createRepository()
        try keychainProvider.add(.userEmail, value: "test@example.com")
        
        try repository.deleteUserEmailLocally()
        
        XCTAssertNil(keychainProvider.data[KeychainCoding.userEmail.rawValue])
    }
    
    func testCreateUser() async throws {
        let repository = createRepository()
        
        try await repository.createUser(User.mock)
        
        XCTAssertEqual(firebaseFirestoreProvider.updateCallsCount, 1)
    }
}

