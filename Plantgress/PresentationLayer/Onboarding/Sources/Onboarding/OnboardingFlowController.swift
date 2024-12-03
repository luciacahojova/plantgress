//
//  OnboardingFlowController.swift
//  Onboarding
//
//  Created by Lucia Cahojova on 03.12.2024.
//

import UIToolkit
import UIKit

enum OnboardingFlow: Flow {
    case login(Login)
    case register(Register)
    
    enum Login: Equatable {
        case dismiss
        case showRegistration
    }
    
    enum Register: Equatable {
        case dismiss
        case pop
    }
}

public protocol OnboardingFlowControllerDelegate: AnyObject {
    func setupMain()
}

public final class OnboardingFlowController: FlowController {
    
    public weak var delegate: OnboardingFlowControllerDelegate?
    
    private let message: String?
    
    public init(
        message: String?,
        navigationController: UINavigationController
    ) {
        self.message = message
        super.init(navigationController: navigationController)
    }
    
    override public func setup() -> UIViewController {
        let view = OnboardingView()
        return HostingController(rootView: view)
    }
    
    override public func dismiss() {
        super.dismiss()
        delegate?.setupMain()
    }
    
    override public func handleFlow(_ flow: Flow) {
        guard let onboardingFlow = flow as? OnboardingFlow else { return }
        switch onboardingFlow {
        case let .login(loginFlow): handleLoginFlow(loginFlow)
        case let .register(registerFlow): handleRegisterFlow(registerFlow)
        }
    }
}

// MARK: Login flow
extension OnboardingFlowController {
    func handleLoginFlow(_ flow: OnboardingFlow.Login) {
        switch flow {
        case .dismiss: dismiss()
        case .showRegistration: showRegistration()
        }
    }
    
    private func showRegistration() {
        let view = OnboardingView()
        let vc = HostingController(rootView: view)
        navigationController.pushViewController(vc, animated: true)
    }
}

// MARK: Register flow
extension OnboardingFlowController {
    func handleRegisterFlow(_ flow: OnboardingFlow.Register) {
        switch flow {
        case .dismiss: dismiss()
        case .pop: pop()
        }
    }
}

