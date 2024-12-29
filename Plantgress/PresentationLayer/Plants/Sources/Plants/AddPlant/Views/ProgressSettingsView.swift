//
//  ProgressSettingsView.swift
//  Plants
//
//  Created by Lucia Cahojova on 28.12.2024.
//

import SharedDomain
import SwiftUI
import UIToolkit

struct ProgressSettingsView: View {
    
    @Binding private var taskConfiguration: TaskConfiguration
    
    private let openPeriodSettingsAction: () -> Void

    init(
        taskConfiguration: Binding<TaskConfiguration>,
        openPeriodSettingsAction: @escaping () -> Void
    ) {
        self._taskConfiguration = taskConfiguration
        self.openPeriodSettingsAction = openPeriodSettingsAction
    }

    var body: some View {
        BaseList(title: Strings.progressTrackingTitle) {
            VStack(spacing: 0) {
                ToggleListRow(
                    isToggleOn: Binding(
                        get: { taskConfiguration.isTracked },
                        set: { isTracked in
                            taskConfiguration = .init(copy: taskConfiguration, isTracked: isTracked)
                        }
                    ),
                    title: Strings.trackProgressName,
                    rowLevel: .primary,
                    isLast: !taskConfiguration.isTracked,
                    icon: TaskType.icon(for: .progressTracking)
                )
                
                if taskConfiguration.isTracked {
                    ToggleListRow(
                        isToggleOn: Binding(
                            get: { taskConfiguration.hasNotifications },
                            set: { hasNotifications in
                                taskConfiguration = .init(copy: taskConfiguration, hasNotifications: hasNotifications)
                            }
                        ),
                        title: "Notifications", // TODO: Strings
                        rowLevel: .secondary,
                        isLast: !taskConfiguration.hasNotifications,
                        icon: Icons.alarmClock
                    )
                    
                    if taskConfiguration.hasNotifications {
                        CalendarListRow(
                            date: Binding(
                                get: { taskConfiguration.time },
                                set: { newTime in
                                    taskConfiguration = .init(copy: taskConfiguration, time: newTime)
                                }
                            ),
                            datePickerComponents: .hourAndMinute,
                            rowLever: .secondary,
                            isLast: false
                        )
                        
                        CalendarListRow(
                            date: Binding(
                                get: { taskConfiguration.startDate },
                                set: { newDate in
                                    taskConfiguration = .init(copy: taskConfiguration, startDate: newDate)
                                }
                            ),
                            datePickerComponents: .date,
                            rowLever: .secondary,
                            isLast: false
                        )
                        
                        CustomListRow(
                            title: "Repeat",
                            rowLevel: .secondary,
                            isLast: false,
                            icon: Icons.recycle,
                            content: {
                                Text(
                                    taskConfiguration.periods.count == 1
                                        ? taskConfiguration.periods.first?.interval.name ?? ""
                                        : "Custom" // TODO: String
                                )
                                .foregroundStyle(Colors.secondaryText)
                            }
                        )
                        
                        PeriodListRow(
                            periods: taskConfiguration.periods,
                            rowLevel: .secondary,
                            isLast: true,
                            action: openPeriodSettingsAction
                        )
                    }
                }
            }
            .animation(.easeInOut, value: taskConfiguration.isTracked)
            .animation(.easeInOut, value: taskConfiguration.hasNotifications)
        }
    }
}

#Preview {
    ProgressSettingsView(
        taskConfiguration: .constant(.default(for: .progressTracking)),
        openPeriodSettingsAction: {}
    )
}
