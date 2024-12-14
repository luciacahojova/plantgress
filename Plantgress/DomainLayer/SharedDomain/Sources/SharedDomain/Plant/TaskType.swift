//
//  TaskType.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import Foundation

public enum TaskType: String, CaseIterable, Codable, Identifiable {
    case watering
    case pestInspection
    case fertilizing
    case cleaning
    case repotting
    case propagation
    
    public var id: String {
        self.rawValue
    }
}
