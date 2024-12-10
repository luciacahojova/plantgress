//
//  ForgottenPasswordViewModel.swift
//  Onboarding
//
//  Created by Lucia Cahojova on 07.12.2024.
//

import Resolver
import SharedDomain
import SwiftUI
import UIToolkit

final class ForgottenPasswordViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    @Injected private var getUserEmailUseCase: GetUserEmailUseCase
    @Injected private var sendPasswordResetUseCase: SendPasswordResetUseCase
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    
    private let onDismiss: () -> Void
    
    // MARK: - Init

    init(
        flowController: FlowController?,
        onDismiss: @escaping () -> Void
    ) {
        self.flowController = flowController
        self.onDismiss = onDismiss
        super.init()
        
        self.state.navigationBarHeight = flowController?.navigationController.navigationBar.frame.height ?? 0
    }
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
        
        if let email = getUserEmailUseCase.execute() {
            state.email = email
        }
    }
    
    // MARK: - State
    
    @Published private(set) var state: State = State()

    struct State {
        var email: String = ""
        
        var errorMessage: String? = nil
        var emailErrorMessage: String? = nil
        
        var isResetPasswordButtonLoading: Bool = false
        var isResetPasswordButtonDisabled: Bool {
            email.isBlank || emailErrorMessage != nil
        }
        
        var snackbarData: SnackbarData?
        
        var navigationBarHeight: CGFloat = 0
    }
    
    // MARK: - Intent
    enum Intent {
        case emailChanged(String)
        case snackbarDataChanged(SnackbarData?)
        case showLogin
        case sendResetPasswordLink
        case dismiss
    }

    func onIntent(_ intent: Intent) {
        switch intent {
        case .emailChanged(let email): emailChanged(email)
        case .snackbarDataChanged(let snackbarData): snackbarDataChanged(snackbarData)
        case .showLogin: showLogin()
        case .sendResetPasswordLink: sendResetPasswordLink()
        case .dismiss: dismiss()
        }
    }
    
    private func emailChanged(_ email: String) {
        state.errorMessage = nil
        state.emailErrorMessage = nil
        state.email = email
    }
    
    private func snackbarDataChanged(_ snackbarData: SnackbarData?) {
        state.snackbarData = snackbarData
    }
    
    private func showLogin() {
        flowController?.handleFlow(OnboardingFlow.dismiss)
    }
    
    private func sendResetPasswordLink() {
        state.isResetPasswordButtonLoading = true
        defer { state.isResetPasswordButtonLoading = false }
        
        executeTask(
            Task {
                do {
                    try await sendPasswordResetUseCase.execute(email: state.email)
                    state.snackbarData = .init(message: Strings.resetPasswordMessage)
                } catch {
                    state.errorMessage = Strings.defaultErrorMessage
                }
            }
        )
    }
    
    private func dismiss() {
        onDismiss()
        flowController?.handleFlow(OnboardingFlow.dismiss)
    }
}
