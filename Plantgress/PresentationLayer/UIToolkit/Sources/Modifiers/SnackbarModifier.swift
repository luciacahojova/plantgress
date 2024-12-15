//
//  SnackbarModifier.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 10.12.2024.
//

import Foundation
import SwiftUI
import SwiftUICore

public struct SnackbarModifier: ViewModifier {
    @Binding private var snackbarData: SnackbarData?

    public init(
        snackbarData: Binding<SnackbarData?>
    ) {
        self._snackbarData = snackbarData
    }
    
    public func body(content: Content) -> some View {
        ZStack(alignment: snackbarData?.alignment ?? .center) {
            content
            
            if let snackbarData = snackbarData {
                VStack {
                    HStack(spacing: Constants.Spacing.medium) {
                        Text(snackbarData.message)
                            .font(Fonts.bodyRegular)
                            .multilineTextAlignment(.center)
                        
                        if let action = snackbarData.action {
                            Divider()
                            
                            Button(action: action) {
                                HStack(spacing: Constants.Spacing.small) {
                                    if let icon = snackbarData.icon {
                                        icon
                                            .renderingMode(.template)
                                            .resizable()
                                            .scaledToFit()
                                            .padding(.vertical, Constants.Spacing.medium)
                                    }
                                    
                                    if let actionText = snackbarData.actionText {
                                        Text(actionText)
                                            .font(Fonts.bodyBold)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + snackbarData.duration) {
                            self.snackbarData = nil
                        }
                    }
                    .frame(height: Constants.Frame.primaryButtonHeight)
                    .foregroundStyle(snackbarData.foregroundColor)
                    .background(snackbarData.backgroundColor)
                    .cornerRadius(Constants.CornerRadius.xLarge)
                }
                .shadow(radius: 2)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: snackbarData.alignment)
                .padding(.bottom, snackbarData.bottomPadding)
                .zIndex(1)
            }
        }
    }
}
