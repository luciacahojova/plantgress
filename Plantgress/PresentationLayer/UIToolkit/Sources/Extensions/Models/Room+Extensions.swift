//
//  Room+Extensions.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 15.12.2024.
//

import Foundation
import SharedDomain

public extension Room {
    static func mock(id: UUID) -> Room {
        Room(
            id: id,
            name: "Living room",
            imageUrls: [
                "https://fastly.picsum.photos/id/248/3872/2592.jpg?hmac=_F3LsKQyGyWnwQJogUtsd_wyx2YDYnYZ6VZmSMBCxNI",
                "https://fastly.picsum.photos/id/248/3872/2592.jpg?hmac=_F3LsKQyGyWnwQJogUtsd_wyx2YDYnYZ6VZmSMBCxNI",
                "https://fastly.picsum.photos/id/248/3872/2592.jpg?hmac=_F3LsKQyGyWnwQJogUtsd_wyx2YDYnYZ6VZmSMBCxNI"
            ]
        )
    }
}

public extension [Room] {
    static var mock: [Room] {
        (0...3).map { _ in .mock(id: UUID()) }
    }
}
