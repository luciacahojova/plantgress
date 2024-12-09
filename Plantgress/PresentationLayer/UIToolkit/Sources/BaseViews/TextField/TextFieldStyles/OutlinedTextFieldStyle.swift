//
//  OutlinedTextFieldStyle.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 09.12.2024.
//

import SwiftUI

public struct OutlinedTextFieldStyle: TextFieldStyle {
    let foregroundColor: Color
    let backgroundColor: Color
    let cornerRadius: CGFloat
    let font: Font
    let isDisabled: Bool
    let hasError: Bool

    @FocusState private var isFocused: Bool
    
    public init(
        foregroundColor: Color = Colors.primaryText,
        backgroundColor: Color = Colors.primaryBackground,
        cornerRadius: CGFloat = Constants.CornerRadius.xLarge,
        font: Font = Fonts.bodyRegular,
        isDisabled: Bool = false,
        hasError: Bool = false
    ) {
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.font = font
        self.isDisabled = isDisabled
        self.hasError = hasError
    }

    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .focused($isFocused)
            .disabled(isDisabled)
            .font(font)
            .frame(height: Constants.Frame.primaryButtonHeight)
            .padding(.horizontal)
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(
                        hasError
                        ? Colors.red
                        : (isFocused ? foregroundColor : foregroundColor.opacity(0.2)),
                        lineWidth: hasError ? 2 : (isFocused ? 2 : 1)
                    )
            }
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
    }
}

#Preview {
    TextField("Placeholder", text: .constant(""))
        .textFieldStyle(OutlinedTextFieldStyle())
}
