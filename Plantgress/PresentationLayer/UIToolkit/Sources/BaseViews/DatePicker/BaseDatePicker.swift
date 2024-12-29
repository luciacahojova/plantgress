//
//  BaseDatePicker.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 12.12.2024.
//

import SwiftUI

public struct BaseDatePicker: View {
    
    @Binding private var date: Date
    
    private let datePickerComponents: DatePickerComponents
    private let foregroundColor: Color
    private let backgroundColor: Color
    private let tintColor: Color
    private let dateFormatter: DateFormatter
    
    public init(
        date: Binding<Date>,
        datePickerComponents: DatePickerComponents,
        foregroundColor: Color = Colors.primaryText,
        backgroundColor: Color = Colors.gray,
        tintColor: Color = Colors.green,
        dateFormatter: DateFormatter = Formatter.Date.MMMdyyyy
    ) {
        self._date = date
        self.datePickerComponents = datePickerComponents
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
        self.dateFormatter = dateFormatter
    }
    
    public var body: some View {
        ZStack {
            DatePicker(
                "",
                selection: $date,
                displayedComponents: [datePickerComponents]
            )
            .labelsHidden()
            .tint(tintColor)
            .datePickerStyle(.automatic)
            
            VStack {
                if datePickerComponents.contains(.date) {
                    Text(date.toString(formatter: dateFormatter))
                } else if datePickerComponents.contains(.hourAndMinute) {
                    Text(date.toString(formatter: Formatter.Date.HHmm))
                }
            }
            .foregroundColor(foregroundColor)
            .padding(Constants.Spacing.medium)
            .padding(.horizontal, 5)
            .background(backgroundColor)
            .cornerRadius(Constants.CornerRadius.small)
            .allowsHitTesting(false)
        }
    }
}

#Preview {
    BaseDatePicker(
        date: .constant(.now),
        datePickerComponents: .date
    )
}
