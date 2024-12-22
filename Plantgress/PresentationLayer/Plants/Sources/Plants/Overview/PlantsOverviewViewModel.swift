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
    
    @Injected private var getCurrentUserLocallyUseCase: GetCurrentUserLocallyUseCase
    
    @Injected private var hasCameraAccessUseCase: HasCameraAccessUseCase
    @Injected private var hasPhotoLibraryAccessUseCase: HasPhotoLibraryAccessUseCase
    
    @Injected private var updatePlantUseCase: UpdatePlantUseCase
    @Injected private var getAllPlantsUseCase: GetAllPlantsUseCase
    @Injected private var uploadImageUseCase: UploadImageUseCase
    @Injected private var updatePlantImagesUseCase: UpdatePlantImagesUseCase
    
    @Injected private var getAllRoomsUseCase: GetAllRoomsUseCase
    
    @Injected private var getUpcomingTasksForAllPlantsUseCase: GetUpcomingTasksForAllPlantsUseCase
    @Injected private var getCompletedTasksForAllPlantsUseCase: GetCompletedTasksForAllPlantsUseCase
    @Injected private var completeTaskUseCase: CompleteTaskUseCase
    @Injected private var completeTaskForRoomUseCase: CompleteTaskForRoomUseCase
    @Injected private var deleteTaskUseCase: DeleteTaskUseCase
    @Injected private var deleteTaskForRoomUseCase: DeleteTaskForRoomUseCase
    @Injected private var deleteTaskForPlantUseCase: DeleteTaskForPlantUseCase
    
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
        loadUser()
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
            loadData()
        }
    }

    struct State {
        var isLoading: Bool = false
        
        var userId: String?
        
        var images: [UIImage] = []
        
        var upcomingTasks: [PlantTask] = []
        var completedTasks: [PlantTask] = []
        var rooms: [Room] = []
        var plants: [Plant] = []
        
        var selectedPlantId: UUID?
        
        var alertData: AlertData?
        var snackbarData: SnackbarData?
        var errorMessage: String?
        
        var isCameraPickerPresented = false
        var isImagePickerPresented = false
        var isImageSheetPresented = false
    }
    
    // MARK: - Intent
    enum Intent {
        case completeTaskForRoom(roomId: UUID, taskType: TaskType)
        case completeTaskForPlant(plant: Plant, taskType: TaskType)
        case completeTask(PlantTask)
        case deleteTask(PlantTask)
        case editTask(PlantTask)
        
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
        
        case refresh
    }

    func onIntent(_ intent: Intent) {
        switch intent {
        case let .completeTaskForRoom(roomId, taskType): completeTaskForRoom(roomId: roomId, taskType: taskType)
        case let .completeTaskForPlant(plant, taskType): completeTaskForPlant(plant: plant, taskType: taskType)
        case .completeTask(let plantTask): completeTask(plantTask)
        case .editTask(let plantTask): editTask(plantTask)
        case .deleteTask(let plantTask): deleteTask(plantTask)
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
        case .refresh: loadData()
        }
    }
    
    private func completeTask(_ plantTask: PlantTask) {
        guard let plant = state.plants.first(where: { $0.id == plantTask.plantId }) else {
            return
        }
        
        completeTaskForPlant(plant: plant, taskType: plantTask.taskType, shouldRefresh: true)
    }
    
    private func deleteTask(_ plantTask: PlantTask) {
        let deleteTaskUseCase = deleteTaskUseCase
        
        executeTask(
            Task {
                do {
                    try await deleteTaskUseCase.execute(task: plantTask)
                    loadData()
                } catch {
                    setFailedSnackbarData(message: "Failed to delete task.") // TODO: String
                }
            }
        )
    }
    
    private func editTask(_ plantTask: PlantTask) {
        if plantTask.isCompleted {
            // TODO: Handle flow
        } else {
            // TODO: Handle flow
        }
    }
    
    private func completeTaskForRoom(roomId: UUID, taskType: TaskType) {
        let completeTaskForRoomUseCase = completeTaskForRoomUseCase
        let deleteTaskForRoomUseCase = deleteTaskForRoomUseCase
        
        executeTask(
            Task {
                do {
                    try await completeTaskForRoomUseCase.execute(
                        roomId: roomId,
                        taskType: taskType,
                        completionDate: Date()
                    )
                    
                    state.snackbarData = .init(
                        message: "\(TaskType.title(for: taskType)) completed",
                        actionText: "Undo", // TODO: String
                        action: {
                            Task {
                                try? await deleteTaskForRoomUseCase.execute(roomId: roomId, taskType: taskType)
                            }
                        }
                    )
                } catch {
                    state.snackbarData = .init(message: "Failed to complete task") // TODO: String
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
                        loadData()
                    } else {
                        state.snackbarData = .init(
                            message: "\(TaskType.title(for: taskType)) completed",
                            actionText: "Undo",
                            action: {
                                Task {
                                    try? await deleteTaskForPlantUseCase.execute(plant: plant, taskType: taskType)
                                }
                            }
                        )
                    }
                } catch {
                    state.snackbarData = .init(message: "Failed to complete task") // TODO: String
                }
            }
        )
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
                    onShouldRefresh: { self.loadData() }
                )
            )
        case .rooms:
            flowController?.handleFlow(
                PlantsFlow.showAddRoom(
                    editingId: nil,
                    onShouldRefresh: { self.loadData() }
                )
            )
        case .tasks:
            flowController?.handleFlow(
                PlantsFlow.presentAddTask(
                    editingId: nil,
                    onShouldRefresh: { self.loadData() }
                )
            )
        }
    }
    
    private func uploadImages(_ images: [UIImage]) {
        let uploadImageUseCase = uploadImageUseCase
        let updatePlantImagesUseCase = updatePlantImagesUseCase

        guard let selectedPlantId = state.selectedPlantId else { return}
        
        executeTask(
            Task {
                defer { state.selectedPlantId = nil }
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
                            plantId: selectedPlantId,
                            newImages: newImageData
                        )
                        
                        state.snackbarData = .init(message: "Progess saved!") // TODO: String
                    } catch {
                        setFailedSnackbarData(message: "Failed to upload image") // TODO: String
                    }
                }
            }
        )
    }
    
    private func uploadImage(_ image: UIImage?) {
        guard let image else {
            setFailedSnackbarData(message: "Failed to upload image") // TODO: String
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
        state.isLoading = true
        
        let getAllPlantsUseCase = getAllPlantsUseCase
        let getAllRoomsUseCase = getAllRoomsUseCase
        let getCompletedTasksForAllPlantsUseCase = getCompletedTasksForAllPlantsUseCase
        let getUpcomingTasksForAllPlantsUseCase = getUpcomingTasksForAllPlantsUseCase
        
        executeTask(
            Task {
                defer { state.isLoading = false }
                
                do {
                    switch selectedSection {
                    case .plants: state.plants = try await getAllPlantsUseCase.execute()
                    case .rooms: state.rooms = try await getAllRoomsUseCase.execute()
                    case .tasks:
                        state.upcomingTasks = await getUpcomingTasksForAllPlantsUseCase.execute(
                            for: state.plants,
                            days: 7
                        )
                        
                        state.completedTasks = try await getCompletedTasksForAllPlantsUseCase.execute(
                            for: state.plants.map { $0.id }
                        )
                    }
                } catch {
                    state.errorMessage = "Failed to load." // TODO: String
                }
            }
        )
    }
        
    private func updateTitle() {
        flowController?.navigationController.viewControllers.first?.title = selectedSection.title
        self.flowController?.navigationController.tabBarItem.title = nil
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
