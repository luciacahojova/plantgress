//
//  YearlyPeriodRow.swift
//  Plants
//
//  Created by Lucia Cahojova on 29.12.2024.
//

import SharedDomain
import SwiftUI
import UIToolkit

struct YearlyPeriodRow: View {
    
    @Binding private var date: Date
    
    private let rowLever: RowLevel
    private let isLast: Bool
    
    public init(
        date: Binding<Date>,
        rowLever: RowLevel,
        isLast: Bool
    ) {
        self._date = date
        self.rowLever = rowLever
        self.isLast = isLast
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: Constants.List.spacing) {
                Text(Strings.repeatOnLabel)
                
                Spacer()
                
                BaseDatePicker(
                    date: $date,
                    datePickerComponents: .date,
                    dateFormatter: Formatter.Date.ddMM
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
    YearlyPeriodRow(
        date: .constant(Date()),
        rowLever: .primary,
        isLast: true
    )
}
