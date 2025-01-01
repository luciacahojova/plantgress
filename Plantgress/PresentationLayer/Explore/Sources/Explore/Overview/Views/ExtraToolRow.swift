//
//  ExtraToolRow.swift
//  Explore
//
//  Created by Lucia Cahojova on 01.01.2025.
//

import SwiftUI
import UIToolkit

struct ExtraToolRow: View {
    
    private let title: String
    private let subtitle: String
    private let image: Image
    private let icon: Image
    private let action: () -> Void
    
    init(
        title: String,
        subtitle: String,
        image: Image,
        icon: Image,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
                VStack(alignment: .leading, spacing: Constants.Spacing.small) {
                    Text(title)
                        .font(Fonts.titleBold)
                        .foregroundColor(Colors.primaryText)
                    
                    Text(subtitle)
                        .font(Fonts.subheadlineRegular)
                        .foregroundColor(Colors.secondaryText)
                        .multilineTextAlignment(.leading)
                }
                
                ZStack {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 150)
                        .clipped()
                    
                    Colors.white.opacity(0.5)
                        .frame(height: 150)
                    
                    icon
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: Constants.IconSize.large)
                        .foregroundStyle(Colors.white)
                }
                .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.large))
            }
            .padding()
        }
        .background(Colors.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.large))
    }
}

#Preview {
    ScrollView {
        ExtraToolRow(
            title: "Luxmeter",
            subtitle: "Use the Luxmeter to measure light levels and ensure your plants receive the optimal amount of light for healthy growth.",
            image: Images.primaryOnboardingBackground,
            icon: Icons.lightbulb,
            action: {}
        )
    }
    .background(Colors.primaryBackground)
}
