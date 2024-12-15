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
    private let deleteTaskAction: (UUID) -> Void
    private let completeTaskAction: (UUID) -> Void
    
    init(
        task: PlantTask,
        editTaskAction: @escaping (UUID) -> Void,
        deleteTaskAction: @escaping (UUID) -> Void,
        completeTaskAction: @escaping (UUID) -> Void
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
                
                Text("in 10 days") // TODO: String
                    .font(Fonts.subheadlineMedium)
                    .padding(.horizontal, Constants.Spacing.xMedium)
                    .padding(.vertical, Constants.Spacing.xSmall)
                    .background(Colors.secondaryText)
                    .foregroundStyle(Colors.white)
                    .cornerRadius(Constants.CornerRadius.xxxLarge)
            }
            
            Spacer()
            
            VStack(spacing: Constants.Spacing.medium) {
                Menu {
                    MenuLabelButton(
                        text: "Delete", // TODO: String
                        role: .destructive,
                        icon: Icons.trash,
                        action: {
                            deleteTaskAction(task.id)
                        }
                    )
                    
                    MenuLabelButton(
                        text: "Edit", // TODO: String
                        icon: Icons.edit,
                        action: {
                            editTaskAction(task.id)
                        }
                    )
                } label: {
                    RoundedIcon(icon: Icons.dotsHorizontal)
                }
                
                Button {
                    
                } label: {
                    RoundedIcon(
                        icon: Icons.check,
                        isFilled: task.isCompleted,
                        foregroundColor: TaskType.color(for: task.taskType)
                    )
                }
            }
        }
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
