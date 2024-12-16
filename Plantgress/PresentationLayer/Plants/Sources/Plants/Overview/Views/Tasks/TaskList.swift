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
    
    private let tasks: [PlantTask]
    
    private let editTaskAction: (UUID) -> Void
    private let deleteTaskAction: (UUID) -> Void
    private let completeTaskAction: (UUID) -> Void
    
    private let isLoading: Bool
    
    init(
        tasks: [PlantTask],
        editTaskAction: @escaping (UUID) -> Void,
        deleteTaskAction: @escaping (UUID) -> Void,
        completeTaskAction: @escaping (UUID) -> Void
    ) {
        self.tasks = tasks
        self.editTaskAction = editTaskAction
        self.deleteTaskAction = deleteTaskAction
        self.completeTaskAction = completeTaskAction
        self.isLoading = false
    }
    
    private init() {
        self.tasks = .mock
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
            ForEach(tasks, id: \.id) { task in
                TaskRow(
                    task: task,
                    editTaskAction: editTaskAction,
                    deleteTaskAction: deleteTaskAction,
                    completeTaskAction: completeTaskAction
                )
            }
        }
        .skeleton(isLoading)
    }
}

#Preview {
    Resolver.registerUseCasesForPreviews()
    
    return TaskList(
        tasks: .mock,
        editTaskAction: { _ in },
        deleteTaskAction: { _ in },
        completeTaskAction: { _ in }
    )
    .preferredColorScheme(.dark)
}
