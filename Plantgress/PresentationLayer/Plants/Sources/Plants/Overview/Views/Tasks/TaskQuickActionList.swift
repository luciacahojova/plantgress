//
//  TaskQuickActionList.swift
//  Plants
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import SharedDomain
import SwiftUI
import UIToolkit

struct TaskQuickActionList: View {
    
    private let taskConfigurations: [TaskConfiguration]
    private let action: (TaskType) -> Void
    
    init(
        taskConfigurations: [TaskConfiguration],
        action: @escaping (TaskType) -> Void
    ) {
        self.taskConfigurations = taskConfigurations
        self.action = action
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: Constants.Spacing.xMedium) {
                ForEach(taskConfigurations, id: \.taskType.id) { configuration in
                    if configuration.isTracked {
                        Button {
                            action(configuration.taskType)
                        } label: {
                            VStack(spacing: Constants.Spacing.medium) {
                                TaskType.icon(for: configuration.taskType)
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: Constants.IconSize.small)
                                    .padding(Constants.Spacing.medium)
                                    .clipShape(Circle())
                                    .background {
                                        Circle()
                                            .fill(TaskType.color(for: configuration.taskType))
                                    }
                                
                                Text(TaskType.name(for: configuration.taskType))
                                    .font(Fonts.calloutMedium)
                            }
                            .foregroundStyle(Colors.primaryText)
                            .frame(minWidth: 55)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    TaskQuickActionList(
        taskConfigurations: .mock,
        action: { _ in }
    )
}
