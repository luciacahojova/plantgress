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
    
    // MARK: - State
    
    @Published private(set) var state: State = State()

    struct State {
        var periods: [TaskPeriod] = []
    }
    
    // MARK: - Intent
    enum Intent {
        case save
        case updatePeriod(UUID, TaskInterval)
        case addPeriod
        case removePeriod(UUID)
    }

    func onIntent(_ intent: Intent) {
        switch intent {
        case .save: save()
        case let .updatePeriod(id, interval): updatePeriod(id: id, interval: interval)
        case .addPeriod: addPeriod()
        case let .removePeriod(id): removePeriod(id: id)
        }
    }
    
    private func save() {
        onSave(state.periods)
        flowController?.handleFlow(PlantsFlow.dismiss)
    }
    
    private func updatePeriod(id: UUID, interval: TaskInterval) {
        guard let index = state.periods.firstIndex(where: { $0.id == id }) else { return }
        state.periods[index] = TaskPeriod(
            id: state.periods[index].id,
            name: state.periods[index].name,
            interval: interval
        )
    }

    private func addPeriod() {
        let newPeriod = TaskPeriod(
            id: UUID(),
            name: "Period \(state.periods.count + 1)", // TODO: String
            interval: .daily(interval: 10)
        )
        state.periods.append(newPeriod)
    }
    
    private func removePeriod(id: UUID) {
        state.periods.removeAll { $0.id == id }
        
        state.periods = state.periods.enumerated().map { index, period in
            TaskPeriod(
                id: period.id,
                name: "Period \(index + 1)",
                interval: period.interval
            )
        }
    }
    
    private func loadData(_ periods: [TaskPeriod]) {
        self.state.periods = periods
    }
}
