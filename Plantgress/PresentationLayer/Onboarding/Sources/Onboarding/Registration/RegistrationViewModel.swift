//
//  RegistrationViewModel.swift
//  Onboarding
//
//  Created by Lucia Cahojova on 04.12.2024.
//

import Resolver
import SharedDomain
import SwiftUI
import UIToolkit

final class RegistrationViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    @Injected private var registerUserUseCase: RegisterUserUseCase
    @Injected private var sendEmailVerificationUseCase: SendEmailVerificationUseCase
    @Injected private var validateEmailUseCase: ValidateEmailUseCase
    @Injected private var validatePasswordUseCase: ValidatePasswordUseCase
    
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
        var email: String = ""
        var name: String = ""
        var surname: String = ""
        var password: String = ""
        var repeatPassword: String = ""
        
        var errorMessage: String? = nil
        var emailErrorMessage: String? = nil
        var nameErrorMessage: String? = nil
        var surnameErrorMessage: String? = nil
        var passwordErrorMessage: String? = nil
        var repeatPasswordErrorMessage: String? = nil
        
        var isRegisterButtonLoading: Bool = false
        var isRegisterButtonDisabled: Bool {
            [email, name, surname, password, repeatPassword]
                .contains { $0.isBlank }
            || [emailErrorMessage, nameErrorMessage, surnameErrorMessage, passwordErrorMessage, repeatPasswordErrorMessage]
                .contains { $0 != nil }
        }
    }
    
    // MARK: - Intent
    enum Intent {
        case registerUser
        case emailChanged(String)
        case nameChanged(String)
        case surnameChanged(String)
        case passwordChanged(String)
        case repeatPasswordChanged(String)
    }

    func onIntent(_ intent: Intent) {
        switch intent {
        case .registerUser: registerUser()
        case .emailChanged(let email): emailChanged(email)
        case .nameChanged(let name): nameChanged(name)
        case .surnameChanged(let surname): surnameChanged(surname)
        case .passwordChanged(let password): passwordChanged(password)
        case .repeatPasswordChanged(let repeatPassword): repeatPasswordChanged(repeatPassword)
        }
    }
    
    private func registerUser() {
        state.isRegisterButtonLoading = true
        defer { state.isRegisterButtonLoading = false }
        guard areCredentialsValid() else { return }
        
        executeTask(
            Task {
                do {
                    try await registerUserUseCase.execute(
                        credentials: RegistrationCredentials(
                            email: state.email,
                            name: state.name,
                            surname: state.surname,
                            password: state.password
                        )
                    )
                    
                    try await sendEmailVerificationUseCase.execute()
                    
                    flowController?.handleFlow(OnboardingFlow.showVerificationLink)
                } catch AuthError.emailAlreadyInUse {
                    state.emailErrorMessage = Strings.emailAlreadyInUseErrorMessage
                } catch {
                    state.errorMessage = Strings.defaultErrorMessage
                }
            }
        )
    }
    
    private func emailChanged(_ email: String) {
        state.emailErrorMessage = nil
        state.email = email
    }
    
    private func nameChanged(_ name: String) {
        state.nameErrorMessage = nil
        state.name = name
    }
    
    private func surnameChanged(_ surname: String) {
        state.surnameErrorMessage = nil
        state.surname = surname
    }
    
    private func passwordChanged(_ password: String) {
        state.passwordErrorMessage = nil
        state.password = password
    }
    
    private func repeatPasswordChanged(_ repeatPassword: String) {
        state.repeatPasswordErrorMessage = nil
        state.repeatPassword = repeatPassword
    }
    
    private func areCredentialsValid() -> Bool {
        do {
            try validateEmailUseCase.execute(email: state.email)
            try validatePasswordUseCase.execute(password: state.password)
            
            if state.password != state.repeatPassword {
                state.repeatPasswordErrorMessage = Strings.passwordsDontMatchErrorMessage
                return false
            }
        } catch AuthError.invalidEmailFormat {
            state.emailErrorMessage = Strings.invalidEmailFormatErrorMessage
            return false
        } catch AuthError.invalidPasswordFormat {
            state.passwordErrorMessage = Strings.invalidPasswordFormatErrorMessage
            state.password = ""
            return false
        } catch {
            state.errorMessage = Strings.defaultErrorMessage
            return false
        }
        
        return true
    }
}
