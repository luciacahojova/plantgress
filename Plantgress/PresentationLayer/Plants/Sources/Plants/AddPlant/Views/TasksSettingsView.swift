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
    
    @Binding private var tasks: [TaskType: TaskConfiguration]
    
    private let openPeriodSettingsAction: (TaskType) -> Void

    init(
        tasks: Binding<[TaskType: TaskConfiguration]>,
        openPeriodSettingsAction: @escaping (TaskType) -> Void
    ) {
        self._tasks = tasks
        self.openPeriodSettingsAction = openPeriodSettingsAction
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
                            get: { taskConfiguration.time },
                            set: { newTime in
                                tasks[taskType] = .init(copy: taskConfiguration, time: newTime)
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
                                tasks[taskType] = .init(copy: taskConfiguration, startDate: newDate)
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
                        isLast: taskType == .propagation,
                        action: {
                            openPeriodSettingsAction(taskType)
                        }
                    )
                }
            }
        }
        .animation(.easeInOut, value: taskConfiguration.isTracked)
        .animation(.easeInOut, value: taskConfiguration.hasNotifications)
    }
    
    private func generatePeriodDescription(_ periods: [TaskPeriod]) -> String {
        let maxVisiblePeriods = 3
        let descriptions = periods.map { $0.name }
        let visibleDescriptions = descriptions.prefix(maxVisiblePeriods)
        let hiddenCount = descriptions.count - visibleDescriptions.count

        if hiddenCount > 0 {
            return visibleDescriptions.joined(separator: ", ") + ", ..."
        } else {
            return visibleDescriptions.joined(separator: ", ")
        }
    }
}

#Preview {
    TasksSettingsView(
        tasks: .constant(TaskType.allCases.reduce(into: [:]) { result, taskType in
            result[taskType] = .default(for: taskType)
        }),
        openPeriodSettingsAction: { _ in }
    )
}
