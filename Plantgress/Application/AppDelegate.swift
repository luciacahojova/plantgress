//
//  AppDelegate.swift
//  Plantgress
//
//  Created by Lucia Cahojova on 03.12.2024.
//

import FirebaseCore
import Resolver
import SharedDomain
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
        
        // Configure cache
        configureCache()
        
        // Register Resolver dependencies
        Resolver.registerProviders()
        Resolver.registerRepositories()
        Resolver.registerUseCases()
        
        // Authorize notifications
        authorizeLocalNotifications()
        
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
    
    private func configureCache() {
        URLCache.shared.memoryCapacity = 10_000_000
        URLCache.shared.diskCapacity = 1_000_000_000
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        synchronizePlantNotifications()
    }
    
    func authorizeLocalNotifications() {
        @Injected var hasNotificationAccessUseCase: HasNotificationAccessUseCase
    
        Task {
            try? await hasNotificationAccessUseCase.execute()
        }
    }
    
    func synchronizePlantNotifications() {
        @Injected var synchronizeNotificationsForAllPlantsUseCase: SynchronizeNotificationsForAllPlantsUseCase
        
        Task {
            try? await synchronizeNotificationsForAllPlantsUseCase.execute()
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // Extract the notification ID
        let notificationId = response.notification.request.identifier
        
        // Use the use case to process the next step
        @Injected var scheduleNextNotificationUseCase: ScheduleNextNotificationUseCase

        Task {
            do {
                try await scheduleNextNotificationUseCase.execute(notificationId: notificationId)
            } catch {
                print("❗️Failed to schedule next notification: \(error.localizedDescription)")
            }
            completionHandler()
        }
    }
}
