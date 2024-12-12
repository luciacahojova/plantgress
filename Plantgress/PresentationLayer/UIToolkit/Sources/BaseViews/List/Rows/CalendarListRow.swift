//
//  CalendarListRow.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 12.12.2024.
//

import SwiftUI

public struct CalendarListRow: View {
    
    @Binding private var date: Date
    
    private let datePickerComponents: DatePickerComponents
    private let rowLever: RowLevel
    private let isLast: Bool
    
    private let icon: Image
    private let title: String
    
    init(
        date: Binding<Date>,
        datePickerComponents: DatePickerComponents,
        rowLever: RowLevel,
        isLast: Bool
    ) {
        self._date = date
        self.datePickerComponents = datePickerComponents
        self.rowLever = rowLever
        self.isLast = isLast
        
        let isDate = datePickerComponents == .date
        self.icon = isDate ? Asset.Icons.calendar.image : Asset.Icons.clock.image
        self.title = isDate ? "Start" : "Time" // TODO: Strings
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: Constants.List.spacing) {
                icon
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Constants.IconSize.small)
                
                Text(title)
                
                Spacer()
                
                BaseDatePicker(
                    date: $date,
                    datePickerComponents: datePickerComponents
                )
            }
            .padding(.trailing, Constants.List.trailingPadding)
            .padding(
                .leading,
                rowLever == .primary ? Constants.List.leadingPaddingPrimary : Constants.List.leadingPaddingSecondary
            )
            .frame(height: Constants.Frame.primaryButtonHeight)
            
            if !isLast {
                Divider()
                    .padding(.leading, rowLever == .primary ? 0 : Constants.List.leadingPaddingSecondary)
            }
        }
        .font(Fonts.bodyRegular)
        .foregroundStyle(Colors.primaryText)
    }
}

#Preview {
    CalendarListRow(
        date: .constant(.now),
        datePickerComponents: .hourAndMinute,
        rowLever: .primary,
        isLast: false
    )
    .background(Colors.secondaryBackground)
    
    CalendarListRow(
        date: .constant(.now),
        datePickerComponents: .date,
        rowLever: .primary,
        isLast: false
    )
    .background(Colors.secondaryBackground)
    .colorScheme(.dark)
}


