//
//  RoomRow.swift
//  Plants
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import Resolver
import SharedDomain
import SwiftUI
import UIToolkit

struct RoomRow: View {
    private let room: Room
    private let completeTaskAction: (UUID, TaskType) -> Void
    
    init(
        room: Room,
        completeTaskAction: @escaping (UUID, TaskType) -> Void
    ) {
        self.room = room
        self.completeTaskAction = completeTaskAction
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
            if !room.imageUrls.isEmpty {
                DynamicImagesView(
                    urlStrings: room.imageUrls
                )
                .allowsHitTesting(false)
                .frame(height: 150)
                .cornerRadius(Constants.CornerRadius.large)
                .contentShape(Rectangle())
            }
            
            VStack(spacing: Constants.Spacing.xMedium) {
                Text(room.name)
                    .font(Fonts.titleSemibold)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TaskQuickActionList(
                    taskConfigurations: .default,
                    action: { taskType in
                        completeTaskAction(room.id, taskType)
                    }
                )
            }
            .padding(.bottom)
        }
        .foregroundStyle(Colors.primaryText)
        .background(Colors.secondaryBackground)
        .cornerRadius(Constants.CornerRadius.large)
    }
}

#Preview {
    Resolver.registerUseCasesForPreviews()
    
    return RoomRow(
        room: .mock(id: UUID()),
        completeTaskAction: { _, _ in }
    )
    .padding()
    .background(Colors.primaryBackground)
    .colorScheme(.light)
}
