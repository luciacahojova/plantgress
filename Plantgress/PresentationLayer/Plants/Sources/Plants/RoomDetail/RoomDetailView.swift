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
    
    private let images: [(Date, UIImage)] = []
    
    // MARK: - Init
    
    init(viewModel: RoomDetailViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Body
    
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
                        message: Strings.noPlantsInRoomEmptyContentMessage,
                        fixedTopPadding: 100
                    )
                } else {
                    PlantList(
                        plants: viewModel.state.plants,
                        trackPlantProgressAction: { plantId in
                            viewModel.onIntent(.selectedPlantIdChanged(plantId))
                            viewModel.onIntent(.toggleImageActionSheet)
                        },
                        completeTaskAction: { plant, taskType in
                            viewModel.onIntent(.completeTaskForPlant(plant: plant, taskType: taskType))
                        },
                        openPlantDetailAction: { plantId in
                            viewModel.onIntent(.showPlantDetail(plantId: plantId))
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
        .actionSheet(isPresented: Binding<Bool>(
            get: { viewModel.state.isImageSheetPresented },
            set: { _ in viewModel.onIntent(.toggleImageActionSheet) }
        )) {
            ImagePickerActionSheet(
                cameraAction: {
                    viewModel.onIntent(.toggleCameraPicker)
                },
                libraryAction: {
                    viewModel.onIntent(.toggleImagePicker)
                }
            )
            .actionSheet
        }
        .sheet(isPresented: Binding<Bool>(
            get: { viewModel.state.isImagePickerPresented },
            set: { _ in viewModel.onIntent(.dismissImagePicker) }
        )) {
            ImagePicker(
                images: Binding<[(Date, UIImage)]>(
                    get: { images },
                    set: { images in
                        viewModel.onIntent(.uploadImages(images))
                    }
                )
            )
            .edgesIgnoringSafeArea(.bottom)
        }
        .fullScreenCover(isPresented: Binding<Bool>(
            get: { viewModel.state.isCameraPickerPresented },
            set: { _ in viewModel.onIntent(.dismissCameraPicker) }
        )) {
            CameraPicker(
                selectedImage: { image in
                    viewModel.onIntent(.uploadImage(image))
                }
            )
            .ignoresSafeArea(edges: .all)
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
