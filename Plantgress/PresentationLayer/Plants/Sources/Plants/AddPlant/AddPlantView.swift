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
    var body: some View {
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
                    )
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
                    )
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
                    // TODO
                    print("disabled")
                }
                .disabled(!viewModel.state.isCreateButtonEnabled)
            }
        }
        .foregroundStyle(Colors.primaryText)
        .lifecycle(viewModel)
    }
    
    @ViewBuilder
    private func taskSection(taskType: TaskType) -> some View {
        if let taskConfiguration = viewModel.state.tasks[taskType] {
            VStack(spacing: 0) {
                ToggleListRow(
                    isToggleOn: Binding(
                        get: { taskConfiguration.isTracked },
                        set: { isTracked in
                            viewModel.onIntent(.updateTaskProperty(taskType, .isTracked(isTracked)))
                        }
                    ),
                    title: TaskType.title(for: taskType),
                    rowLevel: .primary,
                    isLast: false,
                    icon: TaskType.icon(for: taskType)
                )
                
                if taskConfiguration.isTracked {
                    ToggleListRow(
                        isToggleOn: Binding(
                            get: { taskConfiguration.hasNotifications },
                            set: { hasNotifications in
                                viewModel.onIntent(.updateTaskProperty(taskType, .hasNotifications(hasNotifications)))
                            }
                        ),
                        title: "Notifications", // TODO: Strings
                        rowLevel: .secondary,
                        isLast: false,
                        icon: Icons.alarmClock
                    )
                    
                    if taskConfiguration.hasNotifications {
                        CalendarListRow(
                            date: Binding(
                                get: { taskConfiguration.startDate },
                                set: { newDate in
                                    viewModel.onIntent(.updateTaskProperty(taskType, .startDate(newDate)))
                                }
                            ),
                            datePickerComponents: .date,
                            rowLever: .secondary,
                            isLast: false
                        )
                        
                        ButtonListRow(
                            title: "Repeat",
                            rowLevel: .secondary,
                            isLast: true,
                            text: taskConfiguration.periods.first?.name ?? "None",
                            leadingIcon: Icons.refresh,
                            trailingIcon: Asset.Icons.chevronSelectorVertical.image,
                            action: {
                                // Open repeat settings
                            }
                        )
                    }
                }
            }
            .animation(.easeInOut, value: taskConfiguration.isTracked)
            .animation(.easeInOut, value: taskConfiguration.hasNotifications)
        }
    }
    
    @ViewBuilder
    private func plantProgressSection() -> some View {
        BaseList(title: "Plant Progress") {
            if let taskConfiguration = viewModel.state.tasks[.progressTracking] {
                VStack(spacing: 0) {
                    ToggleListRow(
                        isToggleOn: Binding(
                            get: { taskConfiguration.isTracked },
                            set: { isTracked in
                                viewModel.onIntent(.updateTaskProperty(.progressTracking, .isTracked(isTracked)))
                            }
                        ),
                        title: "Track Progress",
                        rowLevel: .primary,
                        isLast: false,
                        icon: TaskType.icon(for: .progressTracking)
                    )
                    
                    if taskConfiguration.isTracked {
                        ToggleListRow(
                            isToggleOn: Binding(
                                get: { taskConfiguration.hasNotifications },
                                set: { hasNotifications in
                                    viewModel.onIntent(.updateTaskProperty(.progressTracking, .hasNotifications(hasNotifications)))
                                }
                            ),
                            title: "Notifications",
                            rowLevel: .secondary,
                            isLast: false,
                            icon: Icons.alarmClock
                        )
                        
                        if taskConfiguration.hasNotifications {
                            CalendarListRow(
                                date: Binding(
                                    get: { taskConfiguration.startDate },
                                    set: { newDate in
                                        viewModel.onIntent(.updateTaskProperty(.progressTracking, .startDate(newDate)))
                                    }
                                ),
                                datePickerComponents: .date,
                                rowLever: .secondary,
                                isLast: false
                            )
                            
                            ButtonListRow(
                                title: "Repeat",
                                rowLevel: .secondary,
                                isLast: true,
                                text: taskConfiguration.periods.first?.name ?? "None",
                                leadingIcon: Icons.refresh,
                                trailingIcon: Icons.chevronSelectorVertical,
                                action: {
                                    // TODO:
                                }
                            )
                        }
                    }
                }
                .animation(.easeInOut, value: taskConfiguration.isTracked)
                .animation(.easeInOut, value: taskConfiguration.hasNotifications)
            }
        }
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
