//
//  AddPlantView.swift
//  Plants
//
//  Created by Lucia Cahojova on 23.12.2024.
//

import Resolver
import SharedDomain
import SwiftUI
import UIToolkit

struct AddPlantView: View {
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: AddPlantViewModel
    
    private let images: [UIImage] = []
    
    // MARK: - Init
    
    init(viewModel: AddPlantViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    var body: some View { // TODO: Delete plant
        ScrollView(showsIndicators: false) {
            VStack(spacing: Constants.Spacing.mediumLarge) {
                VStack(alignment: .leading, spacing: Constants.Spacing.small) {
                    Text("Name") // TODO: String
                        .textCase(.uppercase)
                        .padding(.leading, Constants.Spacing.medium)
                        .font(Fonts.calloutSemibold)
                        .foregroundStyle(Colors.secondaryText)
                    
                    OutlinedTextField(
                        text: Binding<String>(
                            get: { viewModel.state.name },
                            set: { newName in viewModel.onIntent(.nameChanged(newName))}
                        ),
                        placeholder: "Plant name", // TODO: String
                        backgroundColor: Colors.secondaryBackground,
                        cornerRadius: Constants.List.cornerRadius,
                        deleteTextAction: {
                            viewModel.onIntent(.nameChanged(""))
                        }
                    )
                }
                .padding(.horizontal)
                    
                if !viewModel.state.isEditing {
                    AddPlantImagesView(
                        images: viewModel.state.uploadedImages,
                        addImageAction: {
                            viewModel.onIntent(.toggleImageActionSheet)
                        },
                        deleteImageAction: { imageId in // TODO: Implementation
                            viewModel.onIntent(.deleteImage(imageId))
                        }
                    )
                }
                
                BaseList(title: "Room") { // TODO: String
                    ButtonListRow(
                        title: viewModel.state.room?.name ?? "Select room",
                        isLast: true,
                        trailingIcon: Icons.chevronSelectorVertical,
                        action: {
                            viewModel.onIntent(.pickRoom)
                        }
                    )
                }
                .padding(.horizontal)
                
                ProgressSettingsView(
                    taskConfiguration: Binding(
                        get: { viewModel.state.tasks[.progressTracking]! },
                        set: { updatedTaskConfiguation in
                            viewModel.onIntent(.updateTask(.progressTracking, updatedTaskConfiguation))
                        }
                    ),
                    openPeriodSettingsAction: {
                        viewModel.onIntent(.showPeriodSettings(taskType: .progressTracking))
                    }
                )
                .padding(.horizontal)
                
                TasksSettingsView(
                    tasks: Binding(
                        get: { viewModel.state.tasks },
                        set: { updatedTaskConfigurations in
                            updatedTaskConfigurations.forEach { taskType, taskConfiguration in
                                viewModel.onIntent(.updateTask(taskType, taskConfiguration))
                            }
                        }
                    ),
                    openPeriodSettingsAction: { taskType in
                        viewModel.onIntent(.showPeriodSettings(taskType: taskType))
                    }
                )
                .padding(.horizontal)
            }
            .padding(.top)
            .padding(.bottom, Constants.Spacing.xxxLarge)
        }
        .edgesIgnoringSafeArea(.bottom)
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
            set: { _ in viewModel.onIntent(.dissmissCameraPicker) }
        )) {
            CameraPicker(
                selectedImage: { image in
                    viewModel.onIntent(.uploadImage(image))
                }
            )
            .ignoresSafeArea(edges: .all)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(viewModel.state.isEditing ? "Update" : "Add Plant") {
                    viewModel.onIntent(.createPlant)
                }
                .disabled(!viewModel.state.isCreateButtonEnabled)
            }
        }
        .foregroundStyle(Colors.primaryText)
        .lifecycle(viewModel)
    }
}

#Preview {
    Resolver.registerUseCasesForPreviews()
    
    let viewModel = AddPlantViewModel(
        flowController: nil,
        editingId: nil,
        onShouldRefresh: {}
    )
    
    return AddPlantView(
        viewModel: viewModel
    )
    .background(Colors.primaryBackground)
}
