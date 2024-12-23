//
//  DefaultFirebaseFirestoreProvider.swift
//  FirebaseFirestoreProvider
//
//  Created by Lucia Cahojova on 08.12.2024.
//

import FirebaseFirestore
import SharedDomain
import Utilities

import FirebaseFirestore

public struct DefaultFirebaseFirestoreProvider: FirebaseFirestoreProvider {
    public init() {}

    public func create<T: Encodable>(
        path: String,
        id: String,
        data: T
    ) async throws {
        print("➡️ CREATE: \(path)/\(id)")
        
        let db = Firestore.firestore()
        let docRef = db.collection(path).document(id)
        
        do {
            try docRef.setData(from: data)
            
            print("🟢 \(path)/\(id): created \(data)")
        } catch let error {
            print("❌ \(path)/\(id): \(error.localizedDescription)")
            throw error
        }
    }

    public func get<T: Decodable>(
        path: String,
        id: String,
        as type: T.Type
    ) async throws -> T {
        print("➡️ GET: \(path)/\(id)")
        
        let db = Firestore.firestore()
        let docRef = db.collection(path).document(id)
        
        do {
            let snapshot = try await docRef.getDocument()
            let document = try snapshot.data(as: T.self)
            
            print("🟢 \(path)/\(id): \(document)")
            return document
        } catch let error {
            print("❌ \(path)/\(id): \(error.localizedDescription)")
            throw error
        }
    }

    public func get<T: Decodable>(
        path: String,
        filters: [FirestoreFilter] = [],
        orderBy: [FirestoreOrder]? = nil,
        limit: Int? = nil,
        as type: T.Type
    ) async throws -> [T] {
        print("➡️ GET: \(path)")
        
        let db = Firestore.firestore()
        let collectionRef = db.collection(path)
        var query: Query = collectionRef

        // Apply filters
        for filter in filters {
            switch filter.operator {
            case .isEqualTo:
                query = query.whereField(filter.field, isEqualTo: filter.value)
            case .isNotEqualTo:
                query = query.whereField(filter.field, isNotEqualTo: filter.value)
            case .isGreaterThan:
                query = query.whereField(filter.field, isGreaterThan: filter.value)
            case .isLessThan:
                query = query.whereField(filter.field, isLessThan: filter.value)
            case .isGreaterThanOrEqualTo:
                query = query.whereField(filter.field, isGreaterThanOrEqualTo: filter.value)
            case .isLessThanOrEqualTo:
                query = query.whereField(filter.field, isLessThanOrEqualTo: filter.value)
            }
        }

        // Apply ordering
        if let orderBy {
            for order in orderBy {
                query = query.order(by: order.field, descending: order.descending)
            }
        }

        // Apply limit
        if let limit {
            query = query.limit(to: limit)
        }

        do {
            // Fetch and decode documents
            let snapshot = try await query.getDocuments()
            let documents = try snapshot.documents.map { try $0.data(as: T.self) }
            
            print("🟢 \(path): \(documents)")
            return documents
        } catch let error {
            print("❌ \(path): \(error.localizedDescription)")
            throw error
        }
    }
    
    public func getAll<T: Decodable>(
        path: String,
        as type: T.Type
    ) async throws -> [T] {
        print("➡️ GET ALL: \(path)")
        
        let db = Firestore.firestore()
        let collectionRef = db.collection(path)
        
        do {
            let snapshot = try await collectionRef.getDocuments()
            let documents = try snapshot.documents.map { try $0.data(as: T.self) }
            
            print("🟢 \(path): \(documents.count) documents fetched")
//            print("🟢 \(path): \(documents.count) documents fetched: \(snapshot.documents.map { $0.data() })")
            return documents
        } catch let error {
            print("❌ \(path): \(error.localizedDescription)")
            throw error
        }
    }

    public func update<T: Encodable>(
        path: String,
        id: String,
        data: T
    ) async throws {
        print("➡️ UPDATE: \(path)/\(id)")
        let db = Firestore.firestore()
        let docRef = db.collection(path).document(id)
        
        do {
            try docRef.setData(from: data, merge: true)
            
            print("🟢 \(path)/\(id): updated \(data)")
        } catch let error {
            print("❌ \(path)/\(id): \(error.localizedDescription)")
            throw error
        }
    }
    
    public func updateField(
        path: String,
        id: String,
        fields: [String: Any]
    ) async throws {
        print("➡️ UPDATE FIELD: \(path)/\(id)")
        
        let db = Firestore.firestore()
        let docRef = db.collection(path).document(id)
        
        do {
            try await docRef.updateData(fields)
            print("🟢 \(path)/\(id): fields updated \(fields)")
        } catch let error {
            print("❌ \(path)/\(id): \(error.localizedDescription)")
            throw error
        }
    }

    public func delete(
        path: String,
        id: String
    ) async throws {
        print("➡️ DELETE: \(path)/\(id)")
        let db = Firestore.firestore()
        let docRef = db.collection(path).document(id)
        
        do {
            try await docRef.delete()
            
            print("🟢 \(path)/\(id): deleted")
        } catch let error {
            print("❌ \(path)/\(id):  \(error.localizedDescription)")
            throw error
        }
    }
}
