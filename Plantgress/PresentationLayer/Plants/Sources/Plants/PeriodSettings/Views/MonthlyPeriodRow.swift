//
//  MonthlyPeriodRow.swift
//  Plants
//
//  Created by Lucia Cahojova on 29.12.2024.
//

import SharedDomain
import SwiftUI
import UIToolkit

struct MonthlyPeriodRow: View {
    
    @Binding private var taskInterval: TaskInterval

    init(
        taskInterval: Binding<TaskInterval>
    ) {
        self._taskInterval = taskInterval
    }

    var body: some View {
        VStack(spacing: 0) {
            CustomListRow(
                title: Strings.repeatEveryLabel,
                isLast: false
            ) {
                if case let .monthly(interval, _) = taskInterval {
                    if interval == 1 {
                        Text(Strings.plantCreationEveryDaysFormatOne(interval))
                    } else if interval < 5 {
                        Text(Strings.plantCreationEveryDaysFormatFew(interval))
                    } else {
                        Text(Strings.plantCreationEveryDaysFormatMany(interval))
                    }
                }
            }
            
            Picker(
                "",
                selection: Binding<Int>(
                    get: {
                        if case let .monthly(interval, _) = taskInterval {
                            return interval
                        }
                        return 1
                    },
                    set: { newInterval in
                        if case let .monthly(_, months) = taskInterval {
                            taskInterval = .monthly(interval: newInterval, months: months)
                        }
                    }
                )
            ) {
                ForEach(1...31, id: \.self) { number in
                    Text("\(number)")
                        .tag(number)
                }
            }
            .pickerStyle(WheelPickerStyle())

            Divider()

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 4), spacing: 0) {
                ForEach(1...12, id: \.self) { month in
                    Button {
                        if case let .monthly(interval, months) = taskInterval {
                            var updatedMonths = months
                            if updatedMonths.contains(month), updatedMonths.count > 1 {
                                updatedMonths.removeAll { $0 == month }
                            } else if !updatedMonths.contains(month) {
                                updatedMonths.append(month)
                            }
                            taskInterval = .monthly(interval: interval, months: updatedMonths)
                        }
                    } label: {
                        Text(monthName(from: month))
                            .padding(.vertical, Constants.Spacing.medium)
                            .padding(.horizontal, Constants.Spacing.xMedium)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(
                                isMonthSelected(for: month) ? Colors.green : Colors.secondaryBackground
                            )
                            .foregroundStyle(
                                isMonthSelected(for: month) ? Colors.primaryText : Colors.secondaryText
                            )
                    }
                }
            }
        }
    }
    
    private func isMonthSelected(for month: Int) -> Bool {
        guard case let .monthly(_, selectedMonths) = taskInterval else {
            return false
        }
        return selectedMonths.contains(month)
    }
    
    func monthName(from month: Int) -> String {
        guard month >= 1 && month <= 12 else { return "" }
        let formatter = DateFormatter()
        formatter.locale = .current
        return formatter.shortMonthSymbols[month - 1]
    }
}

#Preview {
    MonthlyPeriodRow(
        taskInterval: .constant(.monthly(interval: 5, months: []))
    )
}
