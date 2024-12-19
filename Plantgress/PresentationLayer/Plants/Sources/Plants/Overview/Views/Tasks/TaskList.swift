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
    
    private let upcomingTasks: [TaskItem]
    private let completedTasks: [TaskItem]
    
    private let editTaskAction: (UUID) -> Void
    private let deleteTaskAction: (UUID) -> Void
    private let completeTaskAction: (UUID) -> Void
    
    private let isLoading: Bool
    
    init(
        upcomingTasks: [TaskItem],
        completedTasks: [TaskItem],
        editTaskAction: @escaping (UUID) -> Void,
        deleteTaskAction: @escaping (UUID) -> Void,
        completeTaskAction: @escaping (UUID) -> Void
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
                    message: "You have no tracked tasks.", // TODO: String
                    fixedTopPadding: 100
                )
            } else {
                VStack(alignment: .leading, spacing: Constants.Spacing.small) {
                    if !upcomingTasks.isEmpty {
                        Text("Upcoming Tasks") // TODO: String
                            .textCase(.uppercase)
                            .padding(.leading, Constants.Spacing.medium)
                            .font(Fonts.calloutSemibold)
                            .foregroundStyle(Colors.secondaryText)
                        
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
                    
                    if !completedTasks.isEmpty {
                        Text("Completed Tasks") // TODO: String
                            .textCase(.uppercase)
                            .padding(.leading, Constants.Spacing.medium)
                            .font(Fonts.calloutSemibold)
                            .foregroundStyle(Colors.secondaryText)
                        
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
                }
            }
        }
        .skeleton(isLoading)
    }
}

#Preview {
    Resolver.registerUseCasesForPreviews()
    
    return TaskList(
        upcomingTasks: .mock,
        completedTasks: [],
        editTaskAction: { _ in },
        deleteTaskAction: { _ in },
        completeTaskAction: { _ in }
    )
    .preferredColorScheme(.dark)
}
