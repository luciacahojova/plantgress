//
//  Repositories+Injection.swift
//  Plantgress
//
//  Created by Lucia Cahojova on 03.12.2024.
//

import AuthToolkit
import ImagesToolkit
import PlantToolkit
import Resolver
import SharedDomain
import UserToolkit

public extension Resolver {
    static func registerRepositories() {
        
        register { AuthRepositoryImpl(firebaseAuthProvider: resolve()) as AuthRepository }
        
        register { UserRepositoryImpl(firebaseFirestoreProvider: resolve(), keychainProvider: resolve()) as UserRepository }
        
        register { ImagesRepositoryImpl(firebaseStorageProvider: resolve()) as ImagesRepository }
        
        register { PlantRepositoryImpl(firebaseFirestoreProvider: resolve()) as PlantRepository }
        
    }
}
