//
//  ToggleListRow.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 12.12.2024.
//

import SwiftUI

struct ToggleListRow: View {
    
    @Binding private var isToggleOn: Bool
    
    private let title: String
    private let rowLevel: RowLevel
    private let isLast: Bool
    
    private let icon: Image?
    
    init(
        isToggleOn: Binding<Bool>,
        title: String,
        rowLevel: RowLevel,
        isLast: Bool,
        icon: Image? = nil
    ) {
        self._isToggleOn = isToggleOn
        self.title = title
        self.rowLevel = rowLevel
        self.isLast = isLast
        self.icon = icon
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
                
                Toggle(isOn: $isToggleOn) {}
                    .tint(Colors.primaryText)
                    .toggleStyle(
                        BaseToggleStyle( // TODO: Custom color
                            onColor: Colors.primaryText,
                            offColor: .gray
                        )
                    )
            }
            .padding(
                .leading,
                rowLevel == .primary ? Constants.Spacing.mediumLarge : Constants.Spacing.xxLarge
            )
            .padding(.trailing, Constants.Spacing.xMedium)
            .frame(height: Constants.Frame.primaryButtonHeight)
            
            if !isLast {
                Divider()
                    .padding(.leading, rowLevel == .primary ? 0 : Constants.Spacing.xxLarge)
            }
        }
        .font(Fonts.bodyRegular)
        .foregroundStyle(Colors.primaryText)
    }
}

#Preview {
    ToggleListRow(
        isToggleOn: .constant(false),
        title: "Watering",
        rowLevel: .primary,
        isLast: false,
        icon: Asset.Icons.drop.image
    )
    .background(Colors.secondaryBackground)
    .colorScheme(.dark)
    
    ToggleListRow(
        isToggleOn: .constant(true),
        title: "Watering",
        rowLevel: .primary,
        isLast: false,
        icon: Asset.Icons.drop.image
    )
    .background(Colors.secondaryBackground)
    .colorScheme(.dark)
    
    ToggleListRow(
        isToggleOn: .constant(false),
        title: "Watering",
        rowLevel: .primary,
        isLast: false,
        icon: Asset.Icons.drop.image
    )
    .background(Colors.secondaryBackground)
    
    ToggleListRow(
        isToggleOn: .constant(true),
        title: "Watering",
        rowLevel: .primary,
        isLast: false,
        icon: Asset.Icons.drop.image
    )
    .background(Colors.secondaryBackground)
}
