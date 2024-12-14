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
    
    public static func imagePath(userId: String, imageId: String) -> String {
        return "\(usersCollection)/\(userId)/\(imagesCollection)/\(imageId).jpg"
    }
}
