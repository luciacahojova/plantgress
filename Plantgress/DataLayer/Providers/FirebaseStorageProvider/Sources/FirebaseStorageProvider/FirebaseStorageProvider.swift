//
//  FirebaseStorageProvider.swift
//  FirebaseStorageProvider
//
//  Created by Lucia Cahojova on 08.12.2024.
//

import Foundation
import FirebaseStorage

public protocol FirebaseStorageProvider {
    func upload(path: String, data: Data, metadata: StorageMetadata?) async throws -> URL
    func download(path: String) async throws -> Data
    func download(url: URL) async throws -> Data
    func delete(path: String) async throws
    func getDownloadURL(path: String) async throws -> URL
}
