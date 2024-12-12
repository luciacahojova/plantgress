//
//  CustomListRow.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 12.12.2024.
//

import SwiftUI

public struct CustomListRow<Content: View>: View {
    
    private let title: String
    private let foregroundColor: Color
    private let rowLevel: RowLevel
    private let isLast: Bool
    
    private let icon: Image?
    
    private let content: Content

    public init(
        title: String,
        foregroundColor: Color = Colors.primaryText,
        rowLevel: RowLevel = .primary,
        isLast: Bool,
        icon: Image? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.foregroundColor = foregroundColor
        self.rowLevel = rowLevel
        self.isLast = isLast
        self.icon = icon
        self.content = content()
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: Constants.Spacing.xMedium) {
                if let icon {
                    icon
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: Constants.IconSize.small)
                }
                
                Text(title)
                
                Spacer()
                
                content
            }
            .padding(.leading, rowLevel == .primary ? Constants.Spacing.mediumLarge : Constants.Spacing.xxLarge)
            .padding(.trailing, Constants.Spacing.xMedium)
            .frame(height: Constants.Frame.primaryButtonHeight)
            
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
    CustomListRow(
        title: "Repeat",
        rowLevel: .secondary,
        isLast: true,
        icon: Asset.Icons.recycle.image
    ) {
        Menu {
            Button("Save") {}
        } label: {
            HStack(spacing: Constants.Spacing.small) {
                Text("Custom")
                Asset.Icons.chevronSelectorVertical.image
            }
            .foregroundStyle(Colors.secondaryText)
        }
    }
}
