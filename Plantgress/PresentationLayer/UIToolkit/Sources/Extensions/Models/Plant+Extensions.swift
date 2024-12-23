//
//  Plant+Extensions.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import Foundation
import SharedDomain

public extension Plant {
    static func mock(id: UUID) -> Plant {
        Plant(
            id: id,
            name: "Monstera",
            roomId: nil,
            images: .mock,
            settings: .mock
        )
    }
}

public extension [Plant] {
    static var mock: [Plant] {
        (0...1).map { _ in .mock(id: UUID()) }
    }
}
