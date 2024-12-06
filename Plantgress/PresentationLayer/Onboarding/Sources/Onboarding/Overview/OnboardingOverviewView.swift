//
//  OnboardingOverviewView.swift
//  Plantgress
//
//  Created by Lucia Cahojova on 02.12.2024.
//

import SwiftUI

struct OnboardingOverviewView: View {
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: OnboardingOverviewViewModel
    
    // MARK: - Init
    
    init(viewModel: OnboardingOverviewViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            Button("Show Login") {
                viewModel.onIntent(.showLogin)
            }
            
            Button("Show Registration") {
                viewModel.onIntent(.showRegistration)
            }
        }
        .lifecycle(viewModel)
    }
}

#Preview {
    let vm = OnboardingOverviewViewModel(flowController: nil)
    
    OnboardingOverviewView(
        viewModel: vm
    )
}
