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
                if viewModel.state.isLoading {
                    // TODO: skeleton
                } else if let errorMessage = viewModel.state.errorMessage {
                    BaseErrorContentView(
                        errorMessage: errorMessage,
                        refreshAction: {
                            viewModel.onIntent(.refresh)
                        },
                        fixedTopPadding: 150
                    )
                } else {
                    VStack(spacing: Constants.Spacing.xMedium) {
                        PlantImagesView(
                            images: viewModel.state.plant?.images ?? []
                        )
                        
                        VStack(spacing: Constants.Spacing.large) {
                            PlantDetailInfoRow(
                                plantName: viewModel.state.plant?.name ?? "",
                                roomName: viewModel.state.roomName,
                                trackProgressAction: {
                                    viewModel.onIntent(.toggleImageActionSheet)
                                }
                            )
                            
                            SectionPicker(
                                selectedOption: Binding<PlantDetailViewModel.SectionPickerOption> (
                                    get: { viewModel.selectedSection },
                                    set: { selectedSection in
                                        viewModel.onIntent(.selectedSectionChanged(selectedSection))
                                    }
                                ),
                                options: PlantDetailViewModel.SectionPickerOption.allCases
                            ) { option in
                                Text(option.sectionTitle)
                            }
                            
                            switch viewModel.selectedSection {
                            case .tasks:
                                if let tasksConfiguartions = viewModel.state.plant?.settings.tasksConfiguartions {
                                    TaskQuickActionList(
                                        taskConfigurations: tasksConfiguartions,
                                        action: { taskType in
                                            viewModel.onIntent(.completeTask(taskType: taskType))
                                        }
                                    )
                                }
                                
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
                                            viewModel.onIntent(.completeTask(taskType: plantTask.taskType))
                                        }
                                    }
                                )
                            case .calendar:
                                Text("Calendar")
                            }
                        }
                        .padding(.bottom, Constants.Spacing.xLarge)
                        .padding(.horizontal)
                    }
                }
            }
            
            PlantDetailHeaderView(
                hasError: viewModel.state.errorMessage != nil,
                isLoading: viewModel.state.isLoading,
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
