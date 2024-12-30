//
//  RoomDetailView.swift
//  Plants
//
//  Created by Lucia Cahojova on 30.12.2024.
//

import Resolver
import SharedDomain
import SwiftUI
import UIToolkit

struct RoomDetailView: View {
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: RoomDetailViewModel
    
    // MARK: - Init
    
    init(viewModel: RoomDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                if viewModel.state.isLoading {
                    PlantList.skeleton
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
                        message: "There are no plants in this room.", // TODO: String
                        fixedTopPadding: 100
                    )
                } else {
                    PlantList(
                        plants: viewModel.state.plants,
                        trackPlantProgressAction: { _ in
                            // TODO
                        },
                        completeTaskAction: { _, _ in
                            // TODO
                        }
                    )
                }
            }
            .padding([.top, .horizontal])
            .padding(.bottom, Constants.Spacing.xLarge)
        }
        .navigationTitle(viewModel.state.room?.name ?? "")
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.onIntent(.editRoom)
                } label: {
                    Asset.Icons.edit.image
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                }
            }
        }
        .foregroundStyle(Colors.primaryText)
        .lifecycle(viewModel)
    }
}

#Preview {
    Resolver.registerUseCasesForPreviews()
    
    let vm = RoomDetailViewModel(
        flowController: nil,
        room: .mock(id: UUID())
    )
    
    return RoomDetailView(viewModel: vm)
}
