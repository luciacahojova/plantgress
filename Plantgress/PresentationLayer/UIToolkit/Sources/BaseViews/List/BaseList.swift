//
//  BaseList.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 12.12.2024.
//

import SwiftUI

public struct BaseList<Content: View>: View {
    
    private let backgoundColor: Color
    private let title: String?
    private let content: Content
    
    public init(
        backgoundColor: Color = Colors.secondaryBackground,
        title: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.backgoundColor = backgoundColor
        self.title = title
        self.content = content()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.small) {
            if let title {
                Text(title)
                    .textCase(.uppercase)
                    .padding(.leading, Constants.Spacing.medium)
                    .font(Fonts.calloutSemibold)
                    .foregroundStyle(Colors.secondaryText)
            }
            
            VStack(spacing: 0) {
                content
            }
            .background(backgoundColor)
            .cornerRadius(Constants.List.cornerRadius)
        }
    }
}

#Preview {
    BaseList(title: "Title") {
        ToggleListRow(
            isToggleOn: .constant(true),
            title: "Watering",
            rowLevel: .primary,
            isLast: false,
            icon: Asset.Icons.drop.image
        )
        
        CalendarListRow(
            date: .constant(.now),
            datePickerComponents: .hourAndMinute,
            rowLever: .secondary,
            isLast: false
        )
        
        CalendarListRow(
            date: .constant(.now),
            datePickerComponents: .date,
            rowLever: .secondary,
            isLast: true
        )
    }
    .padding()
    .background(Colors.primaryBackground)
    .colorScheme(.light)
}
