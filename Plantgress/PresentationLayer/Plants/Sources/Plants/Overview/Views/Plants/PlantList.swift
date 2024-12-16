//
//  PlantList.swift
//  Plants
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import SharedDomain
import SwiftUI
import UIToolkit

struct PlantList: View {
    
    private let plants: [Plant]
    private let trackPlantProgressAction: (UUID) -> Void
    private let completeTaskAction: (UUID, TaskType) -> Void
    
    private let isLoading: Bool
    
    init(
        plants: [Plant],
        trackPlantProgressAction: @escaping (UUID) -> Void,
        completeTaskAction: @escaping (UUID, TaskType) -> Void
    ) {
        self.plants = plants
        self.trackPlantProgressAction = trackPlantProgressAction
        self.completeTaskAction = completeTaskAction
        self.isLoading = false
    }
    
    private init() {
        self.plants = .mock
        self.trackPlantProgressAction = { _ in }
        self.completeTaskAction = { _, _ in }
        self.isLoading = true
    }
    
    static var skeleton: PlantList {
        self.init()
    }
    
    var body: some View {
        LazyVStack(spacing: Constants.Spacing.large) {
            ForEach(plants, id: \.id) { plant in
                PlantRow(
                    plant: plant,
                    trackPlantProgressAction: trackPlantProgressAction,
                    completeTaskAction: completeTaskAction
                )
            }
        }
        .skeleton(isLoading)
    }
}

#Preview {
    ScrollView(showsIndicators: false) {
        PlantList(
            plants: .mock,
            trackPlantProgressAction: { _ in },
            completeTaskAction: { _, _ in }
        )
    }
}
