//
//  FirebaseAuthProviderMock.swift
//  FirebaseAuthProvider
//
//  Created by Lucia Cahojova on 08.12.2024.
//

import FirebaseAuthProvider
import SharedDomain

public final class FirebaseAuthProviderMock: FirebaseAuthProvider {
    // Tracking calls
    public var isEmailVerifiedCallsCount = 0
    public var registerUserCallsCount = 0
    public var sendEmailVerificationCallsCount = 0
    public var logInUserCallsCount = 0
    public var logOutUserCallsCount = 0
    public var getUserEmailCallsCount = 0
    public var getUserIdCallsCount = 0
    public var deleteUserCallsCount = 0
    public var sendPasswordResetCallsCount = 0

    // Captured arguments
    public var registerUserCredentialsReceived: RegistrationCredentials?
    public var logInUserCredentialsReceived: LoginCredentials?
    public var sendPasswordResetEmailReceived: String?

    // Configurable return values and errors
    public var isEmailVerifiedReturnValue: Bool = false
    public var registerUserReturnValue: String?
    public var getUserEmailReturnValue: String?
    public var getUserIdReturnValue: String?
    public var registerUserError: Error?
    public var sendEmailVerificationError: Error?
    public var logInUserError: Error?
    public var logOutUserError: Error?
    public var sendPasswordResetError: Error?

    public init() {}

    public func isEmailVerified() -> Bool {
        isEmailVerifiedCallsCount += 1
        return isEmailVerifiedReturnValue
    }

    public func registerUser(credentials: RegistrationCredentials) async throws -> String {
        registerUserCallsCount += 1
        registerUserCredentialsReceived = credentials
        if let error = registerUserError {
            throw error
        }
        return credentials.email
    }

    public func sendEmailVerification() async throws {
        sendEmailVerificationCallsCount += 1
        if let error = sendEmailVerificationError {
            throw error
        }
    }

    public func logInUser(credentials: LoginCredentials) async throws {
        logInUserCallsCount += 1
        logInUserCredentialsReceived = credentials
        if let error = logInUserError {
            throw error
        }
    }

    public func logOutUser() throws {
        logOutUserCallsCount += 1
        if let error = logOutUserError {
            throw error
        }
    }

    public func getUserEmail() -> String? {
        getUserEmailCallsCount += 1
        return getUserEmailReturnValue
    }

    public func getUserId() -> String? {
        getUserIdCallsCount += 1
        return getUserIdReturnValue
    }

    public func deleteUser() {
        deleteUserCallsCount += 1
    }

    public func sendPasswordReset(email: String) async throws {
        sendPasswordResetCallsCount += 1
        sendPasswordResetEmailReceived = email
        if let error = sendPasswordResetError {
            throw error
        }
    }
}
