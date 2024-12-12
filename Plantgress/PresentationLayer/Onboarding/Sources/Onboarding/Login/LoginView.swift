//
//  LoginView.swift
//  Onboarding
//
//  Created by Lucia Cahojova on 04.12.2024.
//

import Resolver
import SwiftUI
import UIToolkit

struct LoginView: View {
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: LoginViewModel
    
    // MARK: - Init
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: Constants.Spacing.medium) {
                OutlinedTextField( // TODO: Update keychain email when user tries to log in, add done to keyboard, handle user does not exist
                    text: Binding<String>(
                        get: { viewModel.state.email },
                        set: { email in viewModel.onIntent(.emailChanged(email)) }
                    ),
                    placeholder: Strings.onboardingEmailPlaceholder,
                    errorMessage: viewModel.state.emailErrorMessage
                )
                
                SecureOulinedTextField(
                    text: Binding<String>(
                        get: { viewModel.state.password },
                        set: { password in viewModel.onIntent(.passwordChanged(password)) }
                    ),
                    placeholder: Strings.onboardingPasswordPlaceholder,
                    errorMessage: viewModel.state.passwordErrorMessage
                )
                
                Button {
                    viewModel.onIntent(.showForgottenPassword)
                } label: {
                    Text(Strings.forgottenPasswordTitle)
                        .underline()
                        .font(Fonts.subheadlineMedium)
                        .foregroundStyle(Colors.primaryText)
                        .padding(.horizontal, Constants.Spacing.medium)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if let errorMessage = viewModel.state.errorMessage {
                    Text(errorMessage)
                        .font(Fonts.captionMedium)
                        .foregroundStyle(Color.red)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                if viewModel.state.isEmailVerificationButtonVisible {
                    Button(Strings.loginSendVerificationLinkButton) {
                        viewModel.onIntent(.sendEmailVerification)
                    }
                    .buttonStyle(
                        PrimaryButtonStyle(
                            isLoading: viewModel.state.isEmailVerificationButtonLoading
                        )
                    )
                } else {
                    Button(Strings.onboardingLoginButton) {
                        viewModel.onIntent(.logInUser)
                    }
                    .buttonStyle(
                        PrimaryButtonStyle(
                            isLoading: viewModel.state.isLoginButtonLoading,
                            isDisabled: viewModel.state.isLoginButtonDisabled
                        )
                    )
                }
            }
            .padding(.horizontal)
            .padding(.top, Constants.Spacing.large)
            .padding(.bottom, Constants.Spacing.xxxxLarge)
            .background {
                Images.secondaryOnboardingBackground
                    .resizable()
                    .scaledToFill()
            }
            .frame(maxWidth: geo.size.width, maxHeight: geo.size.height)
        }
        .animation(.default, value: viewModel.state.isLoginButtonDisabled)
        .animation(.default, value: viewModel.state.isEmailVerificationButtonVisible)
        .edgesIgnoringSafeArea(.bottom)
        .lifecycle(viewModel)
    }
}

#Preview {
    Resolver.registerUseCasesForPreviews()
    
    let vm = LoginViewModel(flowController: nil)
    
    return LoginView(
        viewModel: vm
    )
}
