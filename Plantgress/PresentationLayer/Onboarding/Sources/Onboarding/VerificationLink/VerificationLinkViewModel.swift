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

final class VerificationLinkViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    @Injected private var sendEmailVerificationUseCase: SendEmailVerificationUseCase
    
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
        var errorMessage: String? = nil
    }
    
    // MARK: - Intent
    enum Intent {
        case showLogin
        case resendLink
    }

    func onIntent(_ intent: Intent) {
        switch intent {
        case .showLogin: showLogin()
        case .resendLink: resendLink()
        }
    }
    
    private func showLogin() {
        flowController?.handleFlow(OnboardingFlow.showLogin)
    }
    
    private func resendLink() {
        executeTask(
            Task {
                do {
                    try await sendEmailVerificationUseCase.execute()
                } catch AuthError.emailAlreadyVerified {
                    state.errorMessage = Strings.emailAlreadyVerifiedMessage
                } catch {
                    state.errorMessage = Strings.defaultErrorMessage
                }
            }
        )
    }
}
