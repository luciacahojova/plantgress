//
//  String+Extensions.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 09.12.2024.
//

public extension String {
    var isBlank: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
