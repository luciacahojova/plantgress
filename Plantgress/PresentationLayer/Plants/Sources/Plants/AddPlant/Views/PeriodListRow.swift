//
//  PeriodListRow.swift
//  Plants
//
//  Created by Lucia Cahojova on 29.12.2024.
//

import SharedDomain
import SwiftUI
import UIToolkit

struct PeriodListRow: View {
    
    private let periods: [TaskPeriod]
    private let rowLevel: RowLevel
    private let isLast: Bool
    private let action: () -> Void
    
    init(
        periods: [TaskPeriod],
        rowLevel: RowLevel,
        isLast: Bool,
        action: @escaping () -> Void
    ) {
        self.periods = periods
        self.rowLevel = rowLevel
        self.isLast = isLast
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: action) {
                HStack(spacing: Constants.List.spacing) {
                    VStack(alignment: .leading, spacing: Constants.Spacing.small) {
                        ForEach(periods, id: \.id) { period in
                            Text(period.interval.description)
                                .font(Fonts.captionMedium)
                                .foregroundStyle(Colors.primaryText)
                        }
                    }
                    .padding(.vertical, Constants.Spacing.small)
                    
                    Spacer()
                    
                    Icons.chevronRight
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: Constants.IconSize.small)
                }
                .padding(.trailing, Constants.List.trailingPadding)
                .padding(
                    .leading,
                    rowLevel == .primary ? Constants.List.leadingPaddingPrimary : Constants.List.leadingPaddingSecondary
                )
                .frame(minHeight: Constants.Frame.primaryButtonHeight)
            }
            
            if !isLast {
                Divider()
                    .padding(.leading, rowLevel == .primary ? 0 : Constants.List.leadingPaddingSecondary)
            }
        }
        .font(Fonts.bodyRegular)
        .foregroundStyle(Colors.primaryText)
    }
}

#Preview {
    PeriodListRow(
        periods: [],
        rowLevel: .secondary,
        isLast: false,
        action: {}
    )
}
