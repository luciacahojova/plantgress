//
//  AuthRepositoryTests.swift
//  AuthToolkit
//
//  Created by Lucia Cahojova on 05.01.2025.
//

@testable import AuthToolkit
import FirebaseAuthProviderMocks
import SharedDomain
import XCTest

final class AuthRepositoryTests: XCTestCase {
    
    // MARK: - Mocks
    
    private let firebaseAuthProvider = FirebaseAuthProviderMock()
    
    private func createRepository() -> AuthRepository {
        AuthRepositoryImpl(firebaseAuthProvider: firebaseAuthProvider)
    }
    
    // MARK: - Tests

    func testIsEmailVerified() {
        // given
        let repository = createRepository()
        firebaseAuthProvider.isEmailVerifiedReturnValue = true

        // when
        let isVerified = repository.isEmailVerified()

        // then
        XCTAssertTrue(isVerified)
        XCTAssertEqual(firebaseAuthProvider.isEmailVerifiedCallsCount, 1)
    }

    func testRegisterUser() async throws {
        // given
        let repository = createRepository()
        let credentials = RegistrationCredentials(
            email: "test@test.com",
            name: "Name",
            surname: "Surname",
            password: "password123"
        )

        // when
        let _ = try await repository.registerUser(credentials: credentials)

        // then
        XCTAssertEqual(firebaseAuthProvider.registerUserCallsCount, 1)
    }

    func testSendEmailVerification() async throws {
        // given
        let repository = createRepository()

        // when
        try await repository.sendEmailVerification()

        // then
        XCTAssertEqual(firebaseAuthProvider.sendEmailVerificationCallsCount, 1)
    }

    func testLogInUser() async throws {
        // given
        let repository = createRepository()
        let credentials = LoginCredentials(email: "test@test.com", password: "password123")

        // when
        try await repository.logInUser(credentials: credentials)

        // then
        XCTAssertEqual(firebaseAuthProvider.logInUserCallsCount, 1)
    }

    func testLogOutUser() throws {
        // given
        let repository = createRepository()

        // when
        try repository.logOutUser()

        // then
        XCTAssertEqual(firebaseAuthProvider.logOutUserCallsCount, 1)
    }

    func testGetUserEmail() {
        // given
        let repository = createRepository()
        let expectedEmail = "test@test.com"
        firebaseAuthProvider.getUserEmailReturnValue = expectedEmail

        // when
        let email = repository.getUserEmail()

        // then
        XCTAssertEqual(email, expectedEmail)
        XCTAssertEqual(firebaseAuthProvider.getUserEmailCallsCount, 1)
    }

    func testGetUserId() {
        // given
        let repository = createRepository()
        let expectedUserId = "user123"
        firebaseAuthProvider.getUserIdReturnValue = expectedUserId

        // when
        let userId = repository.getUserId()

        // then
        XCTAssertEqual(userId, expectedUserId)
        XCTAssertEqual(firebaseAuthProvider.getUserIdCallsCount, 1)
    }

    func testDeleteUser() {
        // given
        let repository = createRepository()

        // when
        repository.deleteUser()

        // then
        XCTAssertEqual(firebaseAuthProvider.deleteUserCallsCount, 1)
    }

    func testSendPasswordReset() async throws {
        // given
        let repository = createRepository()
        let email = "test@test.com"

        // when
        try await repository.sendPasswordReset(email: email)

        // then
        XCTAssertEqual(firebaseAuthProvider.sendPasswordResetCallsCount, 1)
        XCTAssertEqual(firebaseAuthProvider.sendPasswordResetEmailReceived, email)
    }
}
