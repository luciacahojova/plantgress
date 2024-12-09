//
//  AppDelegate.swift
//  Plantgress
//
//  Created by Lucia Cahojova on 03.12.2024.
//

import FirebaseCore
import Resolver
import SwiftUI
import UIKit
import UIToolkit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var flowController: AppFlowController?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Configue Firebae
        FirebaseApp.configure()
        
        // Register Resolver dependencies
        Resolver.registerProviders()
        Resolver.registerRepositories()
        Resolver.registerUseCases()
        
        // Initialize main window with navigation controller
        let nc = NavigationController()
        nc.navigationBar.isHidden = true
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = nc
        window?.makeKeyAndVisible()
        
        // Initialize main flow controller and start the flow
        flowController = AppFlowController(navigationController: nc)
        flowController?.start()
        
        return true
    }
}
