//
//  TaskInterval.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import Foundation

public enum TaskInterval: Codable, Sendable {
    case daily(interval: Int) // Every X days
    case weekly(interval: Int, weekdays: [Int]) // Every X weeks on specific weekdays
    case monthly(interval: Int, months: [Int]) // Every X days in specific months
    case yearly(dates: [SpecificDate]) // Specific dates across years

    public struct SpecificDate: Codable, Sendable {
        
        public let day: Int // Day of the month
        public let month: Int // Month of the year (1 = January, 12 = December)

        public init(day: Int, month: Int) {
            precondition(1...31 ~= day, "Day must be between 1 and 31")
            precondition(1...12 ~= month, "Month must be between 1 and 12")
            self.day = day
            self.month = month
        }
    }

    private enum CodingKeys: String, CodingKey {
        case type, interval, weekdays, months, dates
    }

    private enum PeriodType: String, Codable {
        case daily, weekly, monthly, yearly
    }

    // MARK: - Encoding
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .daily(let interval):
            try container.encode(PeriodType.daily, forKey: .type)
            try container.encode(interval, forKey: .interval)
        case .weekly(let interval, let weekdays):
            try container.encode(PeriodType.weekly, forKey: .type)
            try container.encode(interval, forKey: .interval)
            try container.encode(weekdays, forKey: .weekdays)
        case .monthly(let interval, let months):
            try container.encode(PeriodType.monthly, forKey: .type)
            try container.encode(interval, forKey: .interval)
            try container.encode(months, forKey: .months)
        case .yearly(let dates):
            try container.encode(PeriodType.yearly, forKey: .type)
            try container.encode(dates, forKey: .dates)
        }
    }

    // MARK: - Decoding
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(PeriodType.self, forKey: .type)

        switch type {
        case .daily:
            let interval = try container.decode(Int.self, forKey: .interval)
            self = .daily(interval: interval)
        case .weekly:
            let interval = try container.decode(Int.self, forKey: .interval)
            let weekdays = try container.decode([Int].self, forKey: .weekdays)
            self = .weekly(interval: interval, weekdays: weekdays)
        case .monthly:
            let interval = try container.decode(Int.self, forKey: .interval)
            let months = try container.decode([Int].self, forKey: .months)
            self = .monthly(interval: interval, months: months)
        case .yearly:
            let dates = try container.decode([SpecificDate].self, forKey: .dates)
            self = .yearly(dates: dates)
        }
    }
}
