//
//  ExploreOverviewViewModel.swift
//  Explore
//
//  Created by Lucia Cahojova on 01.01.2025.
//

import Foundation
import UIToolkit

final class ExploreOverviewViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    
    // MARK: - Init

    init(
        flowController: FlowController?
    ) {
        super.init()
    }
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
    }
    
    // MARK: - State
    
    @Published private(set) var state: State = State()

    struct State {}
    
    // MARK: - Intent
    enum Intent {
        case showLuxmeter
        case showPlantDiagnostics
    }

    func onIntent(_ intent: Intent) {
        switch intent {
        case .showLuxmeter: showLuxmeter()
        case .showPlantDiagnostics: showPlantDiagnostics()
        }
    }
    
    private func showLuxmeter() {
        flowController?.handleFlow(ExploreFlow.showLuxmeter)
    }
    
    private func showPlantDiagnostics() {
        flowController?.handleFlow(ExploreFlow.showPlantDiagnostics)
    }
}
