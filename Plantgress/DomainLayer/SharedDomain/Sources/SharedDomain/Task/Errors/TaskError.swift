//
//  TaskError.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 19.12.2024.
//

import Foundation

public enum TaskError: Error {
    case taskOrPeriodNotFound
    case taskTypeNotFound
    case invalidNotificationId
    case missingDueDate
}
