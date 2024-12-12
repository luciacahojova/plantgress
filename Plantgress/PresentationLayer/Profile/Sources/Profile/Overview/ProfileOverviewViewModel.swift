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
                    state.errorMessage = Strings.defaultErrorMessage
                }
            }
        )
    }
    
    // MARK: - State
    
    @Published private(set) var state: State = State()

    struct State {
        var isLoading: Bool = true
        var user: User? = nil
        var errorMessage: String? = "Something went wrong."
        var alertData: AlertData?
    }
    
    // MARK: - Intent
    enum Intent {
        case presentOnboarding(message: String?)
        case alertDataChanged(AlertData?)
        case logoutUser
    }

    func onIntent(_ intent: Intent) {
        switch intent {
        case .presentOnboarding(let message): presentOnboarding(message: message)
        case .alertDataChanged(let alertData): alertDataChanged(alertData)
        case .logoutUser: logoutUser()
        }
    }
    
    private func presentOnboarding(message: String?) {
        flowController?.handleFlow(ProfileFlow.presentOnboarding(message: message))
    }
    
    private func logoutUser() {
        state.alertData = .init(
            title: Strings.logoutAlertTitle,
            message: Strings.logoutAlertMessage,
            primaryAction: .init(
                title: Strings.cancelButton,
                style: .cancel,
                completion: { [weak self] in
                    self?.dismissAlert()
                }
            ),
            secondaryAction: .init(
                title: Strings.logoutButton,
                style: .destructive,
                completion: { [weak self] in
                    self?.confirmUserLogout()
                }
            )
        )
    }
    
    private func confirmUserLogout() {
        do {
            try logOutUserUseCase.execute()
            flowController?.handleFlow(ProfileFlow.presentOnboarding(message: nil))
        } catch {
            state.errorMessage = Strings.defaultErrorMessage
        }
    }
    
    private func alertDataChanged(_ alertData: AlertData?) {
        state.alertData = alertData
    }
    
    private func dismissAlert() {
        state.alertData = nil
    }
}
