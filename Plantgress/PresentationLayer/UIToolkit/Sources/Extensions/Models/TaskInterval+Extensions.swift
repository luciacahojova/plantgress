//
//  TaskInterval+Extensions.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 29.12.2024.
//

import SharedDomain
import Foundation

public extension TaskInterval {
    var description: String {
        switch self {
        case .daily(let interval):
            return "Repeats every \(interval) day(s)" // TODO: Strings
            
        case let .weekly(interval, weekday):
            let weekdayName = Calendar.current.weekdaySymbols[(weekday - 1) % 7]
            return "Repeats every \(interval) week(s) on \(weekdayName)"
            
        case let .monthly(interval, months):
            let monthNames = months.map { Calendar.current.monthSymbols[$0 - 1] }
            let monthText = formatMonthList(monthNames)
            return "Repeats every \(interval) month(s) in \(monthText)"
            
        case .yearly(let dates):
            let dateStrings = dates.map { "\($0.day) \((Calendar.current.monthSymbols[$0.month - 1]))" }
            let datesText = dateStrings.joined(separator: ", ")
            return "Specific dates: \(datesText)"
        }
    }
    
    private func formatMonthList(_ months: [String]) -> String {
        guard !months.isEmpty else { return "no specific months" }
        if months.count == 1 {
            return months[0]
        } else if months.count == 2 {
            return "\(months[0]) and \(months[1])"
        } else {
            let last = months.last!
            let allButLast = months.dropLast()
            return "\(allButLast.joined(separator: ", ")) and \(last)"
        }
    }

    var name: String {
        switch self {
        case .daily: "Daily" // TODO: Strings
        case .weekly: "Weekly"
        case .monthly: "Montly"
        case .yearly: "Yearly"
        }
    }
}
