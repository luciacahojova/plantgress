//
//  PickerStyle.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 13.12.2024.
//

import SwiftUI

struct PickerStyle: ViewModifier {
    private var isSelected: Bool
    
    init(isSelected: Bool) {
        self.isSelected = isSelected
    }
    
    func body(content: Content) -> some View {
        content
            .font(
                isSelected
                ? Fonts.bodySemibold
                : Fonts.bodyRegular
            )
            .foregroundStyle(Colors.primaryText)
    }
}
