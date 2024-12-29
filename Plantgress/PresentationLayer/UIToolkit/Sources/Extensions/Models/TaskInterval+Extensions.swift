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
            if interval == 1 {
                return Strings.repeatDailyFormatOne
            } else if interval < 5 {
                return Strings.repeatDailyFormatFew(interval)
            } else {
                return Strings.repeatDailyFormatMany(interval)
            }
            
        case let .weekly(interval, weekday):
            let weekdayName = Calendar.current.weekdaySymbols[(weekday - 1) % 7]
            
            if interval == 1 {
                return Strings.repeatWeeklyFormatOne(weekdayName)
            } else if interval < 5 {
                return Strings.repeatWeeklyFormatFew(interval, weekdayName)
            } else {
                return Strings.repeatWeeklyFormatMany(interval, weekdayName)
            }
            
        case let .monthly(interval, months):
            let monthNames = months.map { Calendar.current.monthSymbols[$0 - 1] }
            let monthText = formatMonthList(monthNames)
            
            if interval == 1 {
                return Strings.repeatMonthlyFormatOne(monthText)
            } else if interval < 5 {
                return Strings.repeatMonthlyFormatFew(interval, monthText)
            } else {
                return Strings.repeatMonthlyFormatMany(interval, monthText)
            }
            
        case .yearly(let date):
            return Strings.repeatYearlyFormat(date.day, date.month)
        }
    }
    
    private func formatMonthList(_ months: [String]) -> String {
        guard !months.isEmpty else { return "" }
        
        let sortedMonths = months
            .compactMap { monthName in
                Calendar.current.monthSymbols.firstIndex(of: monthName).map { $0 + 1 }
            }
            .sorted()
            .map { Calendar.current.monthSymbols[$0 - 1] }
        
        if sortedMonths.count == 1 {
            return sortedMonths[0]
        } else if sortedMonths.count == 2 {
            return Strings.plantCreationSortedMonthsFormat(sortedMonths[0], sortedMonths[1])
        } else {
            let last = sortedMonths.last!
            let allButLast = sortedMonths.dropLast()
            return Strings.plantCreationSortedMonthsFormat(allButLast.joined(separator: ", "), last)
        }
    }

    var name: String {
        switch self {
        case .daily: Strings.plantCreationDaily
        case .weekly: Strings.plantCreationWeekly
        case .monthly: Strings.plantCreationMonthly
        case .yearly: Strings.plantCreationYearly
        }
    }
}
