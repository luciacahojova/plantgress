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
        case .progressTracking: Colors.purple
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
        case .progressTracking: return Asset.Icons.cameraPlus.image
        }
    }
    
    static func name(for type: TaskType) -> String {
        switch type {
        case .watering: return Strings.waterName
        case .pestInspection: return Strings.inspectName
        case .fertilizing: return Strings.fertilizeName
        case .cleaning: return Strings.cleanName
        case .repotting: return Strings.repotName
        case .propagation: return Strings.propagateName
        case .progressTracking: return Strings.trackProgressName
        }
    }
    
    static func title(for type: TaskType) -> String {
        switch type {
        case .watering: return Strings.wateringTitle
        case .pestInspection: return Strings.pestInspectionTitle
        case .fertilizing: return Strings.fertilizingTitle
        case .cleaning: return Strings.cleaningTitle
        case .repotting: return Strings.repottingTitle
        case .propagation: return Strings.propagatingTitle
        case .progressTracking: return Strings.progressTrackingTitle
        }
    }
}
