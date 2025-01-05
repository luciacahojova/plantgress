//
//  PlantTask+Extensions.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 15.12.2024.
//

import Foundation
import SharedDomain

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
        let startDay = calendar.startOfDay(for: date1)
        let endDay = calendar.startOfDay(for: date2)
        
        let difference = calendar.dateComponents([.day], from: startDay, to: endDay).day ?? 0
        return difference
    }
}
