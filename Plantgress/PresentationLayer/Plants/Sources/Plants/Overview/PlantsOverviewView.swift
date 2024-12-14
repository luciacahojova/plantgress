//
//  PlantsOverviewView.swift
//  Plants
//
//  Created by Lucia Cahojova on 03.12.2024.
//

import Resolver
import SharedDomain
import SwiftUI
import UIToolkit

struct PlantsOverviewView: View {
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: PlantsOverviewViewModel
    
    // MARK: - Init
    
    init(viewModel: PlantsOverviewViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Constants.Spacing.xLarge) {
                SectionPicker(
                    selectedOption: Binding<PlantsOverviewViewModel.SectionPickerOption> (
                        get: { viewModel.selectedSection },
                        set: { selectedSection in
                            viewModel.onIntent(.selectedSectionChanged(selectedSection))
                        }
                    ),
                    options: PlantsOverviewViewModel.SectionPickerOption.allCases
                ) { option in
                    Text(option.sectionTitle)
                }
                
                VStack(spacing: Constants.Spacing.large) {
                    switch viewModel.selectedSection {
                    case .plants:
                        PlantList(
                            plants: .mock, // TODO: Actual data
                            trackPlantProgressAction: { plantId in
                                // TODO: Image picker
                            },
                            trackTaskAction: { taskType in
                                // TODO: Add task + show snackbar
                            }
                        )
                    case .rooms:
                        Text("Room")
                        Text("Room")
                        Text("Room")
                    case .tasks:
                        Text("Task")
                        Text("Task")
                        Text("Task")
                    }
                }
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Asset.Icons.plus.image
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                }
            }
        }
        .alert(item: Binding<AlertData?>(
            get: { viewModel.state.alertData },
            set: { alertData in
                viewModel.onIntent(.alertDataChanged(alertData))
            }
        )) { alert in .init(alert) }
        .snackbar(
            Binding<SnackbarData?>(
                get: { viewModel.state.snackbarData },
                set: { snackbarData in viewModel.onIntent(.snackbarDataChanged(snackbarData)) }
            )
        )
        .foregroundStyle(Colors.primaryText)
        .lifecycle(viewModel)
    }
}

#Preview {
    Resolver.registerUseCasesForPreviews()
    
    let vm = PlantsOverviewViewModel(flowController: nil)
    
    return PlantsOverviewView(viewModel: vm)
}
