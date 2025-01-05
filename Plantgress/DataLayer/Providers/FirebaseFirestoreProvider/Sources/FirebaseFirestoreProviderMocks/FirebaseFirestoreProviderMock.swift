//
//  FirebaseFirestoreProviderMock.swift
//  FirebaseFirestoreProvider
//
//  Created by Lucia Cahojova on 08.12.2024.
//
import Foundation
import FirebaseFirestoreProvider
import SharedDomain

public final class FirebaseFirestoreProviderMock: FirebaseFirestoreProvider {
    public init() {}

    // Tracking method calls
    public var createCallsCount = 0
    public var getCallsCount = 0
    public var getAllCallsCount = 0
    public var updateCallsCount = 0
    public var updateFieldCallsCount = 0
    public var deleteCallsCount = 0

    // Configurable return values and behaviors
    public var getReturnValue: Any?
    public var getReturnValues: [Any] = []
    public var getAllReturnValue: [Any] = []

    public var createError: Error?
    public var getError: Error?
    public var getAllError: Error?
    public var updateError: Error?
    public var updateFieldError: Error?
    public var deleteError: Error?
    
    public func create<T: Encodable>(path: String, id: String, data: T) async throws {
        createCallsCount += 1
        if let error = createError {
            throw error
        }
    }

    public func get<T: Decodable>(path: String, id: String, as type: T.Type) async throws -> T {
        getCallsCount += 1
        if let error = getError {
            throw error
        }
        guard let returnValue = getReturnValue as? T else {
            throw NSError(domain: "FirebaseFirestoreProviderMock", code: 1, userInfo: [NSLocalizedDescriptionKey: "No return value set for get(path:id:)"])
        }
        return returnValue
    }

    public func get<T: Decodable>(
        path: String,
        filters: [FirestoreFilter],
        orderBy: [FirestoreOrder]?,
        limit: Int?,
        as type: T.Type
    ) async throws -> [T] {
        getCallsCount += 1
        if let error = getError {
            throw error
        }
        guard let returnValues = getReturnValues as? [T] else {
            throw NSError(domain: "FirebaseFirestoreProviderMock", code: 2, userInfo: [NSLocalizedDescriptionKey: "No return values set for get(path:filters:orderBy:limit:)"])
        }
        return returnValues
    }

    public func getAll<T: Decodable>(path: String, as type: T.Type) async throws -> [T] {
        getAllCallsCount += 1
        if let error = getAllError {
            throw error
        }
        guard let returnValue = getAllReturnValue as? [T] else {
            throw NSError(domain: "FirebaseFirestoreProviderMock", code: 3, userInfo: [NSLocalizedDescriptionKey: "No return value set for getAll(path:)"])
        }
        return returnValue
    }

    public func update<T: Encodable>(path: String, id: String, data: T) async throws {
        updateCallsCount += 1
        if let error = updateError {
            throw error
        }
    }

    public func updateField(path: String, id: String, fields: [String: Any]) async throws {
        updateFieldCallsCount += 1
        if let error = updateFieldError {
            throw error
        }
    }

    public func delete(path: String, id: String) async throws {
        deleteCallsCount += 1
        if let error = deleteError {
            throw error
        }
    }
}
