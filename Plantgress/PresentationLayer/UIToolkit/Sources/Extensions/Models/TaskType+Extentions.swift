//
//  TaskType.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import SharedDomain
import SwiftUI

public extension TaskType {
    static func color(for type: TaskType) -> Color {
        switch type {
        case .watering: Colors.blue
        case .pestInspection: Colors.coral
        case .fertilizing: Colors.yellow
        case .cleaning: Colors.green
        case .repotting: Colors.orange
        case .propagation: Colors.pink
        }
    }
    
    static func icon(for type: TaskType) -> Image {
        switch type {
        case .watering: return Asset.Icons.drop.image
        case .pestInspection: return Asset.Icons.search.image
        case .fertilizing: return Asset.Icons.heartHand.image
        case .cleaning: return Asset.Icons.stars.image
        case .repotting: return Asset.Icons.bag.image
        case .propagation: return Asset.Icons.scissors.image
        }
    }
    
    static func name(for type: TaskType) -> String {
        switch type {
        case .watering: return "Water" // TODO: Strings
        case .pestInspection: return "Inspect"
        case .fertilizing: return "Fertilize"
        case .cleaning: return "Clean"
        case .repotting: return "Repot"
        case .propagation: return "Propagate"
        }
    }
}
