//
//  AppFlowController.swift
//  Plantgress
//
//  Created by Lucia Cahojova on 03.12.2024.
//

import UIToolkit
import Onboarding

final class AppFlowController: FlowController, OnboardingFlowControllerDelegate, MainFlowControllerDelegate {
    
    // MARK: - Dependencies
    
    // MARK: - Flow handling
    
    func start() {
        let loadingView = LaunchView()
        let loadingVC = HostingController(rootView: loadingView)
        navigationController.viewControllers = [loadingVC]
        
        Task {
            let isUserLoggedIn: Bool = false
            
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
        // Create an instance of MainFlowController, passing the current navigationController
        let fc = MainFlowController(navigationController: navigationController)
        
        // Set the delegate of MainFlowController to this AppFlowController instance
        fc.delegate = self
        
        // Start the MainFlowController and retrieve its root view controller
        let rootVC = startChildFlow(fc)
        
        // Replace the current view controllers in the navigation stack with the root view controller
        navigationController.viewControllers = [rootVC]
    }
    
    func presentOnboarding(
        message: String?,
        animated: Bool,
        completion: (() -> Void)?
    ) {
        // Create a new navigation controller for the onboarding flow
        let nc = NavigationController()
        
        // Create the onboarding flow controller with the new navigation controller
        let fc = OnboardingFlowController(
            message: message,
            navigationController: nc
        )
        fc.delegate = self
        
        // Set the onboarding root view controller
        let rootVC = startChildFlow(fc)
        nc.viewControllers = [rootVC]
        
        // Configure modal presentation
        nc.modalPresentationStyle = .fullScreen
        nc.navigationBar.isHidden = false
        
        // Present the onboarding flow modally
        navigationController.present(nc, animated: animated, completion: completion)
    }
    
    public func handleLogout() {
        Task {
            do {
                self.presentOnboarding(
                    message: "To continue, you must log in again.",
                    animated: true,
                    completion: nil
                )
            }
        }
    }
}
