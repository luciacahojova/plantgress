//
//  LoginViewModel.swift
//  Onboarding
//
//  Created by Lucia Cahojova on 04.12.2024.
//

import SwiftUI
import UIToolkit

final class LoginViewModel: BaseViewModel, ViewModel, ObservableObject {
    
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
            case dismiss
        }
        
        enum Async {
            
        }
    }

    func onIntent(_ intent: Intent) {
        switch intent {
        case let .sync(syncIntent):
            switch syncIntent {
            case .dismiss: dismiss()
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
    
    private func dismiss() {
        flowController?.handleFlow(OnboardingFlow.dismiss)
    }
}
