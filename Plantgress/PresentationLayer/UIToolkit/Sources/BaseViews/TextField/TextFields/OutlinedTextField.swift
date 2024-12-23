//
//  OutlinedTextField.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 09.12.2024.
//

import SwiftUI

public struct OutlinedTextField: View {
    
    @Binding private var text: String
    @FocusState private var isFocused: Bool
    
    private let placeholder: String
    private let keyboardType: UIKeyboardType
    private let foregroundColor: Color
    private let backgroundColor: Color
    private let cornerRadius: CGFloat
    private let font: Font
    private let isDisabled: Bool
    private let errorMessage: String?
    private let hasError: Bool
    
    private let deleteTextAction: () -> Void
    
    public init(
        text: Binding<String>,
        placeholder: String,
        keyboardType: UIKeyboardType = .default,
        foregroundColor: Color = Colors.primaryText,
        backgroundColor: Color = Colors.primaryBackground,
        cornerRadius: CGFloat = Constants.CornerRadius.xLarge,
        font: Font = Fonts.bodyRegular,
        isDisabled: Bool = false,
        errorMessage: String? = nil,
        hasError: Bool = false,
        deleteTextAction: @escaping () -> Void
    ) {
        self._text = text
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.font = font
        self.isDisabled = isDisabled
        self.errorMessage = errorMessage
        self.hasError = hasError
        self.deleteTextAction = deleteTextAction
    }
    
    public var body: some View {
        VStack {
            HStack {
                TextField(placeholder, text: $text)
                    .frame(maxWidth: .infinity)
                    .keyboardType(keyboardType)
                
                if !text.isBlank {
                    Button(action: deleteTextAction) {
                        Asset.Icons.xMark.image
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: Constants.IconSize.small)
                    }
                }
            }
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
    @State var text: String = ""
    
    OutlinedTextField(
        text: $text,
        placeholder: "Placeholder",
        deleteTextAction: {
            text = ""
        }
    )
}
