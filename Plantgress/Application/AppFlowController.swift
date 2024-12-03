//
//  AppFlowController.swift
//  Plantgress
//
//  Created by Lucia Cahojova on 03.12.2024.
//

import UIToolkit
import Onboarding

final class AppFlowController: FlowController {
    
    // MARK: - Dependencies
    
    // MARK: - Flow handling
    
    func start() {
        let loadingView = LaunchView()
        let loadingVC = HostingController(rootView: loadingView)
        navigationController.viewControllers = [loadingVC]
        
        Task {
            let isUserLoggedIn: Bool = true
            
            if isUserLoggedIn {
                setupMain()
            } else {
                presentOnboarding(
                    message: nil,
                    animated: false,
                    completion: nil
                )
            }
        }
    }
    
    func setupMain() {
        let fc = MainFlowController(navigationController: navigationController)
//        fc.delegate = self
        let rootVC = startChildFlow(fc)
        navigationController.viewControllers = [rootVC]
    }
    
    func presentOnboarding(
        message: String?,
        animated: Bool,
        completion: (() -> Void)?
    ) {
        let nc = NavigationController()
        let fc = OnboardingFlowController(
            message: nil,
            navigationController: navigationController
        )
//        fc.delegate = self
        let rootVC = startChildFlow(fc)
        nc.viewControllers = [rootVC]
        nc.modalPresentationStyle = .fullScreen
        nc.navigationBar.isHidden = false
        navigationController.present(nc, animated: animated, completion: completion)
    }
}
