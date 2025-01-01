//
//  PlantDetailInfoRow.swift
//  Plants
//
//  Created by Lucia Cahojova on 30.12.2024.
//

import SwiftUI
import UIToolkit

struct PlantDetailInfoRow: View {
    
    private let plantName: String
    private let roomName: String?
    private let trackProgressAction: () -> Void
    
    private let skeleton: Bool
    
    init(
        plantName: String,
        roomName: String?,
        trackProgressAction: @escaping () -> Void
    ) {
        self.plantName = plantName
        self.roomName = roomName
        self.trackProgressAction = trackProgressAction
        self.skeleton = false
    }
    
    private init() {
        self.plantName = "Monstera"
        self.roomName = "Living Room"
        self.trackProgressAction = {}
        self.skeleton = true
    }
    
    static var skeleton: PlantDetailInfoRow {
        self.init()
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: Constants.Spacing.small) {
                Text(plantName)
                    .font(Fonts.titleBold)
                
                if let roomName {
                    HStack(spacing: Constants.Spacing.small) {
                        Icons.tag
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16)
                        
                        Text(roomName)
                    }
                }
            }
            
            Spacer()
            
            Button(action: trackProgressAction) {
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
        }
        .skeleton(skeleton)
    }
}

#Preview {
    PlantDetailInfoRow(
        plantName: "Monstera",
        roomName: "LivingRoom",
        trackProgressAction: {}
    )
}
