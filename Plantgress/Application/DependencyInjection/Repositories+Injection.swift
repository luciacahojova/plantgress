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
import RoomToolkit
import SharedDomain
import TaskToolkit
import UserToolkit

public extension Resolver {
    static func registerRepositories() {
        
        register { AuthRepositoryImpl(firebaseAuthProvider: resolve()) as AuthRepository }
        
        register { UserRepositoryImpl(firebaseFirestoreProvider: resolve(), keychainProvider: resolve()) as UserRepository }
        
        register { ImagesRepositoryImpl(firebaseStorageProvider: resolve()) as ImagesRepository }
        
        register { PlantRepositoryImpl(firebaseFirestoreProvider: resolve()) as PlantRepository }
        
        register { RoomRepositoryImpl(firebaseFirestoreProvider: resolve()) as RoomRepository }
        
        register { TaskRepositoryImpl() as TaskRepository }
        
    }
}
