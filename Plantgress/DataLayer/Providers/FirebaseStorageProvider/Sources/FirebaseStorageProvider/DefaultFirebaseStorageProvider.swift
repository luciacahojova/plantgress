//
//  DefaultFirebaseStorageProvider.swift
//  FirebaseStorageProvider
//
//  Created by Lucia Cahojova on 08.12.2024.
//

import FirebaseStorage
import Foundation
import Utilities

public struct DefaultFirebaseStorageProvider: FirebaseStorageProvider {
    public init() {}
    
    private let storage = Storage.storage()
    
    public func upload(
        path: String,
        data: Data,
        metadata: StorageMetadata? = nil
    ) async throws -> URL {
        print("➡️ UPLOAD: \(path)")
        
        let storageRef = storage.reference(withPath: path)
        
        do {
            let metadataResult = try await storageRef.putDataAsync(data, metadata: metadata)
            let downloadURL = try await storageRef.downloadURL()
            
            print("🟢 \(path): uploaded with metadata \(String(describing: metadataResult))")
            return downloadURL
        } catch let error {
            print("❌ \(path): \(error.localizedDescription)")
            throw DatabaseError.updateFailed
        }
    }
    
    public func download(
        path: String
    ) async throws -> Data {
        print("➡️ DOWNLOAD: \(path)")
        
        let storageRef = storage.reference(forURL: path)
        
        do {
            let data = try await storageRef.data(maxSize: 10 * 1024 * 1024)
            print("🟢 \(path): downloaded \(data.count) bytes")
            return data
        } catch let error {
            print("❌ \(path): \(error.localizedDescription)")
            throw DatabaseError.notFound
        }
    }
    
    public func download(
        url: URL
    ) async throws -> Data {
        print("➡️ DOWNLOAD FROM URL: \(url)")
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            print("🟢 \(url): downloaded \(data.count) bytes")
            return data
        } catch let error {
            print("❌ \(url): \(error.localizedDescription)")
            throw error
        }
    }
    
    public func delete(
        path: String
    ) async throws {
        print("➡️ DELETE: \(path)")
        
        let storageRef = storage.reference(withPath: path)
        
        do {
            try await storageRef.delete()
            print("🟢 \(path): deleted")
        } catch let error {
            print("❌ \(path): \(error.localizedDescription)")
            throw DatabaseError.deleteFailed
        }
    }
    
    public func getDownloadURL(
        path: String
    ) async throws -> URL {
        print("➡️ GET DOWNLOAD URL: \(path)")
        
        let storageRef = storage.reference(withPath: path)
        
        do {
            let downloadURL = try await storageRef.downloadURL()
            print("🟢 \(path): download URL is \(downloadURL)")
            return downloadURL
        } catch let error {
            print("❌ \(path): \(error.localizedDescription)")
            throw DatabaseError.notFound
        }
    }
}
