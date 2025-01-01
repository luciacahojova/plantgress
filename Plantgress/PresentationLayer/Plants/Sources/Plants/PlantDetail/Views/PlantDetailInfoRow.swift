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
    
    init(
        plantName: String,
        roomName: String?,
        trackProgressAction: @escaping () -> Void
    ) {
        self.plantName = plantName
        self.roomName = roomName
        self.trackProgressAction = trackProgressAction
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
    }
}

#Preview {
    PlantDetailInfoRow(
        plantName: "Monstera",
        roomName: "LivingRoom",
        trackProgressAction: {}
    )
}
