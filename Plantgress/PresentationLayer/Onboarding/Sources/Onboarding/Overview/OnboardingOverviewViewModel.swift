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
        flowController: FlowController?
    ) {
        self.flowController = flowController
        super.init()
    }
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
    }
    
    // MARK: - State
    
    @Published private(set) var state: State = State()

    struct State {
        
    }
    
    // MARK: - Intent
    enum Intent {
        case sync(Sync)
        case async(Async)
        
        enum Sync {
            case showLogin
            case showRegistration
        }
        
        enum Async {
            
        }
    }

    func onIntent(_ intent: Intent) {
        switch intent {
        case let .sync(syncIntent):
            switch syncIntent {
            case .showLogin: showLogin()
            case .showRegistration: showRegistration()
            }
        case let .async(asyncIntent):
            executeTask(
                Task {
                    switch asyncIntent {
                        
                    }
                }
            )
        }
    }
    
    private func showLogin() {
        flowController?.handleFlow(OnboardingFlow.showLogin)
    }
    
    private func showRegistration() {
        flowController?.handleFlow(OnboardingFlow.showRegistration)
    }
}
