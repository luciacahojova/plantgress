//
//  TaskItem+Extensions.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 19.12.2024.
//

import Foundation
import SharedDomain

public extension PlantTask { // TODO: Move
    static var mock: PlantTask {
        PlantTask(
            id: UUID(),
            plantId: UUID(),
            plantName: "Monstera",
            imageUrl: "https://fastly.picsum.photos/id/248/3872/2592.jpg?hmac=_F3LsKQyGyWnwQJogUtsd_wyx2YDYnYZ6VZmSMBCxNI",
            taskType: .watering,
            dueDate: Date().addingTimeInterval(86400), // 1 day from now
            isCompleted: false
        )
    }
}

public extension ProgressTask { // TODO: Move
    static var mock: ProgressTask {
        ProgressTask(
            id: UUID(),
            plantId: UUID(),
            plantName: "Monstera",
            imageUrl: "https://fastly.picsum.photos/id/248/3872/2592.jpg?hmac=_F3LsKQyGyWnwQJogUtsd_wyx2YDYnYZ6VZmSMBCxNI",
            dueDate: Date().addingTimeInterval(86400 * 2), // 2 days from now
            isCompleted: false
        )
    }
}

public extension [TaskItem] {
    static var mock: [TaskItem] {
        [
            PlantTask.mock,
            ProgressTask.mock
        ]
    }
}
