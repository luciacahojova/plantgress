//
//  ProfileFlowController.swift
//  Profile
//
//  Created by Lucia Cahojova on 03.12.2024.
//

import UIToolkit
import UIKit

enum ProfileFlow: Flow {
    case presentOnboarding(message: String?)
    case showChangeEmail
    case showChangeName
    case showChangePassword
}

public protocol ProfileFlowControllerDelegate: AnyObject {
    func presentOnboarding(message: String?)
}

public final class ProfileFlowController: FlowController {
    
    public weak var delegate: ProfileFlowControllerDelegate?
    
    public override func setup() -> UIViewController {
        let vm = ProfileOverviewViewModel(
            flowController: self
        )
        let view = ProfileOverviewView(
            viewModel: vm
        )
        let vc = HostingController(
            rootView: view,
            title: Strings.profileTitle
        )
        
        return vc
    }
    
    public override func handleFlow(_ flow: Flow) {
        guard let flow = flow as? ProfileFlow else { return }
        switch flow {
        case .presentOnboarding(let message): presentOnboarding(message: message)
        case .showChangeEmail: showChangeEmail()
        case .showChangeName: showChangeName()
        case .showChangePassword: showChangePassword()
        }
    }
    
    private func presentOnboarding(message: String?) {
        delegate?.presentOnboarding(message: message)
    }
    
    private func showChangeEmail() {
        #warning("TODO: Add impelmentation")
    }
    
    private func showChangeName() {
        #warning("TODO: Add impelmentation")
    }
    
    private func showChangePassword() {
        #warning("TODO: Add impelmentation")
    }
}
