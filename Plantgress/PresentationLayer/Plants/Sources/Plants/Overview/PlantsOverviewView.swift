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

struct PlantsOverviewView: View { // TODO: Loading
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: PlantsOverviewViewModel
    
    private let images: [UIImage] = []

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
                                viewModel.onIntent(.selectedPlantIdChanged(plantId))
                                viewModel.onIntent(.toggleImageActionSheet)
                            },
                            trackTaskAction: { plantId, taskType in
                                viewModel.onIntent(.trackTaskForPlant(plantId: plantId, taskType: taskType))
                            }
                        )
                    case .rooms:
                        RoomList(
                            rooms: .mock, // TODO: Actual data
                            trackTaskAction: { roomId, taskType in
                                viewModel.onIntent(.trackTaskForRoom(roomId: roomId, taskType: taskType))
                            }
                        )
                    case .tasks:
                        TaskList(
                            tasks: .mock, // TODO: Actual data
                            editTaskAction: { taskId in
                                
                            },
                            deleteTaskAction: { taskId in
                                
                            },
                            completeTaskAction: { taskId in
                                
                            }
                        )
                    }
                }
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.onIntent(.plusButtonTapped)
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
            set: { _ in viewModel.onIntent(.toggleImagePicker) }
        )) {
            ImagePicker(
                images: Binding<[UIImage]>(
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
            set: { _ in viewModel.onIntent(.toggleCameraPicker) }
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
    
    let vm = PlantsOverviewViewModel(flowController: nil)
    
    return PlantsOverviewView(viewModel: vm)
}
