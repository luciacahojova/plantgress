//
//  SelectPlantsView.swift
//  Plants
//
//  Created by Lucia Cahojova on 30.12.2024.
//

import Resolver
import SharedDomain
import SwiftUI
import UIToolkit

struct SelectPlantsView: View {
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: SelectPlantsViewModel
    
    // MARK: - Init
    
    init(viewModel: SelectPlantsViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    viewModel.onIntent(.dismiss)
                } label: {
                    Text(Strings.discardButton)
                        .foregroundStyle(Colors.red)
                        .font(Fonts.bodyMedium)
                }
                
                Spacer()
                
                Button {
                    viewModel.onIntent(.save)
                } label: {
                    Text(Strings.pickButton)
                        .foregroundStyle(Colors.primaryText)
                        .font(Fonts.bodySemibold)
                }
            }
            .padding([.top, .horizontal])
            .padding(.bottom, Constants.Spacing.small)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: Constants.Spacing.mediumLarge) {
                    if viewModel.state.isLoading {
                        ForEach(0...3, id: \.self) { _ in
                            SelectionRow.skeleton
                        }
                    } else if let errorMessage = viewModel.state.errorMessage {
                        BaseErrorContentView(
                            errorMessage: errorMessage,
                            refreshAction: {
                                viewModel.onIntent(.refresh)
                            },
                            fixedTopPadding: 100
                        )
                    } else if viewModel.state.plants.isEmpty {
                        BaseEmptyContentView(
                            message: Strings.noPlantsEmptyContentMessage,
                            fixedTopPadding: 100
                        )
                    } else {
                        ForEach(viewModel.state.plants, id: \.id) { plant in
                            SelectionRow(
                                title: plant.name,
                                isSelected: viewModel.state.selectedPlants.contains(where: { $0.id == plant.id }),
                                actionType: .checkmark,
                                imageUrlString: plant.images.first?.urlString,
                                selectAction: {
                                    viewModel.onIntent(.selectPlant(plant))
                                }
                            )
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, Constants.Spacing.large)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .lifecycle(viewModel)
    }
}

#Preview {
    Resolver.registerUseCasesForPreviews()
    
    let vm = SelectPlantsViewModel(
        flowController: nil,
        selectedPlants: [],
        onSave: { _ in }
    )
    
    return SelectPlantsView(viewModel: vm)
}
