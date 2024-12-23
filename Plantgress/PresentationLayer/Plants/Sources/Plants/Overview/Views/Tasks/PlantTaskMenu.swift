//
//  PlantTaskMenu.swift
//  Plants
//
//  Created by Lucia Cahojova on 19.12.2024.
//

import SharedDomain
import SwiftUI
import UIToolkit

struct PlantTaskMenu: View {
    
    private let canEdit: Bool
    private let canDelete: Bool
    private let deleteTaskAction: () -> Void
    private let editTaskAction: () -> Void
    
    init(
        canEdit: Bool,
        canDelete: Bool,
        deleteTaskAction: @escaping () -> Void,
        editTaskAction: @escaping () -> Void
    ) {
        self.canEdit = canEdit
        self.canDelete = canDelete
        self.deleteTaskAction = deleteTaskAction
        self.editTaskAction = editTaskAction
    }
    
    var body: some View {
        Menu {
            if canDelete {
                MenuLabelButton(
                    text: Strings.deleteButton,
                    role: .destructive,
                    icon: Icons.trash,
                    action: deleteTaskAction
                )
            }
            
            if canEdit {
                MenuLabelButton(
                    text: Strings.editButton,
                    icon: Icons.edit,
                    action: editTaskAction
                )
            }
        } label: {
            RoundedIcon(
                icon: Icons.dotsHorizontal,
                isFilled: false
            )
        }
    }
}

#Preview {
    PlantTaskMenu(
        canEdit: true,
        canDelete: true,
        deleteTaskAction: {},
        editTaskAction: {}
    )
}
