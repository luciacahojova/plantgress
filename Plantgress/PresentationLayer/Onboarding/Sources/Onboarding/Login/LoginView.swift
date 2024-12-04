//
//  LoginView.swift
//  Onboarding
//
//  Created by Lucia Cahojova on 04.12.2024.
//

import SwiftUI

struct LoginView: View {
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: LoginViewModel
    
    // MARK: - Init
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            Button("Setup Main") {
                viewModel.onIntent(.sync(.dismiss))
            }
        }
    }
}

#Preview {
    let vm = LoginViewModel(flowController: nil)
    
    LoginView(
        viewModel: vm
    )
}
