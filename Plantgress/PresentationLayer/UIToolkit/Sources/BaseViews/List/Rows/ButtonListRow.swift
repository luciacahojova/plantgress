//
//  ButtonListRow.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 12.12.2024.
//

import SwiftUI

public struct ButtonListRow: View {
    
    private let title: String
    private let rowLevel: RowLevel
    private let isLast: Bool
    private let foregroundColor: Color
    
    private let text: String?
    private let leadingIcon: Image?
    private let trailingIcon: Image?
    
    private let action: () -> Void
    
    public init(
        title: String,
        foregroundColor: Color = Colors.primaryText,
        rowLevel: RowLevel = .primary,
        isLast: Bool,
        text: String? = nil,
        leadingIcon: Image? = nil,
        trailingIcon: Image? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.foregroundColor = foregroundColor
        self.rowLevel = rowLevel
        self.isLast = isLast
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.text = text
        self.action = action
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            Button(action: action) {
                HStack(spacing: Constants.Spacing.xMedium) {
                    if let leadingIcon {
                        leadingIcon
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: Constants.IconSize.small)
                    }
                    
                    Text(title)
                    
                    Spacer()
                    
                    HStack(spacing: Constants.Spacing.small) {
                        if let text {
                            Text(text)
                        }
                        
                        if let trailingIcon {
                            trailingIcon
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: Constants.IconSize.small)
                        }
                    }
                    .foregroundStyle(Colors.secondaryText)
                }
                .padding(.leading, rowLevel == .primary ? Constants.Spacing.mediumLarge : Constants.Spacing.xxLarge)
                .padding(.trailing, Constants.Spacing.xMedium)
                .frame(height: Constants.Frame.primaryButtonHeight)
            }
            
            if !isLast {
                Divider()
                    .padding(.leading, rowLevel == .primary ? 0 : Constants.Spacing.xxLarge)
            }
        }
        .font(Fonts.bodyRegular)
        .foregroundStyle(foregroundColor)
    }
}

#Preview {
    ButtonListRow(
        title: "Living Room",
        rowLevel: .secondary,
        isLast: true,
        trailingIcon: Asset.Icons.chevronSelectorVertical.image,
        action: {}
    )
}
