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
    
    @Injected private var logInUserUseCase: LogInUserUseCase
    
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
        case dismiss
        case showForgottenPassword
        case logIn
    }

    func onIntent(_ intent: Intent) {
        switch intent {
        case .dismiss: dismiss()
        case .showForgottenPassword: showForgottenPassword()
        case .logIn: logIn()
        }
    }
    
    private func dismiss() {
        flowController?.handleFlow(OnboardingFlow.dismiss)
    }
    
    private func showForgottenPassword() {
        flowController?.handleFlow(OnboardingFlow.showForgottenPassword)
    }
    
    private func logIn() {
        executeTask(
            Task {
                do {
                    try await logInUserUseCase.execute(
                        credentials: LoginCredentials(
                            email: "luciacahojova@gmail.com",
                            password: "LuciaCahojova"
                        )
                    )
                } catch {
                    print("ERROR login")
                    return
                }
                
                flowController?.handleFlow(OnboardingFlow.dismiss)
            }
        )
    }
}
