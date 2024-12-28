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
    
    private let images: [UIImage] = []
    @State private var width: CGFloat? = nil

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
                    if viewModel.state.isLoading {
                        switch viewModel.selectedSection {
                        case .plants:
                            PlantList.skeleton
                        case .rooms:
                            RoomList.skeleton
                        case .tasks:
                            TaskList.skeleton
                        }
                    } else if let errorMessage = viewModel.state.errorMessage {
                        BaseErrorContentView(
                            errorMessage: errorMessage,
                            refreshAction: {
                                viewModel.onIntent(.refresh)
                            },
                            fixedTopPadding: 100
                        )
                    } else {
                        switch viewModel.selectedSection {
                        case .plants:
                            PlantList(
                                plants: viewModel.state.plants,
                                trackPlantProgressAction: { plantId in
                                    viewModel.onIntent(.selectedPlantIdChanged(plantId))
                                    viewModel.onIntent(.toggleImageActionSheet)
                                },
                                completeTaskAction: { plant, taskType in
                                    viewModel.onIntent(.completeTaskForPlant(plant: plant, taskType: taskType))
                                }
                            )
                        case .rooms:
                            RoomList(
                                rooms: viewModel.state.rooms,
                                completeTaskAction: { roomId, taskType in
                                    viewModel.onIntent(.completeTaskForRoom(roomId: roomId, taskType: taskType))
                                }
                            )
                        case .tasks:
                            TaskList(
                                upcomingTasks: viewModel.state.upcomingTasks,
                                completedTasks: viewModel.state.completedTasks, 
                                editTaskAction: { plantTask in
                                    viewModel.onIntent(.editTask(plantTask))
                                },
                                deleteTaskAction: { plantTask in
                                    viewModel.onIntent(.deleteTask(plantTask))
                                },
                                completeTaskAction: { plantTask in
                                    if plantTask.taskType == .progressTracking {
                                        viewModel.onIntent(.toggleImageActionSheet)
                                    } else {
                                        viewModel.onIntent(.completeTask(plantTask))
                                    }
                                }
                            )
                        }
                    }
                }
            }
            .padding([.top, .horizontal])
            .padding(.bottom, Constants.Spacing.xLarge)
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
            set: { _ in viewModel.onIntent(.dismissImagePicker) }
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
    
    let vm = PlantsOverviewViewModel(flowController: nil)
    
    return PlantsOverviewView(viewModel: vm)
}
