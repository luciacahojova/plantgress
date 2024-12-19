//
//  DatabaseConstants.swift
//  Utilities
//
//  Created by Lucia Cahojova on 11.12.2024.
//

import Foundation

public struct DatabaseConstants {
    public static let usersCollection: String = "users"
    public static let imagesCollection: String = "images"
    public static let roomsCollection: String = "rooms"
    public static let plantsCollection: String = "plants"
    public static let tasksCollection: String = "tasks"
    
    public static func taskPath(plantId: String) -> String {
        return "\(plantsCollection)/\(plantId)/\(tasksCollection)/"
    }
    
    public static func imagePath(userId: String, imageId: String) -> String {
        return "\(usersCollection)/\(userId)/\(imagesCollection)/\(imageId).jpg"
    }
    
    public static func roomPath(roomId: String) -> String {
        return "\(roomsCollection)/\(roomId)"
    }

    public static func plantPath(plantId: String) -> String {
        return "\(plantsCollection)/\(plantId)"
    }
}
