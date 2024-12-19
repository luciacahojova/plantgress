//
//  HasNotificationAccessUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 19.12.2024.
//

import Foundation
import UserNotifications

public protocol HasNotificationAccessUseCase {
    func execute() async throws
}

public struct HasNotificationAccessUseCaseImpl: HasNotificationAccessUseCase {
    
    public init() {}
    
    public func execute() async throws {
        let current = UNUserNotificationCenter.current()
        let settings = await current.notificationSettings()
        
        switch settings.authorizationStatus {
        case .authorized, .provisional:
            return
        case .notDetermined:
            do {
                let granted = try await current.requestAuthorization(options: [.alert, .sound, .badge])
                
                if !granted {
                    throw NotificationsError.notificationAccessNotGranted
                }
            } catch {
                throw NotificationsError.notificationAccessNotGranted
            }
        default:
            throw NotificationsError.notificationAccessNotGranted
        }
    }
}
