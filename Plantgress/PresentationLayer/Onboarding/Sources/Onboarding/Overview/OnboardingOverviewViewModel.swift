//
//  OnboardingOverviewViewModel.swift
//  Onboarding
//
//  Created by Lucia Cahojova on 04.12.2024.
//

import SwiftUI
import UIToolkit

final class OnboardingOverviewViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    
    // MARK: - Init

    init(
        flowController: FlowController?,
        message: String? = nil
    ) {
        self.flowController = flowController
        super.init()
        
        if let message {
            state.alertData = .init(
                title: message
            )
        }
    }
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
    }
    
    // MARK: - State
    
    @Published private(set) var state: State = State()

    struct State {
        var alertData: AlertData?
    }
    
    // MARK: - Intent
    enum Intent {
        case showLogin
        case showRegistration
        case alertDataChanged(AlertData?)
    }

    func onIntent(_ intent: Intent) {
        switch intent {
        case .showLogin: showLogin()
        case .showRegistration: showRegistration()
        case .alertDataChanged(let alertData): alertDataChanged(alertData)
        }
    }
    
    private func alertDataChanged(_ alertData: AlertData?) {
        state.alertData = alertData
    }
    
    private func dismissAlert() {
        state.alertData = nil
    }
    
    private func showLogin() {
        flowController?.handleFlow(OnboardingFlow.showLogin)
    }
    
    private func showRegistration() {
        flowController?.handleFlow(OnboardingFlow.showRegistration)
    }
}
