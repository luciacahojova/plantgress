//
//  TaskDateChip.swift
//  Plants
//
//  Created by Lucia Cahojova on 19.12.2024.
//

import SharedDomain
import SwiftUI
import UIToolkit

struct TaskDateChip: View {
    
    private let isCompleted: Bool
    private let dueDate: Date
    private let completionDate: Date?
    private let daysDifference: Int
    
    init(
        isCompleted: Bool,
        dueDate: Date,
        completionDate: Date?
    ) {
        self.isCompleted = isCompleted
        self.dueDate = dueDate
        self.completionDate = completionDate
        
        self.daysDifference = PlantTask.daysDifference(from: .now, to: dueDate)
    }
    
    var body: some View {
        VStack {
            if isCompleted, let completionDate {
                Text(Strings.taskCompletedOnTitle(completionDate.toString(formatter: Formatter.Date.ddMMyy)))
            } else if daysDifference == 0 {
                Text(Strings.taskDueTodayTitle)
            } else if daysDifference < 0 {
                if daysDifference == -1 {
                    Text(Strings.taskOverdueDaysOneTitle)
                } else {
                    Text(Strings.taskOverdueDaysManyTitle(abs(daysDifference)))
                }
            } else {
                if daysDifference == 1 {
                    Text(Strings.taskDueDaysOneTitle)
                } else if daysDifference < 5 {
                    Text(Strings.taskDueDaysFewTitle(daysDifference))
                } else {
                    Text(Strings.taskDueDaysManyTitle(daysDifference))
                }
            }
        }
        .font(Fonts.subheadlineMedium)
        .padding(.horizontal, Constants.Spacing.xMedium)
        .padding(.vertical, Constants.Spacing.xSmall)
        .background(Colors.secondaryText)
        .foregroundStyle(Colors.white)
        .cornerRadius(Constants.CornerRadius.xxxLarge)
    }
}

#Preview {
    TaskDateChip(
        isCompleted: true,
        dueDate: Date(),
        completionDate: Date()
    )
}
