//
//  ImagesRepository.swift
//  ImagesToolkit
//
//  Created by Lucia Cahojova on 11.12.2024.
//

import FirebaseStorageProvider
import SharedDomain

public struct ImagesRepositoryImpl: ImagesRepository {
    
    private let firebaseStorageProvider: FirebaseStorageProvider
    
    public init(firebaseStorageProvider: FirebaseStorageProvider) {
        self.firebaseStorageProvider = firebaseStorageProvider
    }
    
}
