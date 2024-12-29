//
//  PeriodSettingsViewModel.swift
//  Plants
//
//  Created by Lucia Cahojova on 29.12.2024.
//

import Foundation
import SharedDomain
import UIToolkit

final class PeriodSettingsViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    private let onSave: ([TaskPeriod]) -> Void
    
    // MARK: - Init

    init(
        flowController: FlowController?,
        periods: [TaskPeriod],
        onSave: @escaping ([TaskPeriod]) -> Void
    ) {
        self.flowController = flowController
        self.onSave = onSave
        
        super.init()
        
        loadData(periods)
    }
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
    }
    
    // MARK: - State
    
    @Published private(set) var state: State = State()

    struct State {
        var periods: [TaskPeriod] = []
    }
    
    // MARK: - Intent
    enum Intent {
        case save
    }

    func onIntent(_ intent: Intent) {
        switch intent {
        case .save: save()
        }
    }
    
    private func save() {
        // TODO:
        flowController?.handleFlow(PlantsFlow.dismiss)
    }
    
    private func dismiss() {
        flowController?.handleFlow(PlantsFlow.dismiss)
    }
    
    private func loadData(_ periods: [TaskPeriod]) {
        self.state.periods = periods
    }
}
