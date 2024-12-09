//
//  SecureOulinedTextField.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 09.12.2024.
//

import SwiftUI

public struct SecureOulinedTextField: View {
    @Binding private var text: String
    private let placeholder: String
    private let keyboardType: UIKeyboardType
    private let foregroundColor: Color
    private let errorMessage: String?
    private let hasError: Bool
    
    public init(
        text: Binding<String>,
        placeholder: String,
        keyboardType: UIKeyboardType = .default,
        foregroundColor: Color = Colors.primaryText,
        errorMessage: String? = nil,
        hasError: Bool = false
    ) {
        self._text = text
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.foregroundColor = foregroundColor
        self.errorMessage = errorMessage
        self.hasError = hasError
    }
    
    public var body: some View {
        VStack {
            SecureField(placeholder, text: $text)
                .textFieldStyle(
                    OutlinedTextFieldStyle(
                        foregroundColor: foregroundColor,
                        hasError: hasError || errorMessage != nil
                    )
                )
                .frame(maxWidth: .infinity)
                .keyboardType(keyboardType)
            
            if let errorMessage {
                Text(errorMessage)
                    .font(Fonts.captionMedium)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(Colors.red)
                    .padding(.leading)
            }
        }
        .foregroundStyle(foregroundColor)
    }
}
#Preview {
    SecureOulinedTextField(
        text: .constant(""),
        placeholder: "Placeholder"
    )
}
