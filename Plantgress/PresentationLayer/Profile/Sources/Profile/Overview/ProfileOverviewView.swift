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
                    BaseList(title: Strings.accountTitle) {
                        ButtonListRow(
                            title: Strings.changeEmailButton,
                            isLast: false,
                            trailingIcon: Asset.Icons.chevronRight.image,
                            action: { viewModel.onIntent(.showChangeEmail) }
                        )
                        
                        ButtonListRow(
                            title: Strings.changeNameButton,
                            isLast: false,
                            trailingIcon: Asset.Icons.chevronRight.image,
                            action: { viewModel.onIntent(.showChangeName) }
                        )
                        
                        ButtonListRow(
                            title: Strings.changePasswordButton,
                            isLast: false,
                            trailingIcon: Asset.Icons.chevronRight.image,
                            action: { viewModel.onIntent(.showChangePassword) }
                        )
                        
                        ButtonListRow(
                            title: Strings.deleteAccountButton,
                            titleFont: Fonts.bodySemibold,
                            foregroundColor: Colors.red,
                            isLast: true,
                            action: { viewModel.onIntent(.deleteUser) }
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
