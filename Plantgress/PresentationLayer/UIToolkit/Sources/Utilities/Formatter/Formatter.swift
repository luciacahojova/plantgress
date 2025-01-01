//
//  Formatter.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 12.12.2024.
//

import Foundation

public struct Formatter {
    public enum Date {
        public static let HHmm = Formatter.createDateFormatter(dateFormat: "HH:mm")
        public static let MMMdyyyy = Formatter.createDateFormatter(dateFormat: "MMM d, yyyy")
        public static let ddMMyy = Formatter.createDateFormatter(dateFormat: "dd/MM/yy")
        public static let ddMM = Formatter.createDateFormatter(dateFormat: "      dd/MM      ")
        public static let MMM = Formatter.createDateFormatter(dateFormat: "MMM")
        public static let MMMMyyyy = Formatter.createDateFormatter(dateFormat: "MMMM yyyy")
    }
    
    /// Creates a DateFormatter based on a given date format.
    private static func createDateFormatter(dateFormat: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.timeZone = .current
        formatter.dateFormat = dateFormat
        return formatter
    }
}
