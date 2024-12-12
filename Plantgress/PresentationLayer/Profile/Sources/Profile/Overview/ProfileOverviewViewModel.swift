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
    
    @Injected private var getCurrentUserRemotelyUseCase: GetCurrentUserRemotelyUseCase
    @Injected private var getCurrentUserLocallyUseCase: GetCurrentUserLocallyUseCase
    @Injected private var logOutUserUseCase: LogOutUserUseCase
    
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
        
        state.user = try? getCurrentUserLocallyUseCase.execute()
        let useCase = getCurrentUserRemotelyUseCase
        executeTask(
            Task {
                do {
                    state.user = try await useCase.execute()
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
        var errorMessage: String?
    }
    
    // MARK: - Intent
    enum Intent {
        case presentOnboarding(message: String?)
        case logoutUser
    }

    func onIntent(_ intent: Intent) {
        switch intent {
        case .presentOnboarding(let message): presentOnboarding(message: message)
        case .logoutUser: logoutUser()
        }
    }
    
    private func presentOnboarding(message: String?) {
        flowController?.handleFlow(ProfileFlow.presentOnboarding(message: message))
    }
    
    private func logoutUser() {
        do {
            try logOutUserUseCase.execute()
            flowController?.handleFlow(ProfileFlow.presentOnboarding(message: nil))
        } catch {
            state.errorMessage = Strings.defaultErrorMessage
        }
    }
}
