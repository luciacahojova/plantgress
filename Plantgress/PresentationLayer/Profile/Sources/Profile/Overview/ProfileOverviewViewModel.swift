//
//  ProfileOverviewViewModel.swift
//  Profile
//
//  Created by Lucia Cahojova on 04.12.2024.
//

import SwiftUI
import UIToolkit

final class ProfileOverviewViewModel: BaseViewModel, ViewModel, ObservableObject {
    
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
            case presentOnboarding(message: String?)
        }
        
        enum Async {
            
        }
    }

    func onIntent(_ intent: Intent) {
        switch intent {
        case let .sync(syncIntent):
            switch syncIntent {
            case .presentOnboarding(let message): presentOnboarding(message: message)
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
    
    private func presentOnboarding(message: String?) {
        flowController?.handleFlow(ProfileFlow.presentOnboarding(message: message))
    }
}
