//
//  RegistrationView.swift
//  Onboarding
//
//  Created by Lucia Cahojova on 04.12.2024.
//

import Resolver
import SwiftUI
import UIToolkit

struct RegistrationView: View {
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: RegistrationViewModel
    
    // MARK: - Init
    
    init(viewModel: RegistrationViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: Constants.Spacing.medium) {
                OutlinedTextField(
                    text: Binding<String>(
                        get: { viewModel.state.email },
                        set: { email in viewModel.onIntent(.emailChanged(email)) }
                    ),
                    placeholder: Strings.onboardingEmailPlaceholder,
                    errorMessage: viewModel.state.emailErrorMessage
                )
                
                OutlinedTextField(
                    text: Binding<String>(
                        get: { viewModel.state.name },
                        set: { name in viewModel.onIntent(.nameChanged(name)) }
                    ),
                    placeholder: Strings.onboardingNamePlaceholder,
                    errorMessage: viewModel.state.nameErrorMessage
                )
                
                OutlinedTextField(
                    text: Binding<String>(
                        get: { viewModel.state.surname },
                        set: { surname in viewModel.onIntent(.surnameChanged(surname)) }
                    ),
                    placeholder: Strings.onboardingSurnamePlaceholder,
                    errorMessage: viewModel.state.surnameErrorMessage
                )
                
                SecureOulinedTextField(
                    text: Binding<String>(
                        get: { viewModel.state.password },
                        set: { password in viewModel.onIntent(.passwordChanged(password)) }
                    ),
                    placeholder: Strings.onboardingPasswordPlaceholder,
                    errorMessage: viewModel.state.passwordErrorMessage
                )
                
                SecureOulinedTextField(
                    text: Binding<String>(
                        get: { viewModel.state.repeatPassword },
                        set: { repeatPassword in viewModel.onIntent(.repeatPasswordChanged(repeatPassword)) }
                    ),
                    placeholder: Strings.onboardingRepeatPasswordPlaceholder,
                    errorMessage: viewModel.state.repeatPasswordErrorMessage
                )
                
                if let errorMessage = viewModel.state.errorMessage {
                    Text(errorMessage)
                        .font(Fonts.captionMedium)
                        .foregroundStyle(Color.red)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                Button(Strings.onboardingRegistrationButton) {
                    viewModel.onIntent(.registerUser)
                }
                .buttonStyle(
                    PrimaryButtonStyle(isDisabled: viewModel.state.isRegisterButtonDisabled)
                )
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
        .animation(.default, value: viewModel.state.isRegisterButtonDisabled)
        .edgesIgnoringSafeArea(.bottom)
        .lifecycle(viewModel)
    }
}

#Preview {
    Resolver.registerUseCasesForPreviews()
    
    let vm = RegistrationViewModel(flowController: nil)
    return RegistrationView(
        viewModel: vm
    )
    .colorScheme(.dark)
}
