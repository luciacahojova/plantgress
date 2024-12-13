//
//  KeychainError.swift
//  KeychainProvider
//
//  Created by Lucia Cahojova on 12.12.2024.
//

public enum KeychainError: Error {
    case `default`
    
    case invalidBundleIdentifier
    case valueForKeyNotFound
}
