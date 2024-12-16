//
//  PlantsOverviewViewModel.swift
//  Plants
//
//  Created by Lucia Cahojova on 13.12.2024.
//

import Foundation
import Resolver
import SharedDomain
import UIToolkit
import UIKit
import SwiftUI

final class PlantsOverviewViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    @Injected private var uploadImageUseCase: UploadImageUseCase
    @Injected private var getCurrentUserLocallyUseCase: GetCurrentUserLocallyUseCase
    @Injected private var hasCameraAccessUseCase: HasCameraAccessUseCase
    @Injected private var hasPhotoLibraryAccessUseCase: HasPhotoLibraryAccessUseCase
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    // MARK: - Init

    init(
        flowController: FlowController?
    ) {
        self.flowController = flowController
        super.init()
    }
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
        
        updateTitle()
        loadData()
    }
    
    // MARK: - Tab selection
    
    enum SectionPickerOption: CaseIterable {
        case plants
        case rooms
        case tasks

        var title: String {
            switch self {
            case .plants: Strings.plantsTitleWithEmoji
            case .rooms: Strings.roomsTitleWithEmoji
            case .tasks: Strings.tasksTitleWithEmoji
            }
        }
        
        var sectionTitle: String {
            switch self {
            case .plants: Strings.plantsTitle
            case .rooms: Strings.roomsTitle
            case .tasks: Strings.tasksTitle
            }
        }
    }
    
    // MARK: - State
    
    @Published private(set) var state: State = State()
    @Published private(set) var selectedSection: SectionPickerOption = .plants {
        didSet {
            updateTitle()
        }
    }

    struct State {
        var userId: String?
        
        var images: [UIImage] = []
        
        var selectedPlantId: UUID?
        
        var alertData: AlertData?
        var snackbarData: SnackbarData?
        
        var isCameraPickerPresented = false
        var isImagePickerPresented = false
        var isImageSheetPresented = false
    }
    
    // MARK: - Intent
    enum Intent {
        case completeTaskForRoom(roomId: UUID, taskType: TaskType)
        case completeTaskForPlant(plantId: UUID, taskType: TaskType)
        
        case toggleImageActionSheet
        case toggleCameraPicker
        case toggleImagePicker
        
        case plusButtonTapped
        
        case showPlantDetail(plantId: UUID)
        case showRoomDetail(roomId: UUID)
        
        case uploadImage(UIImage?)
        case uploadImages([UIImage])
        
        case alertDataChanged(AlertData?)
        case snackbarDataChanged(SnackbarData?)
        
        case selectedSectionChanged(SectionPickerOption)
        case selectedPlantIdChanged(UUID)
    }

    func onIntent(_ intent: Intent) {
        switch intent {
        case let .completeTaskForRoom(roomId, taskType): completeTaskForRoom(roomId: roomId, taskType: taskType)
        case let .completeTaskForPlant(plantId, taskType): completeTaskForPlant(plantId: plantId, taskType: taskType)
        case .toggleImageActionSheet: toggleImageActionSheet()
        case .toggleCameraPicker: toggleCameraPicker()
        case .toggleImagePicker: toggleImagePicker()
        case .plusButtonTapped: plusButtonTapped()
        case .showPlantDetail(let plantId): showPlantDetail(plantId)
        case .showRoomDetail(let roomId): showRoomDetail(roomId)
        case .uploadImage(let image): uploadImage(image)
        case .uploadImages(let images): uploadImages(images)
        case .snackbarDataChanged(let snackbarData): snackbarDataChanged(snackbarData)
        case .alertDataChanged(let alertData): alertDataChanged(alertData)
        case .selectedSectionChanged(let selectedSection): selectedSectionChanged(selectedSection)
        case .selectedPlantIdChanged(let id): selectedPlantIdChanged(id)
        }
    }
    
    private func completeTaskForRoom(roomId: UUID, taskType: TaskType) {
        #warning("TODO: Add UC")
    }
    
    private func completeTaskForPlant(plantId: UUID, taskType: TaskType) {
        #warning("TODO: Add UC")
    }
    
    private func toggleCameraPicker() {
        let hasCameraAccessUseCase = hasCameraAccessUseCase
        executeTask(
            Task {
                do {
                    try await hasCameraAccessUseCase.execute()
                    state.isCameraPickerPresented.toggle()
                } catch {
                    state.alertData = .init(
                        title: "No Camera access", // TODO: Strings
                        message: "To continue, grant access to your camera in Settings",
                        primaryAction: .init(
                            title: Strings.cancelButton,
                            style: .cancel,
                            completion: { [weak self] in
                                self?.dismissAlert()
                            }
                        ),
                        secondaryAction: .init(
                            title: "Settings",
                            completion: { [weak self] in
                                self?.flowController?.handleFlow(PlantsFlow.openSettings)
                            }
                        )
                    )
                }
            }
        )
    }
    
    private func toggleImageActionSheet() {
        state.isImageSheetPresented.toggle()
    }
    
    private func toggleImagePicker() {
        let hasPhotoLibraryAccessUseCase = hasPhotoLibraryAccessUseCase
        executeTask(
            Task {
                do {
                    try await hasPhotoLibraryAccessUseCase.execute()
                    state.isImagePickerPresented.toggle()
                } catch {
                    state.alertData = .init(
                        title: "No Photos access", // TODO: Strings
                        message: "To continue, grant access to Photos in Settings",
                        primaryAction: .init(
                            title: Strings.cancelButton,
                            style: .cancel,
                            completion: { [weak self] in
                                self?.dismissAlert()
                            }
                        ),
                        secondaryAction: .init(
                            title: "Settings",
                            completion: { [weak self] in
                                self?.flowController?.handleFlow(PlantsFlow.openSettings)
                            }
                        )
                    )
                }
            }
        )
    }
    
    private func alertDataChanged(_ alertData: AlertData?) {
        state.alertData = alertData
    }
    
    private func plusButtonTapped() {
        switch selectedSection {
        case .plants:
            flowController?.handleFlow(
                PlantsFlow.showAddPlant(
                    editingId: nil,
                    onShouldRefresh: {
                        #warning("TODO: Add refresh")
                    }
                )
            )
        case .rooms:
            flowController?.handleFlow(
                PlantsFlow.showAddRoom(
                    editingId: nil,
                    onShouldRefresh: {
                        #warning("TODO: Add refresh")
                    }
                )
            )
        case .tasks:
            flowController?.handleFlow(
                PlantsFlow.presentAddTask(
                    editingId: nil,
                    onShouldRefresh: {
                        #warning("TODO: Add refresh")
                    }
                )
            )
        }
    }
    
    private func uploadImages(_ images: [UIImage]) {
        let uploadImageUseCase = uploadImageUseCase
        
        for image in images {
            executeTask(
                Task {
                    defer { state.selectedPlantId = nil }
                    
                    guard let data = image.jpegData(compressionQuality: 1),
                          let userId = state.userId else {
                        setFailedToUploadImageSnackbar()
                        return
                    }
                    
                    do {
                        let url = try await uploadImageUseCase.execute(
                            userId: userId,
                            imageId: UUID().uuidString,
                            imageData: data
                        )
                        
                        print("New url: \(url)")
                    } catch {
                        setFailedToUploadImageSnackbar()
                    }
                }
            )
        }
    }
    
    private func uploadImage(_ image: UIImage?) {
        guard let image else {
            setFailedToUploadImageSnackbar()
            return
        }
        
        uploadImages([image])
    }
    
    private func snackbarDataChanged(_ snackbarData: SnackbarData?) {
        state.snackbarData = snackbarData
    }
    
    private func selectedSectionChanged(_ selectedSection: SectionPickerOption) {
        self.selectedSection = selectedSection
    }
    
    private func selectedPlantIdChanged(_ id: UUID) {
        state.selectedPlantId = id
    }
    
    private func dismissAlert() {
        state.alertData = nil
    }
    
    private func showPlantDetail(_ plantId: UUID) {
        flowController?.handleFlow(PlantsFlow.showPlantDetail(plantId))
    }
    
    private func showRoomDetail(_ roomId: UUID) {
        flowController?.handleFlow(PlantsFlow.showRoomDetail(roomId))
    }
    
    private func loadData() {
        guard let user = try? getCurrentUserLocallyUseCase.execute() else {
            return
        }
        state.userId = user.id
    }
        
    private func updateTitle() {
        flowController?.navigationController.viewControllers.first?.title = selectedSection.title
        self.flowController?.navigationController.tabBarItem.title = nil
    }
    
    private func setFailedToUploadImageSnackbar() {
        state.snackbarData = .init(
            message: "Failed to upload image",
            bottomPadding: Constants.Spacing.mediumLarge,
            alignment: .bottom,
            foregroundColor: Colors.white,
            backgroundColor: Colors.red
        )
    }
}
