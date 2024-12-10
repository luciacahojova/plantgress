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
        var isLoginButtonDisabled = false
        var message: String? = nil
        var errorMessage: String? = nil
        var navigationBarHeight: CGFloat = 0
    }
    
    // MARK: - Intent
    enum Intent {
        case showLogin
        case resendLink
        case dismiss
    }

    func onIntent(_ intent: Intent) {
        switch intent {
        case .showLogin: showLogin()
        case .resendLink: resendLink()
        case .dismiss: dismiss()
        }
    }
    
    private func showLogin() {
        guard isEmailVerifiedUseCase.execute() else {
            state.message = nil
            state.errorMessage = Strings.emailNotVerifiedErrorMessage
            state.isLoginButtonDisabled = true
            return
        }
        
        flowController?.handleFlow(OnboardingFlow.showLogin)
    }
    
    private func resendLink() {
        state.isLoginButtonDisabled = false
        state.errorMessage = nil
        
        executeTask(
            Task {
                do {
                    try await sendEmailVerificationUseCase.execute()
                    // TODO resend overview snackbar
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
    
    private func dismiss() {
        onDismiss()
        flowController?.handleFlow(OnboardingFlow.dismiss)
    }
}
