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
                            // TODO: implementation
                        },
                        showSettingsAction: {
                            // TODO: implementation
                        },
                        shareAction: {
                            // TODO: implementation
                        }
                    )
                    .background(isTransparent ? .clear : Colors.primaryBackground)
                }
            }
        }
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
