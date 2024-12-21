//
//  SnackbarData.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 10.12.2024.
//

import Foundation
import SwiftUICore

public struct SnackbarData {
    let icon: Image?
    let message: String
    let duration: Double
    let bottomPadding: CGFloat
    let alignment: Alignment
    let foregroundColor: Color
    let backgroundColor: Color
    let actionText: String?
    let action: (() -> Void)?
    
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
