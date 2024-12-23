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
            completionDate: nil,
            isCompleted: false
        )
    }
}

public extension PlantTask {
    func daysUntilDue() -> Int {
        let calendar = Calendar.current
        let now = calendar.startOfDay(for: Date())
        let dueDate = calendar.startOfDay(for: self.dueDate)
        let components = calendar.dateComponents([.day], from: now, to: dueDate)
        return components.day ?? 0
    }
    
    static func daysDifference(from date1: Date, to date2: Date) -> Int {
        let calendar = Calendar.current
        let startDay = calendar.startOfDay(for: date1 < date2 ? date1 : date2)
        let endDay = calendar.startOfDay(for: date1 < date2 ? date2 : date1)
        return calendar.dateComponents([.day], from: startDay, to: endDay).day ?? 0
    }
}

public extension [PlantTask] {
    static var mock: [PlantTask] {
        (0...5).map { _ in .mock(id: UUID()) }
    }
}
