//
//  TaskItem.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 19.12.2024.
//

import Foundation

public protocol TaskItem {
    var id: UUID { get }
    var plantId: UUID { get }
    var plantName: String { get }
    var imageUrl: String { get }
    var dueDate: Date { get }
    var isCompleted: Bool { get }
}
