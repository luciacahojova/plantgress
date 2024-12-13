//
//  DefaultFirebaseAuthProvider.swift
//  FirebaseAuthProvider
//
//  Created by Lucia Cahojova on 08.12.2024.
//

import FirebaseAuth
import SharedDomain

public struct DefaultFirebaseAuthProvider: FirebaseAuthProvider {
    public init() {}
    
    public func isEmailVerified() -> Bool {
        guard let user = Auth.auth().currentUser else { return false }
        return user.emailVerified()
    }
    
    public func registerUser(credentials: RegistrationCredentials) async throws -> String {
        do {
            let user = try await Auth.auth().createUser(withEmail: credentials.email, password: credentials.password).user
            return user.uid
        } catch let error as NSError {
            guard let authErrorCode = AuthErrorCode.init(rawValue: error._code) else {
                throw AuthError.default
            }
            
            switch authErrorCode {
            case .emailAlreadyInUse:
                throw AuthError.emailAlreadyInUse
            default:
                throw AuthError.default
            }
        }
    }
    
    public func sendEmailVerification() async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.userNotFound
        }
        
        if user.isEmailVerified {
            throw AuthError.emailAlreadyVerified
        }
        
        do {
            try await user.sendEmailVerification()
        } catch  {
            guard let authErrorCode = AuthErrorCode.init(rawValue: error._code) else {
                throw AuthError.default
            }
            
            switch authErrorCode {
            case .userNotFound:
                throw AuthError.userNotFound
            case .tooManyRequests:
                throw AuthError.tooManyRequests
            default:
                throw AuthError.default
            }
        }
    }
    
    public func logInUser(credentials: LoginCredentials) async throws {
        do {
            let user = try await Auth.auth().signIn(withEmail: credentials.email, password: credentials.password).user
            
            try await Auth.auth().updateCurrentUser(user)
        } catch let error as NSError {
            guard let authErrorCode = AuthErrorCode.init(rawValue: error._code) else {
                throw AuthError.default
            }
            
            switch authErrorCode {
            case  .invalidCredential:
                throw AuthError.invalidEmail
            case  .userNotFound:
                throw AuthError.userNotFound
            case .wrongPassword:
                throw AuthError.wrongPassword
            case .unverifiedEmail:
                throw AuthError.emailNotVerified
            case .invalidEmail:
                throw AuthError.invalidEmailFormat
            default:
                throw AuthError.default
            }
        }
    }
    
    public func logOutUser() throws {
        try Auth.auth().signOut()
    }
    
    public func getUserEmail() -> String? {
        Auth.auth().currentUser?.email
    }
    
    public func getUserId() -> String? {
        Auth.auth().getUserID()
    }
    
    public func deleteUser() {
        Auth.auth().currentUser?.delete()
    }
    
    public func sendPasswordReset(email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch let error as NSError {
            guard let authErrorCode = AuthErrorCode.init(rawValue: error._code) else {
                throw AuthError.default
            }
            
            switch authErrorCode {
            case  .userNotFound:
                throw AuthError.userNotFound
            default:
                throw AuthError.default
            }
        }
    }
}
