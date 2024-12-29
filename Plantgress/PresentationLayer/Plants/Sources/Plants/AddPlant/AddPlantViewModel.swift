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
    @Injected private var deletePlantUseCase: DeletePlantUseCase
    @Injected private var updatePlantUseCase: UpdatePlantUseCase
    @Injected private var uploadImageUseCase: UploadImageUseCase
    @Injected private var deleteImageUseCase: DeleteImageUseCase
    @Injected private var hasCameraAccessUseCase: HasCameraAccessUseCase
    @Injected private var hasPhotoLibraryAccessUseCase: HasPhotoLibraryAccessUseCase
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    private let onShouldRefresh: () -> Void
    
    // MARK: - Init

    init(
        flowController: FlowController?,
        editingId: UUID?,
        onShouldRefresh: @escaping () -> Void
    ) {
        self.flowController = flowController
        self.onShouldRefresh = onShouldRefresh
        
        super.init()
        
        loadData(editingId: editingId)
    }
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
    }
    
    // MARK: - State
    
    @Published private(set) var state: State = State()

    struct State {
        var userId: String?
        var editingId: UUID?
        
        var name: String = ""
        var room: Room?
        var uploadedImages: [ImageData] = []
        var tasks: [TaskType: TaskConfiguration] = TaskType.allCases.reduce(into: [:]) { tasks, taskType in
            tasks[taskType] = TaskConfiguration.default(for: taskType)
        }
        
        var alertData: AlertData?
        var snackbarData: SnackbarData?
        
        var isCreateButtonEnabled: Bool {
            !name.isBlank && !uploadedImages.isEmpty
        }
        var isEditing: Bool { editingId != nil }
        
        var isCameraPickerPresented = false
        var isImagePickerPresented = false
        var isImageSheetPresented = false
    }
    
    enum TaskProperty {
        case isTracked(Bool)
        case hasNotifications(Bool)
        case time(Date)
        case startDate(Date)
        case periods([TaskPeriod])
    }
    
    // MARK: - Intent
    enum Intent {
        case navigateBack
        case pickRoom
        case showPeriodSettings(taskType: TaskType)
        
        case createPlant
        case deletePlant
        
        case nameChanged(String)
        
        case uploadImage(UIImage?)
        case uploadImages([UIImage])
        case deleteImage(UUID)
        case updateTask(TaskType, TaskConfiguration)
        case updateTaskProperty(TaskType, TaskProperty)
        
        case toggleImageActionSheet
        case toggleCameraPicker
        case toggleImagePicker
        case dissmissCameraPicker
        case dismissImagePicker
        
        case alertDataChanged(AlertData?)
        case snackbarDataChanged(SnackbarData?)
    }

    func onIntent(_ intent: Intent) {
        switch intent {
        case .pickRoom: pickRoom()
        case .navigateBack: navigateBack()
        case .showPeriodSettings(let taskType): showPeriodSettings(for: taskType)
        case .createPlant: createPlant()
        case .deletePlant: deletePlant()
        case .nameChanged(let name): nameChanged(name)
        case .uploadImage(let image): uploadImage(image)
        case .uploadImages(let images): uploadImages(images)
        case .deleteImage(let id): deleteImage(id)
        case let .updateTask(taskType, taskConfiguration): updateTask(taskType: taskType, with: taskConfiguration)
        case let .updateTaskProperty(taskType, property): updateTaskProperty(taskType: taskType, property: property)
        case .toggleImageActionSheet: toggleImageActionSheet()
        case .toggleCameraPicker: toggleCameraPicker()
        case .dissmissCameraPicker: dissmissCameraPicker()
        case .dismissImagePicker: dismissImagePicker()
        case .toggleImagePicker: toggleImagePicker()
        case .alertDataChanged(let alertData): alertDataChanged(alertData)
        case .snackbarDataChanged(let snackbarData): snackbarDataChanged(snackbarData)
        }
    }
    
    private func confirmDeletePlant() {
        guard let plantId = state.editingId else { return }
        
        let deletePlantUseCase = deletePlantUseCase
        
        executeTask(
            Task {
                do {
                    try await deletePlantUseCase.execute(id: plantId)
                    onShouldRefresh()
                    flowController?.handleFlow(PlantsFlow.pop)
                } catch {
                    setFailedSnackbarData(message: "Failed to delete plant.") // TODO: Strings
                }
            }
        )
    }
    
    private func deletePlant() {
        state.alertData = .init(
            title: "Delete Plant", // TODO: Strings
            message: "Are you sure you want to delete plant?",
            primaryAction: .init(
                title: Strings.cancelButton,
                style: .cancel,
                completion: { [weak self] in
                    self?.dismissAlert()
                }
            ),
            secondaryAction: .init(
                title: Strings.deleteButton,
                style: .destructive,
                completion: { [weak self] in
                    self?.confirmDeletePlant()
                }
            )
        )
    }
    
    private func showPeriodSettings(for taskType: TaskType) {
        flowController?.handleFlow(
            PlantsFlow.showPeriodSettings(
                periods: self.state.tasks[taskType]?.periods ?? [],
                onSave: { periods in
                    self.updateTaskProperty(taskType: taskType, property: .periods(periods))
                }
            )
        )
    }
    
    private func pickRoom() {
        flowController?.handleFlow(
            PlantsFlow.presentPickRoom(
                onSave: { room in
                    self.state.room = room
                }
            )
        )
    }
    
    private func updateTask(taskType: TaskType, with taskConfiguration: TaskConfiguration) {
        var updatedTasks = state.tasks
        updatedTasks[taskType] = taskConfiguration
        state.tasks = updatedTasks
    }
    
    private func updateTaskProperty(taskType: TaskType, property: TaskProperty) {
        guard var task = state.tasks[taskType] else { return }
        
        switch property {
        case let .isTracked(isTracked):
            task = TaskConfiguration(copy: task, isTracked: isTracked)
        case let .hasNotifications(hasNotifications):
            task = TaskConfiguration(copy: task, hasNotifications: hasNotifications)
        case let .time(time):
            task = TaskConfiguration(copy: task, time: time)
        case let .startDate(startDate):
            task = TaskConfiguration(copy: task, startDate: startDate)
        case let .periods(periods):
            task = TaskConfiguration(copy: task, periods: periods)
        }
        
        state.tasks[taskType] = task
    }

    private func deleteImage(_ imageId: UUID) {
        guard let userId = state.userId else {
            return
        }

        guard let index = state.uploadedImages.firstIndex(where: { $0.id == imageId }) else {
            return
        }
        
        let removedImage = state.uploadedImages.remove(at: index)
        
        let deleteImageUseCase = deleteImageUseCase
        executeTask(
            Task {
                do {
                    try await deleteImageUseCase.execute(userId: userId, imageId: imageId)
                } catch {
                    self.state.uploadedImages.insert(removedImage, at: index)
                    self.setFailedSnackbarData(message: "Failed to delete image") // TODO: String
                }
            }
        )
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
            settings: .init(
                tasksConfiguartions: Array(state.tasks.values)
            )
        )
        
        let createPlantUseCase = createPlantUseCase
        let updatePlantUseCase = updatePlantUseCase
        executeTask(
            Task {
                do {
                    if state.isEditing {
                        try await updatePlantUseCase.execute(plant: plant)
                    } else {
                        try await createPlantUseCase.execute(plant: plant)
                    }
                    
                    onShouldRefresh()
                    flowController?.handleFlow(PlantsFlow.pop)
                } catch {
                    setFailedSnackbarData(message: "Failed to create plant.") // TODO: String
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
                        guard let userId = state.userId else {
                            throw ImagesError.uploadFailed
                        }
                        
                        guard let data = image.jpegData(compressionQuality: 1) else {
                            throw ImagesError.uploadFailed
                        }
                        
                        var newImage = ImageData(
                            id: UUID(),
                            date: Date(),
                            urlString: nil,
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
    
    private func loadData(editingId: UUID?) {
        state.editingId = editingId
        loadUser()
        
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
                    
                    plant.settings.tasksConfiguartions.forEach { task in
                        state.tasks[task.taskType] = task
                    }
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
    
    private func dissmissCameraPicker() {
        state.isCameraPickerPresented = false
    }
    
    private func dismissImagePicker() {
        state.isImagePickerPresented = false
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
