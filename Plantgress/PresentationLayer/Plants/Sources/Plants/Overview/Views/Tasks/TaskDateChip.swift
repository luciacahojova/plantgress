//
//  TaskDateChip.swift
//  Plants
//
//  Created by Lucia Cahojova on 19.12.2024.
//

import SwiftUI
import UIToolkit

struct TaskDateChip: View {
    
    private let text: String
    
    init(text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text) 
            .font(Fonts.subheadlineMedium)
            .padding(.horizontal, Constants.Spacing.xMedium)
            .padding(.vertical, Constants.Spacing.xSmall)
            .background(Colors.secondaryText)
            .foregroundStyle(Colors.white)
            .cornerRadius(Constants.CornerRadius.xxxLarge)
    }
}

#Preview {
    TaskDateChip(
        text: "Text"
    )
}
