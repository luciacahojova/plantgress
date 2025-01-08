//
//  ExploreOverviewView.swift
//  Plants
//
//  Created by Lucia Cahojova on 03.12.2024.
//

import SwiftUI
import UIToolkit

struct ExploreOverviewView: View {
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: ExploreOverviewViewModel
    
    // MARK: - Init
    
    init(viewModel: ExploreOverviewViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: Constants.Spacing.large) {
                ExtraToolRow(
                    title: Strings.diagnoseTitle,
                    subtitle: Strings.diagnoseSubtitle,
                    image: Images.disease,
                    icon: Icons.doctorBag,
                    action: {
                        viewModel.onIntent(.showPlantDiagnostics)
                    }
                )
                
                ExtraToolRow(
                    title: Strings.luxmeterTitle,
                    subtitle: Strings.luxmeterSubtitle,
                    image: Images.luxmeter,
                    icon: Icons.lightbulb,
                    action: {
                        viewModel.onIntent(.showLuxmeter)
                    }
                )
            }
            .padding()
        }
        .lifecycle(viewModel)
    }
}

#Preview {
    let vm = ExploreOverviewViewModel(flowController: nil)
    
    return ExploreOverviewView(viewModel: vm)
        .background(Colors.primaryBackground)
}
