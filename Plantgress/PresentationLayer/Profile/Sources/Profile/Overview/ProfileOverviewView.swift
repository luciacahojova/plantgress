//
//  ProfileOverviewView.swift
//  Plants
//
//  Created by Lucia Cahojova on 03.12.2024.
//

import SwiftUI
import Resolver
import UIToolkit

struct ProfileOverviewView: View {
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: ProfileOverviewViewModel
    
    // MARK: - Init
    
    init(viewModel: ProfileOverviewViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Constants.Spacing.xxxLarge) {
                VStack(spacing: Constants.Spacing.large) {
                    BaseList(title: "Account") {
                        ButtonListRow(
                            title: "Change Email",
                            isLast: false,
                            trailingIcon: Asset.Icons.chevronRight.image,
                            action: {
                                // TODO: Flow controller action
                            }
                        )
                        
                        ButtonListRow(
                            title: "Change Name",
                            isLast: false,
                            trailingIcon: Asset.Icons.chevronRight.image,
                            action: {
                                // TODO: Flow controller action
                            }
                        )
                        
                        ButtonListRow(
                            title: "Change Password",
                            isLast: false,
                            trailingIcon: Asset.Icons.chevronRight.image,
                            action: {
                                // TODO: Flow controller action
                            }
                        )
                        
                        ButtonListRow(
                            title: "Delete Account",
                            foregroundColor: Colors.red,
                            isLast: true,
                            action: {
                                // TODO: Flow controller action
                            }
                        )
                    }
                    
                    if let errorMessage = viewModel.state.errorMessage {
                        Text(errorMessage)
                            .font(Fonts.captionMedium)
                            .foregroundStyle(Color.red)
                            .multilineTextAlignment(.center)
                    }
                }
                
                Button(Strings.logoutButton) {
                    viewModel.onIntent(.logoutUser)
                }
                .buttonStyle(
                    PrimaryButtonStyle(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red
                    )
                )
            }
        }
        .padding(.horizontal)
        .padding(.top, Constants.Spacing.large)
        .padding(.bottom, Constants.Spacing.xxLarge)
        .alert(item: Binding<AlertData?>(
            get: { viewModel.state.alertData },
            set: { alertData in
                viewModel.onIntent(.alertDataChanged(alertData))
            }
        )) { alert in .init(alert) }
        .background(Colors.primaryBackground) // TODO: Delete
        .lifecycle(viewModel)
    }
}

#Preview {
    Resolver.registerUseCasesForPreviews()
    
    let vm = ProfileOverviewViewModel(flowController: nil)
    
    return ProfileOverviewView(
        viewModel: vm
    )
}
