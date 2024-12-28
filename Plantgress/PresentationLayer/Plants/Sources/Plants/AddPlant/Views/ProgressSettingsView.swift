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
    @Binding var taskConfiguration: TaskConfiguration

    init(
        taskConfiguration: Binding<TaskConfiguration>
    ) {
        self._taskConfiguration = taskConfiguration
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
                                get: { taskConfiguration.startDate },
                                set: { newDate in
                                    taskConfiguration = .init(copy: taskConfiguration, startDate: newDate)
                                }
                            ),
                            datePickerComponents: .date,
                            rowLever: .secondary,
                            isLast: false
                        )
                        
                        ButtonListRow(
                            title: "Repeat", // TODO: Strings
                            rowLevel: .secondary,
                            isLast: true,
                            text: taskConfiguration.periods.first?.name ?? "None", // TODO: ??
                            leadingIcon: Icons.refresh,
                            trailingIcon: Icons.chevronSelectorVertical,
                            action: {
                                // TODO: Implementation
                            }
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
        taskConfiguration: .constant(.default(for: .progressTracking))
    )
}
