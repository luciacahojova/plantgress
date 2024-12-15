//
//  MenuLabelButton.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 15.12.2024.
//

import SwiftUI

public struct MenuLabelButton: View {
    
    private let text: String
    private let role: ButtonRole?
    private let icon: Image
    private let action: () -> Void
    
    public init(
        text: String,
        role: ButtonRole? = nil,
        icon: Image,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.role = role
        self.icon = icon
        self.action = action
    }
    
    public var body: some View {
        Button(role: role) {
            action()
        } label: {
            Label {
                Text(text)
            } icon: {
                icon
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Constants.IconSize.small)
            }
        }
    }
}


#Preview {
    MenuLabelButton(
        text: Strings.deleteButton,
        icon: Icons.trash,
        action: {}
    )
}
