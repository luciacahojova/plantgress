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
    
    var body: some View { // TODO: Alert
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: Constants.Spacing.xxxLarge) {
                Button("Show Onboarding") {
                    viewModel.onIntent(.presentOnboarding(message: nil))
                }
                
                Button("Log Out") {
                    viewModel.onIntent(.logoutUser)
                }
                .buttonStyle(
                    PrimaryButtonStyle(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red
                    )
                )
            }
        }
        .padding(.horizontal)
        .padding(.top, Constants.Spacing.large)
        .padding(.bottom, Constants.Spacing.xxLarge)
        .lifecycle(viewModel)
    }
}

#Preview {
    let vm = ProfileOverviewViewModel(flowController: nil)
    
    ProfileOverviewView(
        viewModel: vm
    )
}
