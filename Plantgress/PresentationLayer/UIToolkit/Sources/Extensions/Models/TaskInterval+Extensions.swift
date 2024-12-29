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
            return "Repeats every \(interval) day(s) in \(monthText)"
            
        case .yearly(let date):
            return "Repeat every year on \(date.day).\(date.month)" // TODO: Format
        }
    }
    
    private func formatMonthList(_ months: [String]) -> String {
        guard !months.isEmpty else { return "no specific months" }
        
        let sortedMonths = months
            .compactMap { monthName in
                Calendar.current.monthSymbols.firstIndex(of: monthName).map { $0 + 1 }
            }
            .sorted()
            .map { Calendar.current.monthSymbols[$0 - 1] }
        
        if sortedMonths.count == 1 {
            return sortedMonths[0]
        } else if sortedMonths.count == 2 {
            return "\(sortedMonths[0]) and \(sortedMonths[1])"
        } else {
            let last = sortedMonths.last!
            let allButLast = sortedMonths.dropLast()
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
