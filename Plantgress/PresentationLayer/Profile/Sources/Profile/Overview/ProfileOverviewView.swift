//
//  ProfileOverviewView.swift
//  Plants
//
//  Created by Lucia Cahojova on 03.12.2024.
//

import SwiftUI
import UIToolkit

struct ProfileOverviewView: View {
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: ProfileOverviewViewModel
    
    // MARK: - Init
    
    init(viewModel: ProfileOverviewViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            if viewModel.state.isLoading {
                ProgressView()
            } else if let user = viewModel.state.user {
                Text(user.name + "Account👤")
            }
            
            Button("Show Onboarding") {
                viewModel.onIntent(.presentOnboarding(message: nil))
            }
        }
        .lifecycle(viewModel)
    }
}

#Preview {
    let vm = ProfileOverviewViewModel(flowController: nil)
    
    ProfileOverviewView(
        viewModel: vm
    )
}
