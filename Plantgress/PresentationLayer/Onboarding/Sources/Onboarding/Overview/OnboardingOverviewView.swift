//
//  OnboardingOverviewView.swift
//  Plantgress
//
//  Created by Lucia Cahojova on 02.12.2024.
//

import SwiftUI
import UIToolkit

struct OnboardingOverviewView: View {
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: OnboardingOverviewViewModel
    
    // MARK: - Init
    
    init(viewModel: OnboardingOverviewViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                
                Images.logoWithText
                    .resizable()
                    .scaledToFit()
                    .frame(width: Constants.IconSize.maxi)
                
                Button(Strings.onboardingRegistrationButton) {
                    viewModel.onIntent(.showRegistration)
                }
                .buttonStyle(PrimaryButtonStyle())
                
                Button(Strings.onboardingLoginButton) {
                    viewModel.onIntent(.showLogin)
                }
                .buttonStyle(
                    PrimaryButtonStyle(
                        foregroundColor: Colors.primaryText,
                        backgroundColor: Colors.secondaryButton
                    )
                )
            }
            .padding(.horizontal)
            .padding(.bottom, Constants.Spacing.xxxxLarge)
            .background {
                Images.primaryOnboardingBackground
                    .resizable()
                    .scaledToFill()
            }
        }
        .edgesIgnoringSafeArea(.all)
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
    let vm = OnboardingOverviewViewModel(flowController: nil)
    
    OnboardingOverviewView(
        viewModel: vm
    )
    .colorScheme(.light)
}
