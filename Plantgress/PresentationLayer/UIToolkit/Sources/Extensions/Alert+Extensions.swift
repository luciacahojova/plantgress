//
//  Alert+Extensions.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 12.12.2024.
//

import Foundation
import SwiftUI

public extension Alert {
    init(_ data: AlertData) {
        if let secondaryAction = data.secondaryAction {
            self.init(
                title: Text(data.title),
                message: Text(data.message ?? ""),
                primaryButton: .init(data.primaryAction),
                secondaryButton: .init(secondaryAction)
            )
        } else {
            self.init(
                title: Text(data.title),
                message: Text(data.message ?? ""),
                dismissButton: .init(data.primaryAction)
            )
        }

    }
}

public extension Alert.Button {
    init(_ action: AlertAction) {
        switch action.style {
        case .default:
            self = .default(Text(action.title), action: action.completion)
        case .cancel:
            self = .cancel(Text(action.title), action: action.completion)
        case .destructive:
            self = .destructive(Text(action.title), action: action.completion)
        }
    }
}
