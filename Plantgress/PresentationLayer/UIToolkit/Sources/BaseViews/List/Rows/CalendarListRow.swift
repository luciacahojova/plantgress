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
    
    public var body: some View { // TODO: Custom color
        VStack(spacing: 0) {
            HStack(spacing: Constants.Spacing.xMedium) {
                icon
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Constants.IconSize.small)
                
                Text(title)
                
                Spacer()
                
                DatePicker(
                    "",
                    selection: $date,
                    displayedComponents: [datePickerComponents]
                )
                .labelsHidden()
                .tint(Colors.primaryText)
                .datePickerStyle(.automatic)
                .colorMultiply(Colors.primaryText)
                .background(Color.black.opacity(0.2))
                .cornerRadius(Constants.CornerRadius.small)

            }
            .padding(
                .leading,
                rowLever == .primary ? Constants.Spacing.mediumLarge : Constants.Spacing.xxLarge
            )
            .padding(.trailing, Constants.Spacing.xMedium)
            .frame(height: Constants.Frame.primaryButtonHeight)
            
            if !isLast {
                Divider()
                    .padding(.leading, rowLever == .primary ? 0 : Constants.Spacing.xxLarge)
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
