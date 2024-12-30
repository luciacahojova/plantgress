//
//  SelectPlantsViewModel.swift
//  Plants
//
//  Created by Lucia Cahojova on 30.12.2024.
//

import Foundation
import Resolver
import SharedDomain
import UIToolkit

final class SelectPlantsViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    @Injected private var getAllPlantsUseCase: GetAllPlantsUseCase
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    private let onSave: ([Plant]) -> Void
    
    // MARK: - Init

    init(
        flowController: FlowController?,
        selectedPlants: [Plant],
        onSave: @escaping ([Plant]) -> Void
    ) {
        self.flowController = flowController
        self.onSave = onSave
        
        super.init()
        
        loadData(selectedPlants: selectedPlants)
    }
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
    }
    
    // MARK: - State
    
    @Published private(set) var state: State = State()

    struct State {
        var selectedPlants: [Plant] = []
        var plants: [Plant] = []
        
        var errorMessage: String?
        
        var isLoading: Bool = false
    }
    
    // MARK: - Intent
    enum Intent {
        case selectPlant(Plant)
        case refresh
        case save
        case dismiss
    }

    func onIntent(_ intent: Intent) {
        switch intent {
        case .selectPlant(let plant): selectPlant(plant)
        case .save: save()
        case .refresh: refresh()
        case .dismiss: dismiss()
        }
    }
    
    private func refresh() {
        loadData(selectedPlants: state.selectedPlants)
    }
    
    private func save() {
        onSave(state.selectedPlants)
        flowController?.handleFlow(PlantsFlow.dismiss)
    }
    
    private func dismiss() {
        flowController?.handleFlow(PlantsFlow.dismiss)
    }
    
    private func selectPlant(_ plant: Plant) {
        if state.selectedPlants.contains(where: { $0.id == plant.id }) {
            state.selectedPlants.removeAll { $0.id == plant.id }
        } else {
            state.selectedPlants.append(plant)
        }
    }
    
    private func loadData(selectedPlants: [Plant]) {
        state.selectedPlants = selectedPlants
        state.isLoading = true
        let getAllPlantsUseCase = getAllPlantsUseCase
        
        executeTask(
            Task {
                defer { state.isLoading = false }
                do {
                    state.plants = try await getAllPlantsUseCase.execute().filter { $0.roomId == nil }
                } catch {
                    state.errorMessage = Strings.dataLoadFailedSnackbarMessage
                }
            }
        )
    }
}
