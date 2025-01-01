//
//  PlantDetailHeaderView.swift
//  Plants
//
//  Created by Lucia Cahojova on 30.12.2024.
//

import SwiftUI
import UIToolkit

struct PlantDetailHeaderView: View {
    
    private let hasError: Bool
    private let isLoading: Bool
    private let navigateBackAction: () -> Void
    private let showSettingsAction: () -> Void
    private let shareAction: () -> Void
    
    init(
        hasError: Bool,
        isLoading: Bool,
        navigateBackAction: @escaping () -> Void,
        showSettingsAction: @escaping () -> Void,
        shareAction: @escaping () -> Void
    ) {
        self.hasError = hasError
        self.isLoading = isLoading
        self.navigateBackAction = navigateBackAction
        self.showSettingsAction = showSettingsAction
        self.shareAction = shareAction
    }
    
    var body: some View {
        HStack(spacing: Constants.Spacing.xMedium) {
            Button(action: navigateBackAction) {
                Icons.chevronLeft
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Constants.IconSize.medium)
            }
            
            Spacer()
            
            if !hasError {
                Button(action: shareAction) {
                    Icons.send
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: Constants.IconSize.xMedium)
                }
                .skeleton(isLoading)
                
                Button(action: showSettingsAction) {
                    Icons.settings
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: Constants.IconSize.xMedium)
                }
                .skeleton(isLoading)
            }
        }
        .padding(.trailing)
        .padding(.top, Constants.statusBarHeight + Constants.Spacing.small)
        .foregroundStyle(Colors.primaryText)
    }
}

#Preview {
    PlantDetailHeaderView(
        hasError: false,
        isLoading: false,
        navigateBackAction: {},
        showSettingsAction: {},
        shareAction: {}
    )
}
