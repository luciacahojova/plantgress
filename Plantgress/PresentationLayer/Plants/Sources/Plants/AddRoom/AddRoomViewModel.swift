//
//  AddRoomViewModel.swift
//  Plants
//
//  Created by Lucia Cahojova on 30.12.2024.
//

import Foundation
import Resolver
import SharedDomain
import SwiftUI
import UIToolkit

final class AddRoomViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    @Injected private var getPlantsForRoomUseCase: GetPlantsForRoomUseCase
    
    @Injected private var movePlantToRoomUseCase: MovePlantToRoomUseCase
    @Injected private var addPlantsToRoomUseCase: AddPlantsToRoomUseCase
    @Injected private var removePlantFromRoomUseCase: RemovePlantFromRoomUseCase
    
    @Injected private var getRoomUseCase: GetRoomUseCase
    @Injected private var createRoomUseCase: CreateRoomUseCase
    @Injected private var updateRoomUseCase: UpdateRoomUseCase
    @Injected private var deleteRoomUseCase: DeleteRoomUseCase
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    private let onShouldRefresh: () -> Void
    private let onDelete: () -> Void
    
    // MARK: - Init

    init(
        flowController: FlowController?,
        editingId: UUID?,
        onShouldRefresh: @escaping () -> Void,
        onDelete: @escaping () -> Void
    ) {
        self.flowController = flowController
        self.onShouldRefresh = onShouldRefresh
        self.onDelete = onDelete
        
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
        var editingId: UUID?
    
        var name: String = ""
        var plants: [Plant] = []
        var deletedPlants: [Plant] = []
        
        var isEditing: Bool { editingId != nil }
        var isLoading: Bool = false
        
        var isCreateButtonEnabled: Bool {
            !name.isBlank
        }
        
        var snackbarData: SnackbarData?
        var alertData: AlertData?
        var errorMessage: String?
    }
    
    // MARK: - Intent
    enum Intent {
        case deleteRoom
        case createRoom
        
        case deletePlant(plantId: UUID)
        case addPlant
        
        case nameChanged(String)
        case snackbarDataChanged(SnackbarData?)
        case alertDataChanged(AlertData?)
        
        case refresh
    }

    func onIntent(_ intent: Intent) {
        switch intent {
        case .deleteRoom: deleteRoom()
        case .createRoom: createRoom()
        case .deletePlant(let plantId): deletePlant(plantId: plantId)
        case .addPlant: addPlant()
        case .nameChanged(let name): nameChanged(name)
        case .snackbarDataChanged(let snackbarData): snackbarDataChanged(snackbarData)
        case .alertDataChanged(let alertData): alertDataChanged(alertData)
        case .refresh: refresh()
        }
    }
    
    private func refresh() {
        loadData(editingId: state.editingId)
    }
    
    private func deleteRoom() {
        state.alertData = .init(
            title: Strings.roomDeletionAlertTitle,
            message: Strings.roomDeletionAlertMessage,
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
                    self?.confirmDeleteRoom()
                }
            )
        )
    }
    
    private func dismissAlert() {
        state.alertData = nil
    }
    
    private func confirmDeleteRoom() {
        guard let editingId = state.editingId else { return }
        let deleteRoomUseCase = deleteRoomUseCase
        
        executeTask(
            Task {
                do {
                    try await deleteRoomUseCase.execute(roomId: editingId, plants: state.plants)
                    onDelete()
                    flowController?.handleFlow(PlantsFlow.pop)
                } catch {
                    setFailedSnackbarData(message: Strings.failedToDeleteRoomSnackbar)
                }
            }
        )
    }
    
    private func createRoom() {
        let createRoomUseCase = createRoomUseCase
        let updateRoomUseCase = updateRoomUseCase
        let removePlantFromRoomUseCase = removePlantFromRoomUseCase
        
        executeTask(
            Task {
                defer { state.isLoading = false }
                
                do {
                    let room = Room(
                        id: state.editingId ?? UUID(),
                        name: state.name
                    )
                    
                    if state.isEditing {
                        for deletedPlant in state.deletedPlants {
                            do {
                                try await removePlantFromRoomUseCase.execute(plantId: deletedPlant.id, roomId: room.id)
                            } catch {
                                setFailedSnackbarData(message: Strings.failedToRemovePlantFromRoomSnackbar) 
                            }
                        }
                        
                        try await updateRoomUseCase.execute(
                            room: room,
                            plants: state.plants
                        )
                    } else {
                        try await createRoomUseCase.execute(
                            room: room,
                            plants: state.plants
                        )
                    }
                    
                    onShouldRefresh()
                    flowController?.handleFlow(PlantsFlow.pop)
                } catch {
                    setFailedSnackbarData(
                        message: state.isEditing ? Strings.failedToUpdateRoomSnackbar : Strings.failedToCreateRoomSnackbar
                    )
                }
            }
        )
    }
    
    private func deletePlant(plantId: UUID) {
        if let plantIndex = state.plants.firstIndex(where: { $0.id == plantId }) {
            let removedPlant = state.plants.remove(at: plantIndex)
            
            state.deletedPlants.append(removedPlant)
        }
    }
    
    private func addPlant() {
        flowController?.handleFlow(
            PlantsFlow.presentPickPlants(
                selectedPlants: state.plants,
                onSave: { selectedPlants in
                    self.state.plants = selectedPlants
                }
            )
        )
    }
    
    private func alertDataChanged(_ alertData: AlertData?) {
        state.alertData = alertData
    }
    
    private func snackbarDataChanged(_ snackbarData: SnackbarData?) {
        state.snackbarData = snackbarData
    }
    
    private func nameChanged(_ name: String) {
        state.name = name
    }
    
    private func loadData(editingId: UUID?) {
        guard let editingId else { return }
        state.isLoading = true
        state.editingId = editingId
        
        let getRoomUseCase = getRoomUseCase
        let getPlantsForRoomUseCase = getPlantsForRoomUseCase
        executeTask(
            Task {
                defer { state.isLoading = false }
                
                do {
                    let room =  try await getRoomUseCase.execute(roomId: editingId)
                    state.name = room.name
                    state.plants = try await getPlantsForRoomUseCase.execute(roomId: editingId)
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
}
