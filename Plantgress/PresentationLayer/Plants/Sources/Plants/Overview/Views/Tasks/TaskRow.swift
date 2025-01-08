//
//  TaskRow.swift
//  Plants
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import Resolver
import SharedDomain
import SwiftUI
import UIToolkit

struct TaskRow: View {
    
    private let task: PlantTask
    
    private let editTaskAction: (PlantTask) -> Void
    private let deleteTaskAction: (PlantTask) -> Void
    private let completeTaskAction: (PlantTask) -> Void
    
    init(
        task: PlantTask,
        editTaskAction: @escaping (PlantTask) -> Void,
        deleteTaskAction: @escaping (PlantTask) -> Void,
        completeTaskAction: @escaping (PlantTask) -> Void
    ) {
        self.task = task
        self.editTaskAction = editTaskAction
        self.deleteTaskAction = deleteTaskAction
        self.completeTaskAction = completeTaskAction
    }
    
    var body: some View {
        HStack(spacing: Constants.Spacing.medium) {
            RemoteImage(
                urlString: task.imageUrl,
                contentMode: .fill
            )
            .frame(width: Constants.IconSize.xLarge, height: Constants.IconSize.xLarge)
            .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.medium))
            .overlay {
                RoundedRectangle(cornerRadius: Constants.CornerRadius.medium)
                    .strokeBorder(
                        TaskType.color(for: task.taskType),
                        lineWidth: 3
                    )
            }
            .clipped()
            .allowsHitTesting(false)
                
            VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(task.plantName)
                        .font(Fonts.bodySemibold)
                        .foregroundColor(Colors.secondaryText)
                    
                    Text(TaskType.title(for: task.taskType))
                        .font(Fonts.titleSemibold)
                }
                
                TaskDateChip(
                    isCompleted: task.isCompleted,
                    dueDate: task.dueDate,
                    completionDate: task.completionDate
                )
            }
            
            Spacer()
            
            VStack(spacing: Constants.Spacing.medium) {
                PlantTaskMenu(
                    canEdit: !task.isCompleted,
                    canDelete: task.isCompleted,
                    deleteTaskAction: { deleteTaskAction(task) },
                    editTaskAction: { editTaskAction(task) }
                )
                
                if !task.isCompleted {
                    Button {
                        completeTaskAction(task)
                    } label: {
                        RoundedIcon(
                            icon: Icons.check,
                            isFilled: task.isCompleted,
                            foregroundColor: TaskType.color(for: task.taskType)
                        )
                    }
                } else {
                    Spacer()
                        .frame(height: Constants.IconSize.xMedium)
                }
            }
        }
        .animation(.easeIn(duration: 0.25), value: task.isCompleted)
        .frame(maxWidth: .infinity)
        .padding([.leading, .vertical], Constants.Spacing.medium)
        .padding(.trailing)
        .foregroundStyle(Colors.primaryText)
        .background(Colors.secondaryBackground)
        .cornerRadius(Constants.CornerRadius.large)
    }
}

#Preview {
    Resolver.registerUseCaseMocks()
    
    return ScrollView {
        TaskRow(
            task: .mock(id: UUID()),
            editTaskAction: { _ in },
            deleteTaskAction: { _ in },
            completeTaskAction: { _ in }
        )
    }
    .background(Colors.primaryBackground)
}
