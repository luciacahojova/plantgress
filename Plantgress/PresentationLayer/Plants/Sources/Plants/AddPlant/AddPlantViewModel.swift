//
//  AddPlantViewModel.swift
//  Plants
//
//  Created by Lucia Cahojova on 23.12.2024.
//

import Foundation
import Resolver
import SharedDomain
import UIToolkit
import UIKit

final class AddPlantViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    @Injected private var getCurrentUserLocallyUseCase: GetCurrentUserLocallyUseCase
    @Injected private var getPlantUseCase: GetPlantUseCase
    @Injected private var getRoomUseCase: GetRoomUseCase
    @Injected private var createPlantUseCase: CreatePlantUseCase
    @Injected private var uploadImageUseCase: UploadImageUseCase
    @Injected private var hasCameraAccessUseCase: HasCameraAccessUseCase
    @Injected private var hasPhotoLibraryAccessUseCase: HasPhotoLibraryAccessUseCase
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    private let editingId: UUID?
    private let onShouldRefresh: () -> Void
    
    // MARK: - Init

    init(
        flowController: FlowController?,
        editingId: UUID?,
        onShouldRefresh: @escaping () -> Void
    ) {
        self.flowController = flowController
        self.editingId = editingId
        self.onShouldRefresh = onShouldRefresh
        
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
        
        var name: String = ""
        var room: Room?
        var plantSettings: PlantSettings = .default
        var uploadedImages: [ImageData] = []
        
        var alertData: AlertData?
        var snackbarData: SnackbarData?
        
        var isCreateButtonEnabled: Bool {
            !name.isBlank && !uploadedImages.isEmpty
        }
        
        var isCameraPickerPresented = false
        var isImagePickerPresented = false
        var isImageSheetPresented = false
    }
    
    // MARK: - Intent
    enum Intent {
        case navigateBack
        
        case createPlant
        
        case nameChanged(String)
        
        case uploadImage(UIImage?)
        case uploadImages([UIImage])
        
        case toggleImageActionSheet
        case toggleCameraPicker
        case toggleImagePicker
        
        case alertDataChanged(AlertData?)
        case snackbarDataChanged(SnackbarData?)
    }

    func onIntent(_ intent: Intent) {
        switch intent {
        case .navigateBack: navigateBack()
        case .createPlant: createPlant()
        case .nameChanged(let name): nameChanged(name)
        case .uploadImage(let image): uploadImage(image)
        case .uploadImages(let images): uploadImages(images)
        case .toggleImageActionSheet: toggleImageActionSheet()
        case .toggleCameraPicker: toggleCameraPicker()
        case .toggleImagePicker: toggleImagePicker()
        case .alertDataChanged(let alertData): alertDataChanged(alertData)
        case .snackbarDataChanged(let snackbarData): snackbarDataChanged(snackbarData)
        }
    }
    
    private func nameChanged(_ name: String) {
        state.name = name
    }
    
    private func navigateBack() {
        state.alertData = .init(
            title: "Cancel plant creation",
            message: "Are you sure you want to cancel plant creation?",
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
                    self?.flowController?.handleFlow(PlantsFlow.pop)
                }
            )
        )
    }
    
    private func createPlant() {
        let plant = Plant(
            id: UUID(),
            name: state.name,
            roomId: state.room?.id,
            images: state.uploadedImages,
            settings: state.plantSettings
        )
        
        let createPlantUseCase = createPlantUseCase
        executeTask(
            Task {
                do {
                    try await createPlantUseCase.execute(plant: plant)
                    onShouldRefresh()
                    flowController?.handleFlow(PlantsFlow.pop)
                } catch {
                    setFailedSnackbarData(message: "Failed to create plant.")
                }
            }
        )
    }
    
    private func uploadImages(_ images: [UIImage]) {
        let uploadImageUseCase = uploadImageUseCase
        
        executeTask(
            Task {
                for image in images {
                    do {
                        guard let data = image.jpegData(compressionQuality: 1),
                              let userId = state.userId else {
                            continue
                        }
                        
                        var newImage = ImageData(
                            id: UUID(),
                            date: Date(),
                            urlString: "",
                            isLoading: true
                        )
                        state.uploadedImages.append(newImage)
                        
                        let url = try await uploadImageUseCase.execute(
                            userId: userId,
                            imageId: newImage.id.uuidString,
                            imageData: data
                        )
                        
                        newImage = ImageData(
                            copy: newImage,
                            urlString: url.absoluteString,
                            isLoading: false
                        )
                        
                        if let index = state.uploadedImages.firstIndex(where: { $0.id == newImage.id }) {
                            state.uploadedImages[index] = newImage
                        }
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
    
    private func dismissAlert() {
        state.alertData = nil
    }
    
    private func setFailedSnackbarData(message: String) {
        state.snackbarData = .init(
            message: message,
            foregroundColor: Colors.white,
            backgroundColor: Colors.red
        )
    }
    
    private func loadData() {
        let getPlantUseCase = getPlantUseCase
        let getRoomUseCase = getRoomUseCase
        if let editingId {
            executeTask(
                Task {
                    guard let plant = try? await getPlantUseCase.execute(id: editingId) else { return }
                    state.name = plant.name
                    if let roomId = plant.roomId {
                        state.room = try? await getRoomUseCase.execute(roomId: roomId)
                    }
                    state.uploadedImages = plant.images
                    state.plantSettings = plant.settings
                }
            )
        }
    }
    
    private func loadUser() {
        guard let user = try? getCurrentUserLocallyUseCase.execute() else {
            return
        }
        state.userId = user.id
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
    
    private func alertDataChanged(_ alertData: AlertData?) {
        state.alertData = alertData
    }
    
    private func snackbarDataChanged(_ snackbarData: SnackbarData?) {
        state.snackbarData = snackbarData
    }
}
