//
//  LoginViewModel.swift
//  Onboarding
//
//  Created by Lucia Cahojova on 04.12.2024.
//

import Resolver
import SharedDomain
import SwiftUI
import UIToolkit

final class LoginViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    @Injected private var sendEmailVerificationUseCase: SendEmailVerificationUseCase
    @Injected private var logInUserUseCase: LogInUserUseCase
    @Injected private var getCurrentUsersEmailUseCase: GetCurrentUsersEmailUseCase
    @Injected private var deleteCurrentUserEmailUseCase: DeleteCurrentUserEmailUseCase
    
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
        
        if let email = getCurrentUsersEmailUseCase.execute() {
            state.email = email
        }
    }
    
    // MARK: - State
    
    @Published private(set) var state: State = State()

    struct State {
        var email: String = ""
        var password: String = ""
        
        var errorMessage: String? = nil
        var emailErrorMessage: String? = nil
        var passwordErrorMessage: String? = nil
        
        var isLoginButtonLoading: Bool = false
        var isLoginButtonDisabled: Bool {
            [email, password]
                .contains { $0.isBlank }
            || [emailErrorMessage, passwordErrorMessage]
                .contains { $0 != nil }
        }
        
        var isEmailVerificationButtonLoading: Bool = false
        var isEmailVerificationButtonVisible = false
    }
    
    // MARK: - Intent
    enum Intent {
        case showForgottenPassword
        case sendEmailVerification
        case logInUser
        case emailChanged(String)
        case passwordChanged(String)
    }

    func onIntent(_ intent: Intent) {
        switch intent {
        case .showForgottenPassword: showForgottenPassword()
        case .sendEmailVerification: sendEmailVerification()
        case .logInUser: logInUser()
        case .emailChanged(let email): emailChanged(email)
        case .passwordChanged(let password): passwordChanged(password)
        }
    }
    
    private func showForgottenPassword() {
        flowController?.handleFlow(OnboardingFlow.showForgottenPassword)
    }
    
    private func logInUser() {
        state.isLoginButtonLoading = true
        
        executeTask(
            Task {
                defer { state.isLoginButtonLoading = false }
                do {
                    try await logInUserUseCase.execute(
                        credentials: LoginCredentials(
                            email: state.email,
                            password: state.password
                        )
                    )
                    
                    flowController?.handleFlow(OnboardingFlow.setupMain)
                } catch AuthError.invalidEmail, AuthError.userNotFound {
                    state.emailErrorMessage = Strings.emailNotRegisteredErrorMessage
                    return
                } catch AuthError.wrongPassword {
                    state.password = ""
                    state.passwordErrorMessage = Strings.wrongPasswordErrorMessage
                    return
                } catch AuthError.emailNotVerified {
                    state.emailErrorMessage = Strings.emailNotVerifiedErrorMessage
                    state.isEmailVerificationButtonVisible = true
                    return
                } catch AuthError.invalidEmailFormat {
                    state.emailErrorMessage = Strings.invalidEmailFormatErrorMessage
                    state.isEmailVerificationButtonVisible = true
                    return
                } catch {
                    state.errorMessage = Strings.defaultErrorMessage
                }
            }
        )
    }
    
    private func emailChanged(_ email: String) {
        state.isEmailVerificationButtonVisible = false
        state.errorMessage = nil
        state.emailErrorMessage = nil
        state.email = email
        
        if email.isBlank {
            deleteCurrentUserEmailUseCase.execute()
        }
    }
    
    private func passwordChanged(_ password: String) {
        state.passwordErrorMessage = nil
        state.errorMessage = nil
        state.password = password
    }
    
    private func sendEmailVerification() {
        state.isEmailVerificationButtonLoading = true
        
        executeTask(
            Task {
                defer { state.isEmailVerificationButtonLoading = false }
                do {
                    try await sendEmailVerificationUseCase.execute()
                    flowController?.handleFlow(OnboardingFlow.showVerificationLink)
                } catch AuthError.tooManyRequests {
                    state.errorMessage = Strings.tooManyRequestsErrorMessage
                } catch AuthError.userNotFound {
                    state.errorMessage = Strings.emailNotRegisteredErrorMessage
                } catch {
                    state.errorMessage = Strings.defaultErrorMessage
                }
            }
        )
    }
}
