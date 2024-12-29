//
//  SelectRoomViewModel.swift
//  Plants
//
//  Created by Lucia Cahojova on 29.12.2024.
//

import Foundation
import Resolver
import SharedDomain
import UIToolkit

final class SelectRoomViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    @Injected private var getAllRoomsUseCase: GetAllRoomsUseCase
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    private let onSave: (Room?) -> Void
    
    // MARK: - Init

    init(
        flowController: FlowController?,
        onSave: @escaping (Room?) -> Void
    ) {
        self.flowController = flowController
        self.onSave = onSave
        
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
        var selectedRoom: Room?
        var rooms: [Room] = []
        
        var errorMessage: String?
        
        var isLoading: Bool = false
    }
    
    // MARK: - Intent
    enum Intent {
        case selectRoom(Room?)
        case refresh
        case save
        case dismiss
    }

    func onIntent(_ intent: Intent) {
        switch intent {
        case .selectRoom(let room): selectRoom(room)
        case .save: save()
        case .refresh: loadData()
        case .dismiss: dismiss()
        }
    }
    
    private func save() {
        onSave(state.selectedRoom)
        flowController?.handleFlow(PlantsFlow.dismiss)
    }
    
    private func dismiss() {
        flowController?.handleFlow(PlantsFlow.dismiss)
    }
    
    private func selectRoom(_ room: Room?) {
        if state.selectedRoom?.id == room?.id, room?.id != nil {
            state.selectedRoom = nil
            return
        }
        state.selectedRoom = room
    }
    
    private func loadData() {
        state.isLoading = true
        let getAllRoomsUseCase = getAllRoomsUseCase
        
        executeTask(
            Task {
                defer { state.isLoading = false }
                do {
                    state.rooms = try await getAllRoomsUseCase.execute()
                } catch {
                    state.errorMessage = "Failed to load rooms." // TODO: String
                }
            }
        )
    }
}
