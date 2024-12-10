//
//  PrimaryButtonStyle.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 09.12.2024.
//

import SwiftUI

public struct PrimaryButtonStyle: ButtonStyle {
    
    private let isLoading: Bool
    private let isDisabled: Bool
    private let foregroundColor: Color
    private let backgroundColor: Color
    private let cornerRadius: CGFloat
    private let font: Font
    
    public init(
        isLoading: Bool = false,
        isDisabled: Bool = false,
        foregroundColor: Color = Colors.primaryBackground,
        backgroundColor: Color = Colors.primaryButton,
        cornerRadius: CGFloat = Constants.CornerRadius.large,
        font: Font = Fonts.bodySemibold
    ) {
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = Constants.CornerRadius.xLarge
        self.font = font
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
            }
        }
        .foregroundColor(foregroundColor)
        .frame(maxWidth: .infinity)
        .frame(minHeight: Constants.Frame.primaryButtonHeight)
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
        .opacity((configuration.isPressed || isDisabled) ? 0.8 : 1)
        .animation(.linear(duration: 0.1), value: configuration.isPressed)
        .allowsHitTesting(!isLoading && !isDisabled)
    }
}

#Preview {
    Button(action: {}) {
        Text("Ahoj")
    }
    .buttonStyle(
        PrimaryButtonStyle()
    )
    .colorScheme(.light)
}
