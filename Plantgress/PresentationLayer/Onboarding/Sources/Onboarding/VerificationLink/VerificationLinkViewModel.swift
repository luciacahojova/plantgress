//
//  VerificationLinkViewModel.swift
//  Onboarding
//
//  Created by Lucia Cahojova on 09.12.2024.
//

import Foundation
import Resolver
import SharedDomain
import UIToolkit
import UIKit

final class VerificationLinkViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    @Injected private var sendEmailVerificationUseCase: SendEmailVerificationUseCase
    @Injected private var isEmailVerifiedUseCase: IsEmailVerifiedUseCase
    
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
    }
    
    // MARK: - State
    
    @Published private(set) var state: State = State()

    struct State {
        var message: String? = nil
        var errorMessage: String? = nil
        
        var snackbarData: SnackbarData?
        
        var isLoginButtonDisabled: Bool {
            errorMessage != nil
        }
        var isResendVerificationButtonLoading: Bool = false
        
        var navigationBarHeight: CGFloat = 0
    }
    
    // MARK: - Intent
    enum Intent {
        case showLogin
        case resendLink
        case snackbarDataChanged(SnackbarData?)
        case dismiss
    }

    func onIntent(_ intent: Intent) {
        switch intent {
        case .showLogin: showLogin()
        case .resendLink: resendLink()
        case .snackbarDataChanged(let snackbarData): snackbarDataChanged(snackbarData)
        case .dismiss: dismiss()
        }
    }
    
    private func showLogin() {
        guard isEmailVerifiedUseCase.execute() else {
            state.message = nil
            state.errorMessage = Strings.emailNotVerifiedErrorMessage
            return
        }
        
        flowController?.handleFlow(OnboardingFlow.showLogin)
    }
    
    private func resendLink() {
        state.isResendVerificationButtonLoading = true
        state.errorMessage = nil
        defer { state.isResendVerificationButtonLoading = false }
        
        executeTask(
            Task {
                do {
                    try await sendEmailVerificationUseCase.execute()
                    state.snackbarData = .init(
                        message: Strings.emailVerificationResentSnackbarMessage,
                        alignment: .center
                    )
                } catch AuthError.emailAlreadyVerified {
                    state.message = Strings.emailAlreadyVerifiedMessage
                } catch AuthError.tooManyRequests {
                    state.errorMessage = Strings.tooManyRequestsErrorMessage
                } catch {
                    state.errorMessage = Strings.defaultErrorMessage
                }
            }
        )
    }
    
    private func snackbarDataChanged(_ snackbarData: SnackbarData?) {
        state.snackbarData = snackbarData
    }
    
    private func dismiss() {
        onDismiss()
        flowController?.handleFlow(OnboardingFlow.dismiss)
    }
}
