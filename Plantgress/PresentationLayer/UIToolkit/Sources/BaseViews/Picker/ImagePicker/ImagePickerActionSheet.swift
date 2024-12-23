//
//  ImagePickerActionSheet.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 15.12.2024.
//

import SwiftUI

public struct ImagePickerActionSheet {
    private let cameraAction: () -> Void
    private let libraryAction: () -> Void
    
    public init(
        cameraAction: @escaping () -> Void,
        libraryAction: @escaping () -> Void
    ) {
        self.cameraAction = cameraAction
        self.libraryAction = libraryAction
    }
    
    public var actionSheet: ActionSheet {
        ActionSheet(
            title: Text(Strings.chooseActionTitle),
            message: nil,
            buttons: [
                .default(
                    Text(Strings.cameraAction),
                    action: cameraAction
                ),
                .default(
                    Text(Strings.libraryAction),
                    action: libraryAction
                ),
                .cancel(Text(Strings.cancelButton))
            ]
        )
    }
}
