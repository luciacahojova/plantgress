//
//  RoomDetailViewModel.swift
//  Plants
//
//  Created by Lucia Cahojova on 30.12.2024.
//

import Foundation
import Resolver
import SharedDomain
import UIKit
import UIToolkit

final class RoomDetailViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    @Injected private var getCurrentUserLocallyUseCase: GetCurrentUserLocallyUseCase
    
    @Injected private var getRoomUseCase: GetRoomUseCase
    @Injected private var getPlantsForRoomUseCase: GetPlantsForRoomUseCase
    
    @Injected private var uploadImageUseCase: UploadImageUseCase
    @Injected private var updatePlantImagesUseCase: UpdatePlantImagesUseCase
    
    @Injected private var hasCameraAccessUseCase: HasCameraAccessUseCase
    @Injected private var hasPhotoLibraryAccessUseCase: HasPhotoLibraryAccessUseCase
    
    @Injected private var completeTaskUseCase: CompleteTaskUseCase
    @Injected private var deleteTaskForPlantUseCase: DeleteTaskForPlantUseCase
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    private let roomId: UUID
    
    // MARK: - Init

    init(
        flowController: FlowController?,
        roomId: UUID
    ) {
        self.flowController = flowController
        self.roomId = roomId
        super.init()
        
        loadData()
    }
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
    }
    
    // MARK: - State
    
    @Published private(set) var state: State = State()

    struct State {
        var userId: String?
        
        var room: Room?
        var plants: [Plant] = []
        
        var isLoading: Bool = false
        
        var selectedPlantId: UUID?
        
        var snackbarData: SnackbarData?
        var alertData: AlertData?
        var errorMessage: String?
        
        var isCameraPickerPresented = false
        var isImagePickerPresented = false
        var isImageSheetPresented = false
    }
    
    // MARK: - Intent
    enum Intent {
        case editRoom
        case showPlantDetail(plantId: UUID)
        
        case snackbarDataChanged(SnackbarData?)
        case alertDataChanged(AlertData?)
        
        case refresh
        
        case toggleImageActionSheet
        case toggleCameraPicker
        case toggleImagePicker
        case dismissCameraPicker
        case dismissImagePicker
        
        case selectedPlantIdChanged(UUID)
        
        case uploadImage(UIImage?)
        case uploadImages([(Date, UIImage)])
        
        case completeTaskForPlant(plant: Plant, taskType: TaskType)
    }

    func onIntent(_ intent: Intent) {
        switch intent {
        case .editRoom: editRoom()
        case .showPlantDetail(let plantId): showPlantDetail(plantId: plantId)
        case .snackbarDataChanged(let snackbarData): snackbarDataChanged(snackbarData)
        case .alertDataChanged(let alertData): alertDataChanged(alertData)
        case .refresh: refresh()
        case .toggleImageActionSheet: toggleImageActionSheet()
        case .toggleCameraPicker: toggleCameraPicker()
        case .toggleImagePicker: toggleImagePicker()
        case .dismissCameraPicker: dismissCameraPicker()
        case .dismissImagePicker: dismissImagePicker()
        case .selectedPlantIdChanged(let id): selectedPlantIdChanged(id)
        case .uploadImage(let image): uploadImage(image)
        case .uploadImages(let images): uploadImages(images)
        case let .completeTaskForPlant(plant, taskType): completeTaskForPlant(plant: plant, taskType: taskType)
        }
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
                        loadData()
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
    
    private func uploadImages(_ images: [(Date, UIImage)]) {
        let uploadImageUseCase = uploadImageUseCase
        let updatePlantImagesUseCase = updatePlantImagesUseCase

        guard let selectedPlantId = state.selectedPlantId else { return }
        
        executeTask(
            Task {
                defer { state.selectedPlantId = nil }
                var newImageData: [ImageData] = []
                
                for (date, image) in images {
                    do {
                        guard let data = image.jpegData(compressionQuality: 1),
                              let userId = state.userId else {
                            continue
                        }
                        
                        let url = try await uploadImageUseCase.execute(
                            userId: userId,
                            imageId: UUID().uuidString,
                            imageData: data
                        )
                        
                        let newImage = ImageData(
                            id: UUID(),
                            date: date,
                            urlString: url.absoluteString
                        )
                        newImageData.append(newImage)
                        
                        try await updatePlantImagesUseCase.execute(
                            plantId: selectedPlantId,
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
        
        uploadImages([(Date(), image)])
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
    
    private func selectedPlantIdChanged(_ id: UUID) {
        state.selectedPlantId = id
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
    
    private func editRoom() {
        flowController?.handleFlow(
            PlantsFlow.showAddRoom(
                editingId: state.room?.id,
                onShouldRefresh: {
                    self.refresh()
                },
                onDelete: {
                    self.flowController?.handleFlow(PlantsFlow.pop)
                }
            )
        )
    }
    
    private func showPlantDetail(plantId: UUID) {
        flowController?.handleFlow(PlantsFlow.showPlantDetail(plantId))
    }
    
    private func refresh() {
        loadData()
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
    
    private func loadData() {
        state.isLoading = true
        loadUser()
        
        let getRoomUseCase = getRoomUseCase
        let getPlantsForRoomUseCase = getPlantsForRoomUseCase
        executeTask(
            Task {
                defer { state.isLoading = false }
                
                do {
                    state.room = try await getRoomUseCase.execute(roomId: roomId)
                    state.plants = try await getPlantsForRoomUseCase.execute(roomId: roomId)
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
