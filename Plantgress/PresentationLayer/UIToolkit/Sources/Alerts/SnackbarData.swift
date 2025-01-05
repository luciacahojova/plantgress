//
//  SnackbarData.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 10.12.2024.
//

import Foundation
import SwiftUICore

public struct SnackbarData {
    public let icon: Image?
    public let message: String
    public let duration: Double
    public let bottomPadding: CGFloat
    public let alignment: Alignment
    public let foregroundColor: Color
    public let backgroundColor: Color
    public let actionText: String?
    public let action: (() -> Void)?
    
    public init(
        icon: Image? = nil,
        message: String,
        duration: Double = 3.0,
        bottomPadding: CGFloat = Constants.Spacing.mediumLarge,
        alignment: Alignment = .bottom,
        foregroundColor: Color = Colors.primaryText,
        backgroundColor: Color = Colors.green,
        actionText: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.message = message
        self.duration = duration
        self.bottomPadding = bottomPadding
        self.alignment = alignment
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.actionText = actionText
        self.action = action
    }
}
