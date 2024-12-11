//
//  DefaultFirebaseFirestoreProvider.swift
//  FirebaseFirestoreProvider
//
//  Created by Lucia Cahojova on 08.12.2024.
//

import FirebaseFirestore
import SharedDomain
import Utilities

public struct DefaultFirebaseFirestoreProvider: FirebaseFirestoreProvider {
    public init() {}
    
    public func getUser(id: String) async throws -> User {
        let db = Firestore.firestore()
        
        let usersCollectionReference = db.collection(FirestoreConstants.usersCollection)
        let querySnapshot = try await usersCollectionReference
            .whereField("id", isEqualTo: id)
            .getDocuments()
        
        guard let document = querySnapshot.documents.first else {
            throw UserError.notFound
        }
        
        return try document.data(as: User.self)
    }
    
    public func createUser(_ user: User) async throws {
        let db = Firestore.firestore()
        
        let userEncoded = try Firestore.Encoder().encode(user)
        let documentReference = db.collection(FirestoreConstants.usersCollection).document(user.id)
        
        do  {
            try await documentReference.setData(userEncoded)
        } catch {
            throw UserError.default
        }
    }
}
