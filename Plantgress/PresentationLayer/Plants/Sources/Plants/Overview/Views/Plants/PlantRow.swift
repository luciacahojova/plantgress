//
//  PlantRow.swift
//  Plants
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import SharedDomain
import SwiftUI
import UIToolkit

struct PlantRow: View {
    
    private let plant: Plant
    private let trackPlantProgressAction: (UUID) -> Void
    private let trackTaskAction: (TaskType) -> Void
    
    init(
        plant: Plant,
        trackPlantProgressAction: @escaping (UUID) -> Void,
        trackTaskAction: @escaping (TaskType) -> Void
    ) {
        self.plant = plant
        self.trackPlantProgressAction = trackPlantProgressAction
        self.trackTaskAction = trackTaskAction
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
            ZStack {
                Asset.Images.primaryOnboardingBackground.image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 215)
                    .clipped()
                    .cornerRadius(Constants.CornerRadius.large)
                    .allowsHitTesting(false)
                
                Button {
                    trackPlantProgressAction(plant.id)
                } label: {
                    HStack(spacing: Constants.Spacing.small) {
                        Text("Track") // TODO: String
                            .font(Fonts.bodyMedium)
                        
                        Asset.Icons.cameraPlus.image
                            .resizable()
                            .scaledToFit()
                            .frame(width: Constants.IconSize.small)
                    }
                    .padding(.vertical, Constants.Spacing.medium)
                    .padding(.horizontal, Constants.Spacing.xMedium)
                    .background(Colors.secondaryBackground)
                    .cornerRadius(Constants.CornerRadius.xxxLarge)
                }
                .padding(Constants.Spacing.medium)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            }
            
            VStack(spacing: Constants.Spacing.xMedium) {
                Text(plant.name)
                    .font(Fonts.titleSemibold)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if !plant.settings.tasksConfiguartions.isEmpty {
                    TaskQuickActionList(
                        taskConfigurations: plant.settings.tasksConfiguartions,
                        action: trackTaskAction
                    )
                }
            }
            .padding(.bottom)
        }
        .foregroundStyle(Colors.primaryText)
        .background(Colors.secondaryBackground)
        .cornerRadius(Constants.CornerRadius.large)
    }
}

#Preview {
    ScrollView {
        PlantRow(
            plant: .mock(id: UUID()),
            trackPlantProgressAction: { _ in },
            trackTaskAction: { _ in }
        )
    }
    .background(Colors.primaryBackground)
    .colorScheme(.light)
}
