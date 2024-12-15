//
//  PlantTask+Extensions.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 15.12.2024.
//

import Foundation
import SharedDomain

public extension PlantTask {
    static func mock(id: UUID) -> PlantTask {
        PlantTask(
            id: id,
            plantId: UUID(),
            plantName: "Monstera",
            imageUrl: "https://fastly.picsum.photos/id/248/3872/2592.jpg?hmac=_F3LsKQyGyWnwQJogUtsd_wyx2YDYnYZ6VZmSMBCxNI",
            taskType: .watering,
            dueDate: Date(),
            isCompleted: false
        )
    }
}

public extension [PlantTask] {
    static var mock: [PlantTask] {
        (0...1).map { _ in .mock(id: UUID()) }
    }
}
