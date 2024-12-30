//
//  RoomDetailViewModel.swift
//  Plants
//
//  Created by Lucia Cahojova on 30.12.2024.
//

import Foundation
import Resolver
import SharedDomain
import UIToolkit

final class RoomDetailViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    @Injected private var getRoomUseCase: GetRoomUseCase
    @Injected private var getPlantsForRoomUseCase: GetPlantsForRoomUseCase
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    
    // MARK: - Init

    init(
        flowController: FlowController?,
        room: Room
    ) {
        self.flowController = flowController
        
        super.init()
        
        loadData(room: room)
    }
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
    }
    
    // MARK: - State
    
    @Published private(set) var state: State = State()

    struct State {
        var room: Room?
        var plants: [Plant] = []
        
        var isLoading: Bool = false
        
        var snackbarData: SnackbarData?
        var alertData: AlertData?
        var errorMessage: String?
    }
    
    // MARK: - Intent
    enum Intent {
        case editRoom
        case openPlantDetail(plantId: UUID)
        
        case snackbarDataChanged(SnackbarData?)
        case alertDataChanged(AlertData?)
        
        case refresh
    }

    func onIntent(_ intent: Intent) {
        switch intent {
        case .editRoom: editRoom()
        case .openPlantDetail(let plantId): openPlantDetail(plantId: plantId)
        case .snackbarDataChanged(let snackbarData): snackbarDataChanged(snackbarData)
        case .alertDataChanged(let alertData): alertDataChanged(alertData)
        case .refresh: refresh()
        }
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
    
    private func openPlantDetail(plantId: UUID) {
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
    
    private func loadData(room: Room? = nil) {
        state.isLoading = true
        
        let getRoomUseCase = getRoomUseCase
        let getPlantsForRoomUseCase = getPlantsForRoomUseCase
        executeTask(
            Task {
                defer { state.isLoading = false }
                
                do {
                    if let room = room {
                        state.room = room
                    } else if let roomId = state.room?.id {
                        state.room = try await getRoomUseCase.execute(roomId: roomId)
                    }
                    
                    guard let loadedRoom = state.room else {
                        state.errorMessage = Strings.dataLoadFailedSnackbarMessage
                        return
                    }
                    
                    state.plants = try await getPlantsForRoomUseCase.execute(roomId: loadedRoom.id)
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
