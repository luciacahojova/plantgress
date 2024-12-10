//
//  SecondaryButtonStyle.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 10.12.2024.
//

import SwiftUI

public struct SecondaryButtonStyle: ButtonStyle {
    
    private let isLoading: Bool
    private let isDisabled: Bool
    private let foregroundColor: Color
    private let font: Font
    private let underline: Bool
    
    public init(
        isLoading: Bool = false,
        isDisabled: Bool = false,
        foregroundColor: Color = Colors.primaryText,
        font: Font = Fonts.bodySemibold,
        underline: Bool = true
    ) {
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.foregroundColor = foregroundColor
        self.font = font
        self.underline = underline
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        VStack {
            if isLoading {
                ProgressView()
                    .tint(foregroundColor)
            } else {
                configuration.label
                    .font(font)
                    .minimumScaleFactor(0.75)
                    .frame(height: 24)
                    .underline(underline)
            }
        }
        .foregroundColor(foregroundColor)
        .frame(maxWidth: .infinity)
        .frame(minHeight: Constants.Frame.primaryButtonHeight)
        .opacity((configuration.isPressed || isDisabled) ? 0.8 : 1)
        .animation(.linear(duration: 0.1), value: configuration.isPressed)
        .allowsHitTesting(!isLoading && !isDisabled)
    }
}
