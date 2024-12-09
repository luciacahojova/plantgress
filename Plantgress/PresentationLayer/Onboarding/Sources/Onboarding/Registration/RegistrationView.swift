//
//  RegistrationView.swift
//  Onboarding
//
//  Created by Lucia Cahojova on 04.12.2024.
//

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
        VStack {
            Button("Setup Main") {
                viewModel.onIntent(.dismiss)
            }
            
            Button("Register User") {
                viewModel.onIntent(.registerUser)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Images.secondaryOnboardingBackground
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        }
        .lifecycle(viewModel)
    }
}

#Preview {
    let vm = RegistrationViewModel(flowController: nil)
    
    RegistrationView(
        viewModel: vm
    )
}
