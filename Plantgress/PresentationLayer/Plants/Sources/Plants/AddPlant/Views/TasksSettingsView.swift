//
//  TasksSettingsView.swift
//  Plants
//
//  Created by Lucia Cahojova on 28.12.2024.
//

import SharedDomain
import SwiftUI
import UIToolkit

struct TasksSettingsView: View {
    @Binding var tasks: [TaskType: TaskConfiguration]

    init(
        tasks: Binding<[TaskType: TaskConfiguration]>
    ) {
        self._tasks = tasks
    }

    var body: some View {
        BaseList(title: "Task Settings") { // TODO: Strings
            ForEach(TaskType.allCases.filter { $0 != .progressTracking }, id: \.self) { taskType in
                if let taskConfiguration = tasks[taskType] {
                    taskSection(taskType: taskType, taskConfiguration: taskConfiguration)
                }
            }
        }
    }

    @ViewBuilder
    private func taskSection(taskType: TaskType, taskConfiguration: TaskConfiguration) -> some View {
        VStack(spacing: 0) {
            ToggleListRow(
                isToggleOn: Binding(
                    get: { taskConfiguration.isTracked },
                    set: { isTracked in
                        tasks[taskType] = .init(copy: taskConfiguration, isTracked: isTracked)
                    }
                ),
                title: TaskType.title(for: taskType),
                rowLevel: .primary,
                isLast: !taskConfiguration.isTracked && taskType == .propagation,
                icon: TaskType.icon(for: taskType)
            )
            
            if taskConfiguration.isTracked {
                ToggleListRow(
                    isToggleOn: Binding(
                        get: { taskConfiguration.hasNotifications },
                        set: { hasNotifications in
                            tasks[taskType] = .init(copy: taskConfiguration, hasNotifications: hasNotifications)
                        }
                    ),
                    title: "Notifications", // TODO: Strings
                    rowLevel: .secondary,
                    isLast: !taskConfiguration.hasNotifications && taskType == .propagation,
                    icon: Icons.alarmClock
                )
                
                if taskConfiguration.hasNotifications {
                    CalendarListRow(
                        date: Binding(
                            get: { taskConfiguration.startDate },
                            set: { newDate in
                                tasks[taskType] = .init(copy: taskConfiguration, startDate: newDate)
                            }
                        ),
                        datePickerComponents: .date,
                        rowLever: .secondary,
                        isLast: false
                    )
                    
                    ButtonListRow(
                        title: "Repeat", // TODO: Strings
                        rowLevel: .secondary,
                        isLast: taskType == .propagation,
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

#Preview {
    TasksSettingsView(
        tasks: .constant(TaskType.allCases.reduce(into: [:]) { result, taskType in
            result[taskType] = .default(for: taskType)
        })
    )
}
