//
//  PlantDetailView.swift
//  Plants
//
//  Created by Lucia Cahojova on 30.12.2024.
//

import Resolver
import SharedDomain
import SwiftUI
import UIToolkit

struct PlantDetailView: View {
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: PlantDetailViewModel
    
    @State private var isTransparent: Bool = true
    
    private let images: [UIImage] = []
    
    // MARK: - Init
    
    init(viewModel: PlantDetailViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Body
    
    var body: some View {
        VStack {
            if viewModel.state.isLoading {
                // TODO: skeleton
            } else if let errorMessage = viewModel.state.errorMessage {
                // TODO: View
            } else {
                ZStack(alignment: .top) {
                    TrackableScrollView(
                        contentOffset: Binding<CGFloat>(
                            get: { .zero },
                            set: { value in
                                let newIsTransparent = value < Constants.Spacing.medium
                                guard newIsTransparent != isTransparent else { return }
                                withAnimation {
                                    isTransparent = newIsTransparent
                                }
                            }
                        )
                    ) {
                        VStack(spacing: Constants.Spacing.medium) {
                            PlantImagesView(
                                images: viewModel.state.plant?.images ?? []
                            )
                            
                            PlantDetailInfoRow(
                                plantName: viewModel.state.plant?.name ?? "",
                                roomName: "Living room", // TODO: take from state
                                trackProgressAction: {
                                    // TODO: implementation
                                }
                            )
                            .padding(.horizontal)
                            
                            // TODO: sections
                        }
                    }
                    
                    PlantDetailHeaderView(
                        navigateBackAction: {
                            viewModel.onIntent(.navigateBack)
                        },
                        showSettingsAction: {
                            viewModel.onIntent(.showPlantSettings)
                        },
                        shareAction: {
                            viewModel.onIntent(.shareImages)
                        }
                    )
                    .background(isTransparent ? .clear : Colors.primaryBackground.opacity(0.9))
                }
            }
        } // TODO: Bind snackbar
        .snackbar(
            Binding<SnackbarData?>(
                get: { viewModel.state.snackbarData },
                set: { snackbarData in viewModel.onIntent(.snackbarDataChanged(snackbarData)) }
            )
        )
        .edgesIgnoringSafeArea(.top)
        .foregroundStyle(Colors.primaryText)
        .lifecycle(viewModel)
    }
}

#Preview {
    Resolver.registerUseCasesForPreviews()
    
    let vm = PlantDetailViewModel(
        flowController: nil,
        plantId: UUID()
    )
    
    return PlantDetailView(
        viewModel: vm
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Colors.primaryBackground)
}
