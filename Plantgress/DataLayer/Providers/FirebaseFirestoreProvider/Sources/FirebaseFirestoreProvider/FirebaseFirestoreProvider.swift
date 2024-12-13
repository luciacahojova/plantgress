//
//  FirebaseFirestoreProvider.swift
//  FirebaseFirestoreProvider
//
//  Created by Lucia Cahojova on 08.12.2024.
//

import SharedDomain
import FirebaseFirestore

public protocol FirebaseFirestoreProvider {
    func create<T: Encodable>(path: String, id: String, data: T) async throws
    func get<T: Decodable>(path: String, id: String, as type: T.Type) async throws -> T
    func get<T: Decodable>(
        path: String,
        filters: [FirestoreFilter],
        orderBy: [FirestoreOrder]?,
        limit: Int?,
        as type: T.Type
    ) async throws -> [T]
    func update<T: Encodable>(path: String, id: String, data: T) async throws
    func delete(path: String, id: String) async throws
}
