//
//  ImageData+Extensions.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import Foundation
import SharedDomain

public extension ImageData {
    static func mock(id: UUID) -> ImageData {
        ImageData(
            id: id,
            date: Date(),
            urlString: "https://fastly.picsum.photos/id/248/3872/2592.jpg?hmac=_F3LsKQyGyWnwQJogUtsd_wyx2YDYnYZ6VZmSMBCxNI"
        )
    }
}

public extension [ImageData] {
    static var mock: [ImageData] {
        (0...3).map { _ in .mock(id: UUID()) }
    }
}
