//
//  PlantDetailViewModel.swift
//  Plants
//
//  Created by Lucia Cahojova on 30.12.2024.
//

import Foundation
import Resolver
import SharedDomain
import UIKit
import UIToolkit

final class PlantDetailViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    @Injected private var getCurrentUserLocallyUseCase: GetCurrentUserLocallyUseCase
    
    @Injected private var getPlantUseCase: GetPlantUseCase
    
    @Injected private var uploadImageUseCase: UploadImageUseCase
    @Injected private var updatePlantImagesUseCase: UpdatePlantImagesUseCase
    @Injected private var prepareImagesForSharingUseCase: PrepareImagesForSharingUseCase
    
    @Injected private var hasCameraAccessUseCase: HasCameraAccessUseCase
    @Injected private var hasPhotoLibraryAccessUseCase: HasPhotoLibraryAccessUseCase
    
    @Injected private var completeTaskUseCase: CompleteTaskUseCase
    @Injected private var deleteTaskForPlantUseCase: DeleteTaskForPlantUseCase
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    
    // MARK: - Init

    init(
        flowController: FlowController?,
        plantId: UUID
    ) {
        self.flowController = flowController
        
        super.init()
        
        loadData(plantId: plantId)
    }
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
    }
    
    // MARK: - State
    
    @Published private(set) var state: State = State()

    struct State {
        var userId: String?
        
        var plant: Plant?
        
        var isLoading: Bool = false
        
        var snackbarData: SnackbarData?
        var alertData: AlertData?
        var errorMessage: String?
        
        var isCameraPickerPresented = false
        var isImagePickerPresented = false
        var isImageSheetPresented = false
    }
    
    // MARK: - Intent
    enum Intent {
        case snackbarDataChanged(SnackbarData?)
        case alertDataChanged(AlertData?)
        
        case refresh
        
        case toggleImageActionSheet
        case toggleCameraPicker
        case toggleImagePicker
        case dismissCameraPicker
        case dismissImagePicker
        
        case uploadImage(UIImage?)
        case uploadImages([UIImage])
        case shareImages
        
        case completeTaskForPlant(plant: Plant, taskType: TaskType)
    }

    func onIntent(_ intent: Intent) {
        switch intent {
        case .snackbarDataChanged(let snackbarData): snackbarDataChanged(snackbarData)
        case .alertDataChanged(let alertData): alertDataChanged(alertData)
        case .refresh: refresh()
        case .toggleImageActionSheet: toggleImageActionSheet()
        case .toggleCameraPicker: toggleCameraPicker()
        case .toggleImagePicker: toggleImagePicker()
        case .dismissCameraPicker: dismissCameraPicker()
        case .dismissImagePicker: dismissImagePicker()
        case .uploadImage(let image): uploadImage(image)
        case .uploadImages(let images): uploadImages(images)
        case .shareImages: shareImages()
        case let .completeTaskForPlant(plant, taskType): completeTaskForPlant(plant: plant, taskType: taskType)
        }
    }
    
    private func shareImages() {
        guard let images = state.plant?.images else { return }
        let prepareImagesForSharingUseCase = prepareImagesForSharingUseCase
        
        executeTask(
            Task {
                state.snackbarData = .init(message: "Preparing...", duration: 30) // TODO: Strings
                
                do {
                    let imagesToShare = try await prepareImagesForSharingUseCase.execute(images: images)
                    state.snackbarData = nil
                    
                    flowController?.handleFlow(
                        PlantsFlow.presentShareImages(
                            images: imagesToShare,
                            onShareSuccess: {
                                self.state.snackbarData = .init(message: "Success!")
                            }
                        )
                    )
                } catch {
                    setFailedSnackbarData(message: "Failed to prepare images.")// TODO: Strings
                }
            }
        )
    }
    
    private func completeTaskForPlant(plant: Plant, taskType: TaskType, shouldRefresh: Bool = false) {
        let completeTaskUseCase = completeTaskUseCase
        let deleteTaskForPlantUseCase = deleteTaskForPlantUseCase
        
        executeTask(
            Task {
                do {
                    try await completeTaskUseCase.execute(
                        for: plant,
                        taskType: taskType,
                        completionDate: Date()
                    )
                    
                    if shouldRefresh {
                        loadData(plantId: plant.id)
                    } else {
                        state.snackbarData = .init(
                            message: Strings.taskCompletedSnackbarMessage(TaskType.title(for: taskType)),
                            actionText: Strings.undoButton,
                            action: {
                                Task {
                                    try? await deleteTaskForPlantUseCase.execute(plant: plant, taskType: taskType)
                                }
                            }
                        )
                    }
                } catch {
                    setFailedSnackbarData(message: Strings.taskCompleteFailedSnackbarMessage)
                }
            }
        )
    }
    
    private func uploadImages(_ images: [UIImage]) {
        let uploadImageUseCase = uploadImageUseCase
        let updatePlantImagesUseCase = updatePlantImagesUseCase

        guard let plantId = state.plant?.id else { return }
        
        executeTask(
            Task {
                var newImageData: [ImageData] = []
                
                for image in images {
                    do {
                        guard let data = image.jpegData(compressionQuality: 1), let userId = state.userId else {
                            continue
                        }
                        
                        let url = try await uploadImageUseCase.execute(
                            userId: userId,
                            imageId: UUID().uuidString,
                            imageData: data
                        )
                        
                        let newImage = ImageData(id: UUID(), date: Date(), urlString: url.absoluteString)
                        newImageData.append(newImage)
                        
                        try await updatePlantImagesUseCase.execute(
                            plantId: plantId,
                            newImages: newImageData
                        )
                        
                        state.snackbarData = .init(message: Strings.progressSavedSnackbarMessage)
                    } catch {
                        setFailedSnackbarData(message: Strings.imageUploadFailedSnackbarMessage)
                    }
                }
            }
        )
    }
    
    private func uploadImage(_ image: UIImage?) {
        guard let image else {
            setFailedSnackbarData(message: Strings.imageUploadFailedSnackbarMessage)
            return
        }
        
        uploadImages([image])
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
                        title: Strings.noCameraAccessAlertTitle,
                        message: Strings.cameraPermissionAlertMessage,
                        primaryAction: .init(
                            title: Strings.cancelButton,
                            style: .cancel,
                            completion: { [weak self] in
                                self?.dismissAlert()
                            }
                        ),
                        secondaryAction: .init(
                            title: Strings.settingsButton,
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
                        title: Strings.noPhotosAccessAlertTitle,
                        message: Strings.photosPermissionAlertMessage,
                        primaryAction: .init(
                            title: Strings.cancelButton,
                            style: .cancel,
                            completion: { [weak self] in
                                self?.dismissAlert()
                            }
                        ),
                        secondaryAction: .init(
                            title: Strings.settingsButton,
                            completion: { [weak self] in
                                self?.flowController?.handleFlow(PlantsFlow.openSettings)
                            }
                        )
                    )
                }
            }
        )
    }
    
    private func dismissCameraPicker() {
        state.isCameraPickerPresented = false
    }
    
    private func dismissImagePicker() {
        state.isImagePickerPresented = false
    }
    
    private func openPlantDetail(plantId: UUID) {
        flowController?.handleFlow(PlantsFlow.showPlantDetail(plantId))
    }
    
    private func refresh() {
        guard let plantId = state.plant?.id else {
            setFailedSnackbarData(message: Strings.defaultErrorMessage)
            return
        }
        
        loadData(plantId: plantId)
    }
    
    private func dismissAlert() {
        state.alertData = nil
    }
    
    private func alertDataChanged(_ alertData: AlertData?) {
        state.alertData = alertData
    }
    
    private func snackbarDataChanged(_ snackbarData: SnackbarData?) {
        state.snackbarData = snackbarData
    }
    
    private func loadData(plantId: UUID) {
        state.isLoading = true
        loadUser()
        
        let getPlantUseCase = getPlantUseCase
        executeTask(
            Task {
                defer { state.isLoading = false }
                
                do {
                    state.plant = try await getPlantUseCase.execute(id: plantId)
                } catch {
                    state.errorMessage = Strings.dataLoadFailedSnackbarMessage
                }
            }
        )
    }
    
    private func setFailedSnackbarData(message: String) {
        state.snackbarData = .init(
            message: message,
            foregroundColor: Colors.white,
            backgroundColor: Colors.red
        )
    }
    
    private func loadUser() {
        guard let user = try? getCurrentUserLocallyUseCase.execute() else {
            return
        }
        state.userId = user.id
    }
}
