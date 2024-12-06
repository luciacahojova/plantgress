//
//  ProfileOverviewView.swift
//  Plants
//
//  Created by Lucia Cahojova on 03.12.2024.
//

import SwiftUI

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
