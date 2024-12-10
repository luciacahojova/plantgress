//
//  ForgottenPasswordView.swift
//  Onboarding
//
//  Created by Lucia Cahojova on 07.12.2024.
//

import SwiftUI
import UIToolkit

struct ForgottenPasswordView: View {
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: ForgottenPasswordViewModel
    
    // MARK: - Init
    
    init(viewModel: ForgottenPasswordViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: Constants.Spacing.medium) {
            OutlinedTextField(
                text: Binding<String>(
                    get: { viewModel.state.email },
                    set: { email in viewModel.onIntent(.emailChanged(email)) }
                ),
                placeholder: Strings.onboardingEmailPlaceholder,
                errorMessage: viewModel.state.emailErrorMessage
            )
            
            Text(Strings.passwordResetMessage)
                .font(Fonts.captionMedium)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            
            if let errorMessage = viewModel.state.errorMessage {
                Text(errorMessage)
                    .font(Fonts.captionMedium)
                    .foregroundStyle(Color.red)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            Button(Strings.resendVerificationLinkButton) {
                viewModel.onIntent(.sendResetPasswordLink)
            }
            .buttonStyle(
                SecondaryButtonStyle(
                    isLoading: viewModel.state.isResetPasswordButtonLoading,
                    isDisabled: viewModel.state.isResetPasswordButtonLoading
                )
            )
            
            Button(Strings.loginTitle) {
                viewModel.onIntent(.showLogin)
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .foregroundStyle(Colors.primaryText)
        .padding(.horizontal)
        .padding(.top, Constants.Spacing.large)
        .padding(.bottom, Constants.Spacing.xxxxLarge)
        .animation(.default, value: viewModel.state.isResetPasswordButtonDisabled)
        .edgesIgnoringSafeArea(.bottom)
        .snackbar(
            Binding<SnackbarData?>(
                get: { viewModel.state.snackbarData },
                set: { snackbarData in viewModel.onIntent(.snackbarDataChanged(snackbarData)) }
            )
        )
        .lifecycle(viewModel)
    }
}

#Preview {
    let vm = ForgottenPasswordViewModel(flowController: nil)
    
    ForgottenPasswordView(
        viewModel: vm
    )
}
