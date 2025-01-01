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
            VStack(spacing: Constants.Spacing.large) {
                ExtraToolRow(
                    title: "Diagnose Plants", // TODO: Strings
                    subtitle: "Diagnose plants to identify pests, diseases, or care issues and get solutions to help them thrive.",
                    image: Images.disease,
                    icon: Icons.doctorBag,
                    action: {
                        viewModel.onIntent(.showPlantDiagnostics)
                    }
                )
                
                ExtraToolRow(
                    title: "Luxmeter", // TODO: Strings
                    subtitle: "Use the Luxmeter to measure light levels and ensure your plants receive the optimal amount of light for healthy growth.",
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
