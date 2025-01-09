//
//  FirebaseFirestoreProvider.swift
//  FirebaseFirestoreProvider
//
//  Created by Lucia Cahojova on 08.12.2024.
//

import SharedDomain
import FirebaseFirestore

/// Protocol defining operations for interacting with Firebase Firestore.
public protocol FirebaseFirestoreProvider {
    /// Creates a new document in Firestore.
    /// - Parameters:
    ///   - path: The Firestore collection path where the document will be created.
    ///   - id: The unique identifier for the document.
    ///   - data: The data to store in the document, conforming to `Encodable`.
    /// - Throws: An error if the creation operation fails.
    func create<T: Encodable>(path: String, id: String, data: T) async throws
    
    /// Retrieves a single document from Firestore by ID.
    /// - Parameters:
    ///   - path: The Firestore collection path containing the document.
    ///   - id: The unique identifier of the document to retrieve.
    ///   - type: The type of the data to decode, conforming to `Decodable`.
    /// - Returns: The decoded document data as the specified type.
    /// - Throws: An error if the retrieval or decoding fails.
    func get<T: Decodable>(path: String, id: String, as type: T.Type) async throws -> T
    
    /// Retrieves documents from Firestore with optional filtering, ordering, and limiting.
    /// - Parameters:
    ///   - path: The Firestore collection path to query.
    ///   - filters: An array of `FirestoreFilter` objects for filtering results.
    ///   - orderBy: An optional array of `FirestoreOrder` objects for sorting results.
    ///   - limit: An optional maximum number of documents to retrieve.
    ///   - type: The type of the data to decode, conforming to `Decodable`.
    /// - Returns: An array of decoded documents as the specified type.
    /// - Throws: An error if the query, retrieval, or decoding fails.
    func get<T: Decodable>(
        path: String,
        filters: [FirestoreFilter],
        orderBy: [FirestoreOrder]?,
        limit: Int?,
        as type: T.Type
    ) async throws -> [T]
    
    /// Retrieves all documents from a Firestore collection.
    /// - Parameters:
    ///   - path: The Firestore collection path to retrieve all documents from.
    ///   - type: The type of the data to decode, conforming to `Decodable`.
    /// - Returns: An array of all decoded documents as the specified type.
    /// - Throws: An error if the retrieval or decoding fails.
    func getAll<T: Decodable>(path: String, as type: T.Type) async throws -> [T]
    
    /// Updates an existing document in Firestore.
    /// - Parameters:
    ///   - path: The Firestore collection path containing the document.
    ///   - id: The unique identifier of the document to update.
    ///   - data: The data to update in the document, conforming to `Encodable`.
    /// - Throws: An error if the update operation fails.
    func update<T: Encodable>(path: String, id: String, data: T) async throws
    
    /// Updates specific fields of an existing document in Firestore.
    /// - Parameters:
    ///   - path: The Firestore collection path containing the document.
    ///   - id: The unique identifier of the document to update.
    ///   - fields: A dictionary of fields to update in the document.
    /// - Throws: An error if the update operation fails.
    func updateField(path: String, id: String, fields: [String: Any]) async throws
    
    /// Deletes a document from Firestore by ID.
    /// - Parameters:
    ///   - path: The Firestore collection path containing the document.
    ///   - id: The unique identifier of the document to delete.
    /// - Throws: An error if the deletion operation fails.
    func delete(path: String, id: String) async throws
}
