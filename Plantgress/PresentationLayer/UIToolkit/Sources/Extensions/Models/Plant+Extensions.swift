//
//  Plant+Extensions.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import Foundation
import SharedDomain

public extension Plant {
    static var mock: Plant {
        Plant(
            id: UUID(),
            name: "Monstera",
            settings: .mock
        )
    }
}

public extension [Plant] {
    static var mock: [Plant] {
        (0..<3).map { _ in .mock }
    }
}
