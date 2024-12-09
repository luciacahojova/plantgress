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
                    text: .constant(""),
                    placeholder: Strings.onboardingEmailPlaceholder
                )
                
                OutlinedTextField(
                    text: .constant(""),
                    placeholder: Strings.onboardingNamePlaceholder
                )
                
                OutlinedTextField(
                    text: .constant(""),
                    placeholder: Strings.onboardingSurnamePlaceholder
                )
                
                SecureOulinedTextField(
                    text: .constant(""),
                    placeholder: Strings.onboardingPasswordPlaceholder
                )
                
                SecureOulinedTextField(
                    text: .constant(""),
                    placeholder: Strings.onboardingRepeatPasswordPlaceholder
                )
                
                Spacer()
                
                Button(Strings.onboardingRegistrationButton) {
                    viewModel.onIntent(.registerUser)
                }
                .buttonStyle(
                    PrimaryButtonStyle(isDisabled: false) // TODO:
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
