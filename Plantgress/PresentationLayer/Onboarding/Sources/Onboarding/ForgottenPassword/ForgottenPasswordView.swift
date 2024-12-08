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
        VStack {
            Button("Setup Main") {
                viewModel.onIntent(.dismiss)
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
    let vm = ForgottenPasswordViewModel(flowController: nil)
    
    ForgottenPasswordView(
        viewModel: vm
    )
}
