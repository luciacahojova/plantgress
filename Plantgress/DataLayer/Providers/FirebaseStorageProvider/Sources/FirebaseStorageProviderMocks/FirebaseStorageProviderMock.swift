//
//  FirebaseStorageProviderMock.swift
//  FirebaseStorageProvider
//
//  Created by Lucia Cahojova on 08.12.2024.
//

import Foundation
import FirebaseStorageProvider
import FirebaseStorage
import UIKit
import Foundation

public final class FirebaseStorageProviderMock: FirebaseStorageProvider {
    // Tracking calls
    public var uploadCallsCount = 0
    public var downloadPathCallsCount = 0
    public var downloadUrlCallsCount = 0
    public var deleteCallsCount = 0
    public var getDownloadURLCallsCount = 0

    // Captured arguments
    public var uploadPathReceived: String?
    public var uploadDataReceived: Data?
    public var uploadMetadataReceived: StorageMetadata?

    // Configurable return values and errors
    public var uploadReturnValue: URL?
    public var downloadPathReturnValue: Data?
    public var downloadUrlReturnValue: Data?
    public var deleteError: Error?
    public var getDownloadURLReturnValue: URL?

    public var uploadError: Error?
    public var downloadPathError: Error?
    public var downloadUrlError: Error?
    public var getDownloadURLError: Error?

    public init() {}

    public func upload(path: String, data: Data, metadata: StorageMetadata?) async throws -> URL {
        uploadCallsCount += 1
        uploadPathReceived = path
        uploadDataReceived = data
        uploadMetadataReceived = metadata

        if let error = uploadError {
            throw error
        }

        guard let returnValue = uploadReturnValue else {
            throw NSError(domain: "FirebaseStorageProviderMock", code: 1, userInfo: [NSLocalizedDescriptionKey: "Upload return value not set"])
        }
        return returnValue
    }

    public func download(path: String) async throws -> Data {
        downloadPathCallsCount += 1

        if let error = downloadPathError {
            throw error
        }

        guard let returnValue = downloadPathReturnValue else {
            throw NSError(domain: "FirebaseStorageProviderMock", code: 2, userInfo: [NSLocalizedDescriptionKey: "Download (path) return value not set"])
        }
        return returnValue
    }

    public func download(url: URL) async throws -> Data {
        downloadUrlCallsCount += 1

        if let error = downloadUrlError {
            throw error
        }

        guard let returnValue = downloadUrlReturnValue else {
            throw NSError(domain: "FirebaseStorageProviderMock", code: 3, userInfo: [NSLocalizedDescriptionKey: "Download (url) return value not set"])
        }
        return returnValue
    }

    public func delete(path: String) async throws {
        deleteCallsCount += 1

        if let error = deleteError {
            throw error
        }
    }

    public func getDownloadURL(path: String) async throws -> URL {
        getDownloadURLCallsCount += 1

        if let error = getDownloadURLError {
            throw error
        }

        guard let returnValue = getDownloadURLReturnValue else {
            throw NSError(domain: "FirebaseStorageProviderMock", code: 4, userInfo: [NSLocalizedDescriptionKey: "GetDownloadURL return value not set"])
        }
        return returnValue
    }
}
