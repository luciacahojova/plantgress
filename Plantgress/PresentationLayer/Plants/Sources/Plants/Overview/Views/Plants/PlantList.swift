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
    private let trackTaskAction: (TaskType) -> Void
    
    init(
        plants: [Plant],
        trackPlantProgressAction: @escaping (UUID) -> Void,
        trackTaskAction: @escaping (TaskType) -> Void
    ) {
        self.plants = plants
        self.trackPlantProgressAction = trackPlantProgressAction
        self.trackTaskAction = trackTaskAction
    }
    
    var body: some View {
        VStack(spacing: Constants.Spacing.large) {
            ForEach(plants, id: \.id) { plant in
                PlantRow(
                    plant: plant,
                    trackPlantProgressAction: trackPlantProgressAction,
                    trackTaskAction: trackTaskAction
                )
            }
        }
    }
}

#Preview {
    PlantList(
        plants: .mock,
        trackPlantProgressAction: { _ in },
        trackTaskAction: { _ in }
    )
}
