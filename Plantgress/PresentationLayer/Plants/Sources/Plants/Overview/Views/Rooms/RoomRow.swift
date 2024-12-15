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
    private let trackTaskAction: (UUID, TaskType) -> Void
    
    init(room: Room, trackTaskAction: @escaping (UUID, TaskType) -> Void) {
        self.room = room
        self.trackTaskAction = trackTaskAction
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
//            DynamicImagesView(
//                urlStrings: room.imageUrls,
//                height: 150
//            )
//            .cornerRadius(Constants.CornerRadius.large)
//            .allowsHitTesting(false)
            RemoteImage(
                urlString: room.imageUrls.first,
                contentMode: .fill
            )
            .frame(height: 150)
            .clipped()
            .cornerRadius(Constants.CornerRadius.large)
            .allowsHitTesting(false)
            
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
                        trackTaskAction(room.id, taskType)
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
    
    return ScrollView(showsIndicators: false) {
        RoomRow(
            room: .mock(id: UUID()),
            trackTaskAction: { _, _ in }
        )
    }
    .background(Colors.primaryBackground)
    .colorScheme(.light)
}
