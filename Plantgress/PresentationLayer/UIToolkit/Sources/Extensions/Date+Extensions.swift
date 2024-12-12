//
//  Date+Extensions.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 12.12.2024.
//

import Foundation

public extension Date {
    func toString(formatter: DateFormatter = Formatter.Date.MMMdyyyy) -> String {
        formatter.locale = .current
        return formatter.string(from: self)
    }
}
