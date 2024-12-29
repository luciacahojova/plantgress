//
//  WeeklyPeriodRow.swift
//  Plants
//
//  Created by Lucia Cahojova on 29.12.2024.
//

import SharedDomain
import SwiftUI
import UIToolkit

struct WeeklyPeriodRow: View {
    
    @Binding private var taskInterval: TaskInterval
    
    init(taskInterval: Binding<TaskInterval>) {
        self._taskInterval = taskInterval
    }
    
    var body: some View {
        VStack(spacing: 0) {
            CustomListRow(
                title: "Every", // TODO: Strings
                isLast: false
            ) {
                if case let .weekly(interval, _) = taskInterval {
                    Text("\(interval) weeks") // TODO: Strings
                } else {
                    Text("1 week")
                }
            }
            
            Picker(
                "",
                selection: Binding<Int>(
                    get: {
                        if case let .weekly(interval, _) = taskInterval {
                            return interval
                        }
                        return 1
                    },
                    set: { newInterval in
                        if case let .weekly(_, weekday) = taskInterval {
                            taskInterval = .weekly(interval: newInterval, weekday: weekday)
                        }
                    }
                )
            ) {
                ForEach(1...12, id: \.self) { number in
                    Text("\(number) weeks") // TODO: Strings
                        .tag(number)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(maxWidth: .infinity, maxHeight: 100)
            
            Divider()
            
            CustomListRow(
                title: "On", // TODO: Strings
                isLast: false
            ) {
                if case let .weekly(_, weekday) = taskInterval {
                    Text(Calendar.current.weekdaySymbols[weekday - 1]) // TODO: Strings
                } else {
                    Text("Monday")
                }
            }
            
            Picker(
                "",
                selection: Binding<Int>(
                    get: {
                        if case let .weekly(_, weekday) = taskInterval {
                            return weekday
                        }
                        return 1
                    },
                    set: { newWeekday in
                        if case let .weekly(interval, _) = taskInterval {
                            taskInterval = .weekly(interval: interval, weekday: newWeekday)
                        }
                    }
                )
            ) {
                ForEach(1...7, id: \.self) { day in
                    Text(Calendar.current.weekdaySymbols[day - 1])
                        .tag(day)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(maxWidth: .infinity, maxHeight: 100)
        }
    }
}

#Preview {
    WeeklyPeriodRow(
        taskInterval: .constant(.weekly(interval: 1, weekday: 1))
    )
}
