//
//  PlantRow.swift
//  Plants
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import Resolver
import SharedDomain
import SwiftUI
import UIToolkit

struct PlantRow: View {
    
    private let plant: Plant
    private let trackPlantProgressAction: (UUID) -> Void
    private let completeTaskAction: (Plant, TaskType) -> Void
    private let openPlantDetailAction: (UUID) -> Void
    
    init(
        plant: Plant,
        trackPlantProgressAction: @escaping (UUID) -> Void,
        completeTaskAction: @escaping (Plant, TaskType) -> Void,
        openPlantDetailAction: @escaping (UUID) -> Void
    ) {
        self.plant = plant
        self.trackPlantProgressAction = trackPlantProgressAction
        self.completeTaskAction = completeTaskAction
        self.openPlantDetailAction = openPlantDetailAction
    }
    
    var body: some View {
        Button {
            openPlantDetailAction(plant.id)
        } label: {
            VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
                ZStack {
                    RemoteImage(
                        urlString: plant.images.sorted(by: { $0.date > $1.date }).first?.urlString,
                        contentMode: .fill
                    )
                    .frame(height: 215)
                    .clipped()
                    .cornerRadius(Constants.CornerRadius.large)
                    .allowsHitTesting(false)
                    
                    Button {
                        trackPlantProgressAction(plant.id)
                    } label: {
                        HStack(spacing: Constants.Spacing.small) {
                            Text(Strings.trackButton)
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
                    
                    if !plant.settings.tasksConfigurations.isEmpty {
                        TaskQuickActionList(
                            taskConfigurations: plant.settings.tasksConfigurations,
                            action: { taskType in
                                completeTaskAction(plant, taskType)
                            }
                        )
                    }
                }
                .padding(.bottom)
            }
        }
        .foregroundStyle(Colors.primaryText)
        .background(Colors.secondaryBackground)
        .cornerRadius(Constants.CornerRadius.large)
    }
}

#Preview {
    Resolver.registerUseCaseMocks()
    
    return ScrollView(showsIndicators: false) {
        PlantRow(
            plant: .mock(id: UUID()),
            trackPlantProgressAction: { _ in },
            completeTaskAction: { _, _ in },
            openPlantDetailAction: { _ in }
        )
    }
    .background(Colors.primaryBackground)
    .colorScheme(.light)
}
