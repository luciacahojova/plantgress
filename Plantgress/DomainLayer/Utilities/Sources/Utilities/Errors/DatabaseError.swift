//
//  DatabaseError.swift
//  Utilities
//
//  Created by Lucia Cahojova on 11.12.2024.
//

import Foundation

public enum DatabaseError: Error {
    case `default`
    
    case invalidUrl
    
    case notFound
    case updateFailed
    case deleteFailed
}
