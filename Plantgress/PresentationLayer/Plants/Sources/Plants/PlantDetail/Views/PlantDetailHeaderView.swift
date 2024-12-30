//
//  PlantDetailHeaderView.swift
//  Plants
//
//  Created by Lucia Cahojova on 30.12.2024.
//

import SwiftUI
import UIToolkit

struct PlantDetailHeaderView: View {
    
    private let navigateBackAction: () -> Void
    private let showSettingsAction: () -> Void
    private let shareAction: () -> Void
    
    init(
        navigateBackAction: @escaping () -> Void,
        showSettingsAction: @escaping () -> Void,
        shareAction: @escaping () -> Void
    ) {
        self.navigateBackAction = navigateBackAction
        self.showSettingsAction = showSettingsAction
        self.shareAction = shareAction
    }
    
    var body: some View {
        HStack(spacing: Constants.Spacing.xMedium) {
            Icons.chevronLeft
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: Constants.IconSize.medium)
            
            Spacer()
            
            Icons.send
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: Constants.IconSize.xMedium)
            
            Icons.settings
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: Constants.IconSize.xMedium)
        }
        .padding(.trailing)
        .padding(.top, Constants.statusBarHeight + Constants.Spacing.small)
        .foregroundStyle(Colors.primaryText)
    }
}

#Preview {
    PlantDetailHeaderView(
        navigateBackAction: {},
        showSettingsAction: {},
        shareAction: {}
    )
}
