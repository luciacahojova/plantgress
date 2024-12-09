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
        case registerUser
    }

    func onIntent(_ intent: Intent) {
        switch intent {
        case .dismiss: dismiss()
        case .registerUser: registerUser()
        }
    }
    
    private func dismiss() {
        flowController?.handleFlow(OnboardingFlow.dismiss)
    }
    
    private func registerUser() {
        executeTask(
            Task {
                do {
                    try await registerUserUseCase.execute(
                        credentials: RegistrationCredentials(
                            email: "luciacahojova@gmail.com",
                            name: "Lucia",
                            surname: "Cahojova",
                            password: "LuciaCahojova"
                        )
                    )
                    
                    try await sendEmailVerificationUseCase.execute()
                } catch {
                    print("ERROR registration")
                    return
                }
            }
        )
    }
}
