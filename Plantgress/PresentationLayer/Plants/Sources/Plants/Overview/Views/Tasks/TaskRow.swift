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
    
    private let editTaskAction: (UUID) -> Void
    private let deleteTaskAction: (PlantTask) -> Void
    private let completeTaskAction: (PlantTask) -> Void
    
    init(
        task: PlantTask,
        editTaskAction: @escaping (UUID) -> Void,
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
            .clipped()
            .cornerRadius(Constants.CornerRadius.medium)
            .allowsHitTesting(false)
                
            VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(task.plantName)
                        .font(Fonts.bodySemibold)
                        .foregroundColor(Colors.secondaryText)
                    
                    Text(TaskType.title(for: task.taskType))
                        .font(Fonts.titleSemibold)
                }
                
                if !task.isCompleted {
                    TaskDateChip(text: "in \(task.daysUntilDue()) days") // TODO: String
                } else if let completionDate = task.completionDate {
                    TaskDateChip(text: "Completed on \(completionDate.toString(formatter: Formatter.Date.ddMMyy))") // TODO: String, handle TODAY
                }
            }
            
            Spacer()
            
            VStack(spacing: Constants.Spacing.medium) {
                PlantTaskMenu(
                    deleteTaskAction: { deleteTaskAction(task) },
                    editTaskAction: { editTaskAction(task.id) }
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
    Resolver.registerUseCasesForPreviews()
    
    return TaskRow(
        task: .mock(id: UUID()),
        editTaskAction: { _ in },
        deleteTaskAction: { _ in },
        completeTaskAction: { _ in }
    )
}
