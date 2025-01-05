//
//  TaskList.swift
//  Plants
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import Resolver
import SharedDomain
import SwiftUI
import UIToolkit

struct TaskList: View {
    
    private let upcomingTasks: [PlantTask]
    private let completedTasks: [PlantTask]
    
    private let editTaskAction: (PlantTask) -> Void
    private let deleteTaskAction: (PlantTask) -> Void
    private let completeTaskAction: (PlantTask) -> Void
    
    private let isLoading: Bool
    
    init(
        upcomingTasks: [PlantTask],
        completedTasks: [PlantTask],
        editTaskAction: @escaping (PlantTask) -> Void,
        deleteTaskAction: @escaping (PlantTask) -> Void,
        completeTaskAction: @escaping (PlantTask) -> Void
    ) {
        self.upcomingTasks = upcomingTasks
        self.completedTasks = completedTasks
        self.editTaskAction = editTaskAction
        self.deleteTaskAction = deleteTaskAction
        self.completeTaskAction = completeTaskAction
        self.isLoading = false
    }
    
    private init() {
        self.upcomingTasks = .mock
        self.completedTasks = []
        self.editTaskAction = { _ in }
        self.deleteTaskAction = { _ in }
        self.completeTaskAction = { _ in }
        self.isLoading = true
    }
    
    static var skeleton: TaskList {
        self.init()
    }
    
    var body: some View {
        LazyVStack(spacing: Constants.Spacing.large) {
            if completedTasks.isEmpty, upcomingTasks.isEmpty {
                BaseEmptyContentView(
                    message: Strings.noTrackedTasksMessage,
                    fixedTopPadding: 100
                )
            } else {
                if !upcomingTasks.isEmpty {
                    VStack(alignment: .leading, spacing: Constants.Spacing.small) {
                        sectionTitle(Strings.upcomingTasksTitle)
                        
                        VStack(spacing: Constants.Spacing.medium) {
                            ForEach(upcomingTasks, id: \.id) { task in
                                TaskRow(
                                    task: task,
                                    editTaskAction: editTaskAction,
                                    deleteTaskAction: deleteTaskAction,
                                    completeTaskAction: completeTaskAction
                                )
                            }
                        }
                    }
                    .animation(.easeIn(duration: 0.25), value: upcomingTasks)
                }
                
                if !completedTasks.isEmpty {
                    VStack(alignment: .leading, spacing: Constants.Spacing.small) {
                        sectionTitle(Strings.completedTasksTitle) 
                        
                        VStack(spacing: Constants.Spacing.medium) {
                            ForEach(completedTasks, id: \.id) { task in
                                TaskRow(
                                    task: task,
                                    editTaskAction: editTaskAction,
                                    deleteTaskAction: deleteTaskAction,
                                    completeTaskAction: completeTaskAction
                                )
                            }
                        }
                    }
                    .animation(.easeIn(duration: 0.25), value: completedTasks)
                }
            }
        }
        .skeleton(isLoading)
    }
    
    public func sectionTitle(_ title: String) -> some View {
        Text(title)
            .textCase(.uppercase)
            .padding(.leading, Constants.Spacing.medium)
            .font(Fonts.calloutSemibold)
            .foregroundStyle(Colors.secondaryText)
    }
}

#Preview {
    Resolver.registerUseCaseMocks()
    
    return TaskList(
        upcomingTasks: .mock,
        completedTasks: [],
        editTaskAction: { _ in },
        deleteTaskAction: { _ in },
        completeTaskAction: { _ in }
    )
    .preferredColorScheme(.dark)
}
