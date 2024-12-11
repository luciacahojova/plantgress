//
//  ProfileOverviewViewModel.swift
//  Profile
//
//  Created by Lucia Cahojova on 04.12.2024.
//

import Resolver
import SharedDomain
import SwiftUI
import UIToolkit

final class ProfileOverviewViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    @Injected private var getCurrentUserUseCase: GetCurrentUserUseCase
    
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
        
        defer { state.isLoading = false }
        let useCase = getCurrentUserUseCase
        
        executeTask(
            Task {
                do {
                    state.user = try await useCase.execute()
                    // TODO: Add user to keychain after login. if loading the user from keychain fails, load him from firestore
                } catch {
                    print("ERORR")
                }
            }
        )
    }
    
    // MARK: - State
    
    @Published private(set) var state: State = State()

    struct State {
        var isLoading: Bool = true
        var user: User? = nil // TODO: .mock?
    }
    
    // MARK: - Intent
    enum Intent {
        case presentOnboarding(message: String?)
    }

    func onIntent(_ intent: Intent) {
        switch intent {
        case .presentOnboarding(let message): presentOnboarding(message: message)
        }
    }
    
    private func presentOnboarding(message: String?) {
        flowController?.handleFlow(ProfileFlow.presentOnboarding(message: message))
    }
}
