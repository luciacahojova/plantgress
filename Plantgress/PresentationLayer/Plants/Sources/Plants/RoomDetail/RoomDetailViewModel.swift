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
                    // TODO: Handle refreshing flow title
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
        loadData(room: state.room)
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
    
    private func loadData(room: Room?) {
        state.room = room
        guard let roomId = state.room?.id else {
            setFailedSnackbarData(message: Strings.dataLoadFailedSnackbarMessage)
            return
        }
        
        state.isLoading = true
        let getPlantsForRoomUseCase = getPlantsForRoomUseCase
        executeTask(
            Task {
                defer { state.isLoading = false }
                
                do {
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
}
