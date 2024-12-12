//
//  AlertData.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 12.12.2024.
//

import Foundation
import SwiftUI

public struct AlertData: Equatable, Identifiable {
    
    public var id: String { title + (message ?? "") }
    
    public let title: String
    public let message: String?
    public let primaryAction: AlertAction
    public let secondaryAction: AlertAction?
    
    public init(
        title: String,
        message: String? = nil,
        primaryAction: AlertAction = AlertAction(title: "Close", style: .default), // TODO: String
        secondaryAction: AlertAction? = nil
    ) {
        self.title = title
        self.message = message
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }
    
    public static func == (lhs: AlertData, rhs: AlertData) -> Bool {
        lhs.title == rhs.title &&
        lhs.message == rhs.message &&
        lhs.primaryAction == rhs.primaryAction &&
        lhs.secondaryAction == rhs.secondaryAction
    }
}

public struct AlertAction: Equatable {
    public let title: String
    public let style: Style
    public let completion: (() -> Void)
    
    public init(
        title: String,
        style: Style = .default,
        completion: @escaping (() -> Void) = {}
    ) {
        self.title = title
        self.style = style
        self.completion = completion
    }
    
    public static func == (lhs: AlertAction, rhs: AlertAction) -> Bool {
        lhs.title == rhs.title &&
        lhs.style == rhs.style
    }
}

public extension AlertAction {
    enum Style {
        case `default`
        case cancel
        case destructive
    }
}
