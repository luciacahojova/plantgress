//
//  ForgottenPasswordView.swift
//  Onboarding
//
//  Created by Lucia Cahojova on 07.12.2024.
//

import Resolver
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
        GeometryReader { geo in
            VStack(spacing: 0) {
                VStack(spacing: Constants.Spacing.medium) {
                    Button {
                        viewModel.onIntent(.dismiss)
                    } label: {
                        Text(Strings.dismissButton)
                            .font(Fonts.bodyMedium)
                    }
                    .frame(height: viewModel.state.navigationBarHeight - geo.safeAreaInsets.top)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Text(Strings.forgottenPasswordTitle)
                        .font(Fonts.largeTitleBold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                VStack(spacing: Constants.Spacing.medium) {
                    OutlinedTextField(
                        text: Binding<String>(
                            get: { viewModel.state.email },
                            set: { email in viewModel.onIntent(.emailChanged(email)) }
                        ),
                        placeholder: Strings.onboardingEmailPlaceholder,
                        errorMessage: viewModel.state.emailErrorMessage,
                        deleteTextAction: { viewModel.onIntent(.emailChanged("")) }
                    )
                    
                    Text(Strings.passwordResetMessage)
                        .font(Fonts.captionMedium)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, Constants.Spacing.medium)
                    
                    if let errorMessage = viewModel.state.errorMessage {
                        Text(errorMessage)
                            .font(Fonts.captionMedium)
                            .foregroundStyle(Color.red)
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer()
                    
                    Button(Strings.loginTitle) {
                        viewModel.onIntent(.showLogin)
                    }
                    .buttonStyle(SecondaryButtonStyle())
                    
                    Button(Strings.resetPasswordButtom) {
                        viewModel.onIntent(.sendResetPasswordLink)
                    }
                    .buttonStyle(
                        PrimaryButtonStyle(
                            isLoading: viewModel.state.isResetPasswordButtonLoading,
                            isDisabled: viewModel.state.isResetPasswordButtonDisabled
                        )
                    )
                }
                .padding(.top, Constants.Spacing.large)
                .padding(.bottom, Constants.Spacing.xxxxLarge)
            }
            .padding(.horizontal)
        }
        .foregroundStyle(Colors.primaryText)
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
    Resolver.registerUseCasesForPreviews()
    
    let vm = ForgottenPasswordViewModel(
        flowController: nil,
        onDismiss: {}
    )
    
    return ForgottenPasswordView(
        viewModel: vm
    )
}
