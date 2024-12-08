//
//  AuthRepository.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 08.12.2024.
//

import Foundation

public protocol AuthRepository {
    func isUserLoggedIn() -> Bool
}
