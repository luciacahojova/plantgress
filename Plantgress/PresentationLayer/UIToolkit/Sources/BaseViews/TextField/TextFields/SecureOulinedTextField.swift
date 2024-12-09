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
    private let error: Error?
    private let prefix: String?
    
    public init(
        text: Binding<String>,
        placeholder: String,
        keyboardType: UIKeyboardType = .default,
        foregroundColor: Color = Colors.primaryText,
        error: Error? = nil,
        prefix: String? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.foregroundColor = foregroundColor
        self.error = error
        self.prefix = prefix
    }
    
    public var body: some View {
        VStack {
            SecureField(placeholder, text: $text)
                .textFieldStyle(
                    OutlinedTextFieldStyle(
                        foregroundColor: foregroundColor,
                        hasError: error != nil
                    )
                )
                .frame(maxWidth: .infinity)
                .keyboardType(keyboardType)
            
            if let error {
                Text(error.localizedDescription)
                    .font(Fonts.captionMedium)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundColor(Colors.red)
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
