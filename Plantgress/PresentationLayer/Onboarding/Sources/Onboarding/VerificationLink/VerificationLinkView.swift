//
//  VerificationLinkView.swift
//  Onboarding
//
//  Created by Lucia Cahojova on 09.12.2024.
//

import Resolver
import SwiftUI
import UIToolkit

struct VerificationLinkView: View {
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: VerificationLinkViewModel
    
    // MARK: - Init
    
    init(viewModel: VerificationLinkViewModel) {
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
                    
                    Text(Strings.verificationLinkTitle)
                        .font(Fonts.largeTitleBold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                VStack(spacing: Constants.Spacing.medium) {
                    Text(Strings.verificationLinkSentMessage)
                        .font(Fonts.bodyRegular)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    if let errorMessage = viewModel.state.errorMessage {
                        Text(errorMessage)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Colors.red)
                            .font(Fonts.captionMedium)
                    }
                    
                    VStack {
                        if let message = viewModel.state.message {
                            Text(message)
                                .multilineTextAlignment(.center)
                        } else {
                            Button {
                                viewModel.onIntent(.resendLink)
                            } label: {
                                Text(Strings.resendVerificationLinkButton)
                                    .underline()
                            }
                        }
                    }
                    .frame(height: Constants.Frame.primaryButtonHeight)
                    
                    Button(Strings.onboardingLoginButton) {
                        viewModel.onIntent(.showLogin)
                    }
                    .buttonStyle(
                        PrimaryButtonStyle(isDisabled: viewModel.state.isLoginButtonDisabled)
                    )
                }
                .padding(.top, Constants.Spacing.large)
                .padding(.bottom, Constants.Spacing.xxxxLarge)
            }
        }
        .animation(.default, value: viewModel.state.errorMessage)
        .font(Fonts.subheadlineMedium)
        .padding(.horizontal)
        .foregroundStyle(Colors.primaryText)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.bottom)
        .lifecycle(viewModel)
    }
}

#Preview {
    Resolver.registerUseCasesForPreviews()
    
    let vm = VerificationLinkViewModel(
        flowController: nil,
        onDismiss: {}
    )
    
    return VerificationLinkView(
        viewModel: vm
    )
    .colorScheme(.dark)
}
