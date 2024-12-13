//
//  UserError.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 11.12.2024.
//

import Foundation

public enum UserError: Error {
    case `default`
    
    case notFound
    
    case persistenceError
}
