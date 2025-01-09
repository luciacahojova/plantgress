//
//  FirebaseStorageProvider.swift
//  FirebaseStorageProvider
//
//  Created by Lucia Cahojova on 08.12.2024.
//

import Foundation
import FirebaseStorage

/// Protocol defining operations for interacting with Firebase Storage.
public protocol FirebaseStorageProvider {
    /// Uploads data to a specified path in Firebase Storage.
    /// - Parameters:
    ///   - path: The path in Firebase Storage where the data will be uploaded.
    ///   - data: The data to upload.
    ///   - metadata: Optional metadata to include with the upload.
    /// - Returns: The download URL of the uploaded data.
    /// - Throws: An error if the upload operation fails.
    func upload(path: String, data: Data, metadata: StorageMetadata?) async throws -> URL
    
    /// Downloads data from a specified path in Firebase Storage.
    /// - Parameter path: The path in Firebase Storage to download data from.
    /// - Returns: The downloaded data as `Data`.
    /// - Throws: An error if the download operation fails.
    func download(path: String) async throws -> Data
    
    /// Downloads data from a specified URL.
    /// - Parameter url: The URL to download data from.
    /// - Returns: The downloaded data as `Data`.
    /// - Throws: An error if the download operation fails.
    func download(url: URL) async throws -> Data
    
    /// Deletes data from a specified path in Firebase Storage.
    /// - Parameter path: The path in Firebase Storage to delete data from.
    /// - Throws: An error if the delete operation fails.
    func delete(path: String) async throws
    
    /// Retrieves the download URL for a file at a specified path in Firebase Storage.
    /// - Parameter path: The path in Firebase Storage to retrieve the download URL for.
    /// - Returns: The download URL as `URL`.
    /// - Throws: An error if the operation fails.
    func getDownloadURL(path: String) async throws -> URL
}
