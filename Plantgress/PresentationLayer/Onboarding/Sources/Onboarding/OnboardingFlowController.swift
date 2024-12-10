//
//  OnboardingFlowController.swift
//  Onboarding
//
//  Created by Lucia Cahojova on 03.12.2024.
//

import UIToolkit
import UIKit

enum OnboardingFlow: Flow {
    case showLogin
    case showRegistration
    case showForgottenPassword
    case showVerificationLink
    case dismiss
    case pop
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
        let viewModel = OnboardingOverviewViewModel(
            flowController: self
        )
        let view = OnboardingOverviewView(viewModel: viewModel)
        let vc = HostingController(
            rootView: view,
            showsNavigationBar: false
        )
        
        return vc
    }
    
    override public func dismiss() {
        super.dismiss()
        delegate?.setupMain()
    }
    
    override public func handleFlow(_ flow: Flow) {
        guard let onboardingFlow = flow as? OnboardingFlow else { return }
        switch onboardingFlow {
        case .showLogin: showLogin()
        case .showRegistration: showRegistration()
        case .showForgottenPassword: showForgottenPassword()
        case .showVerificationLink: showVerificationLink()
        case .dismiss: dismiss()
        case .pop: pop()
        }
    }
    
    private func showLogin() {
        let vm = LoginViewModel(
            flowController: self
        )
        let view = LoginView(viewModel: vm)
        let vc = HostingController(
            rootView: view,
            title: Strings.loginTitle
        )
        
        navigationController.popToRootViewController(animated: false)
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showRegistration() {
        let vm = RegistrationViewModel(
            flowController: self
        )
        let view = RegistrationView(viewModel: vm)
        let vc = HostingController(
            rootView: view,
            title: Strings.registrationTitle
        )
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showForgottenPassword() {
        let vm = ForgottenPasswordViewModel(
            flowController: self
        )
        let view = ForgottenPasswordView(viewModel: vm)
        let vc = HostingController(rootView: view)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showVerificationLink() {
        let vm = VerificationLinkViewModel(
            flowController: self
        )
        let view = VerificationLinkView(viewModel: vm)
        let vc = HostingController(
            rootView: view,
            title: Strings.verificationLinkTitle
        )
        
        navigationController.popToRootViewController(animated: false)
        navigationController.pushViewController(vc, animated: true)
    }
}
