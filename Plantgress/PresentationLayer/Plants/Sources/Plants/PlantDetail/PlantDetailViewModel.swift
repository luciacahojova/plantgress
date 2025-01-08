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
    @Injected private var getRoomUseCase: GetRoomUseCase
    
    @Injected private var uploadImageUseCase: UploadImageUseCase
    @Injected private var updatePlantImagesUseCase: UpdatePlantImagesUseCase
    @Injected private var prepareImagesForSharingUseCase: PrepareImagesForSharingUseCase
    
    @Injected private var hasCameraAccessUseCase: HasCameraAccessUseCase
    @Injected private var hasPhotoLibraryAccessUseCase: HasPhotoLibraryAccessUseCase
    
    @Injected private var completeTaskUseCase: CompleteTaskUseCase
    @Injected private var deleteTaskUseCase: DeleteTaskUseCase
    @Injected private var deleteTaskForPlantUseCase: DeleteTaskForPlantUseCase
    @Injected private var getUpcomingTasksForPlantUseCase: GetUpcomingTasksForPlantUseCase
    @Injected private var getCompletedTasksForPlantUseCase: GetCompletedTasksForPlantUseCase
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    private let onShouldRefresh: () -> Void
    
    // MARK: - Init

    init(
        flowController: FlowController?,
        plantId: UUID,
        onShouldRefresh: @escaping () -> Void
    ) {
        self.flowController = flowController
        self.onShouldRefresh = onShouldRefresh
        
        super.init()
        
        loadData(plantId: plantId)
    }
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
    }
    
    // MARK: - Tab selection
    
    enum SectionPickerOption: CaseIterable {
        case calendar
        case tasks
        
        var sectionTitle: String {
            switch self {
            case .calendar: Strings.calendarTitle
            case .tasks: Strings.tasksTitle
            }
        }
    }
    
    // MARK: - State
    
    @Published private(set) var state: State = State()
    @Published private(set) var selectedSection: SectionPickerOption = .calendar {
        didSet {
            refreshTasks()
        }
    }

    struct State {
        var userId: String?
        
        var plant: Plant?
        var roomName: String?
        var upcomingTasks: [PlantTask] = []
        var completedTasks: [PlantTask] = []
        
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
        case navigateBack
        case showPlantSettings
        
        case selectedSectionChanged(SectionPickerOption)
        
        case toggleImageActionSheet
        case toggleCameraPicker
        case toggleImagePicker
        case dismissCameraPicker
        case dismissImagePicker
        
        case uploadImage(UIImage?)
        case uploadImages([(Date, UIImage)])
        case shareImages
        
        case completeTask(taskType: TaskType)
        case editTask(PlantTask)
        case deleteTask(PlantTask)
    }

    func onIntent(_ intent: Intent) {
        switch intent {
        case .snackbarDataChanged(let snackbarData): snackbarDataChanged(snackbarData)
        case .alertDataChanged(let alertData): alertDataChanged(alertData)
        case .refresh: refresh()
        case .navigateBack: navigateBack()
        case .showPlantSettings: showPlantSettings()
        case .selectedSectionChanged(let selectedSection): selectedSectionChanged(selectedSection)
        case .toggleImageActionSheet: toggleImageActionSheet()
        case .toggleCameraPicker: toggleCameraPicker()
        case .toggleImagePicker: toggleImagePicker()
        case .dismissCameraPicker: dismissCameraPicker()
        case .dismissImagePicker: dismissImagePicker()
        case .uploadImage(let image): uploadImage(image)
        case .uploadImages(let images): uploadImages(images)
        case .shareImages: shareImages()
        case let .completeTask(taskType): completeTask(taskType: taskType)
        case .editTask(let plantTask): editTask(plantTask)
        case .deleteTask(let plantTask): deleteTask(plantTask)
        }
    }
    
    private func selectedSectionChanged(_ selectedSection: SectionPickerOption) {
        self.selectedSection = selectedSection
    }
    
    private func editTask(_ plantTask: PlantTask) {
        flowController?.handleFlow(
            PlantsFlow.showPlantSettings(
                plantId: plantTask.plantId,
                onShouldRefresh: refresh
            )
        )
    }
    
    private func showPlantSettings() {
        flowController?.handleFlow(
            PlantsFlow.showAddPlant(
                editingId: state.plant?.id,
                plantName: state.plant?.name ?? "",
                onShouldRefresh: {
                    self.onShouldRefresh()
                    self.refresh()
                }
            )
        )
    }
    
    private func navigateBack() {
        flowController?.handleFlow(PlantsFlow.pop)
    }
    
    private func shareImages() {
        guard let images = state.plant?.images else { return }
        let prepareImagesForSharingUseCase = prepareImagesForSharingUseCase
        
        executeTask(
            Task {
                state.snackbarData = .init(message: Strings.snackPreparing, duration: 30)
                
                do {
                    let imagesToShare = try await prepareImagesForSharingUseCase.execute(images: images)
                    state.snackbarData = nil
                    
                    flowController?.handleFlow(
                        PlantsFlow.presentShareImages(
                            images: imagesToShare,
                            onShareSuccess: {
                                self.state.snackbarData = .init(message: Strings.snackSuccess)
                            }
                        )
                    )
                } catch {
                    setFailedSnackbarData(message: Strings.snackFailedToPrepare)
                }
            }
        )
    }
    
    private func deleteTask(_ plantTask: PlantTask) {
        let deleteTaskUseCase = deleteTaskUseCase
        
        executeTask(
            Task {
                do {
                    try await deleteTaskUseCase.execute(task: plantTask)
                    refreshTasks()
                } catch {
                    setFailedSnackbarData(message: Strings.taskDeleteFailedSnackbarMessage)
                }
            }
        )
    }
    
    private func completeTask(taskType: TaskType, shouldRefresh: Bool = false) {
        guard let plant = state.plant else { return }
        
        let completeTaskUseCase = completeTaskUseCase
        
        executeTask(
            Task {
                do {
                    try await completeTaskUseCase.execute(
                        for: plant,
                        taskType: taskType,
                        completionDate: Date()
                    )
                    
                    refreshTasks()
                } catch {
                    setFailedSnackbarData(message: Strings.taskCompleteFailedSnackbarMessage)
                }
            }
        )
    }
    
    private func uploadImages(_ images: [(Date, UIImage)]) {
        let uploadImageUseCase = uploadImageUseCase
        let updatePlantImagesUseCase = updatePlantImagesUseCase

        guard let plantId = state.plant?.id else { return }
        
        executeTask(
            Task {
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
                            plantId: plantId,
                            newImages: newImageData
                        )
                        
                        refresh()
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
        
        if state.userId == nil {
            loadUser()
        }
        
        let getPlantUseCase = getPlantUseCase
        let getRoomUseCase = getRoomUseCase
        let getUpcomingTasksForPlantUseCase = getUpcomingTasksForPlantUseCase
        let getCompletedTasksForPlantUseCase = getCompletedTasksForPlantUseCase
        executeTask(
            Task {
                defer { state.isLoading = false }
                
                do {
                    state.plant = try await getPlantUseCase.execute(id: plantId)
                    
                    guard let plant = state.plant else {
                        return
                    }
                    
                    state.upcomingTasks = await getUpcomingTasksForPlantUseCase.execute(for: plant, days: 14)
                    state.completedTasks = try await getCompletedTasksForPlantUseCase.execute(for: plant.id)
                    
                    guard let roomId = state.plant?.roomId else {
                        return
                    }
                    
                    state.roomName = try await getRoomUseCase.execute(roomId: roomId).name
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
    
    private func refreshTasks() {
        guard let plant = state.plant else { return }
        
        let getCompletedTasksForPlantUseCase = getCompletedTasksForPlantUseCase
        let getUpcomingTasksForPlantUseCase = getUpcomingTasksForPlantUseCase
        
        executeTask(
            Task {
                do {
                    state.upcomingTasks = await getUpcomingTasksForPlantUseCase.execute(for: plant, days: 14)
                    state.completedTasks = try await getCompletedTasksForPlantUseCase.execute(for: plant.id)
                } catch {
                    state.errorMessage = Strings.defaultErrorMessage
                }
            }
        )
    }
}
