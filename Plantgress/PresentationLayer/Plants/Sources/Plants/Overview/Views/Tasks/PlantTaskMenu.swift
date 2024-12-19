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
    
    private let deleteTaskAction: () -> Void
    private let editTaskAction: () -> Void
    
    init(
        deleteTaskAction: @escaping () -> Void,
        editTaskAction: @escaping () -> Void
    ) {
        self.deleteTaskAction = deleteTaskAction
        self.editTaskAction = editTaskAction
    }
    
    var body: some View {
        Menu {
            MenuLabelButton(
                text: "Delete", // TODO: String
                role: .destructive,
                icon: Icons.trash,
                action: deleteTaskAction
            )
            
            MenuLabelButton(
                text: "Edit", // TODO: String
                icon: Icons.edit,
                action: editTaskAction
            )
        } label: {
            RoundedIcon(icon: Icons.dotsHorizontal)
        }
    }
}

#Preview {
    PlantTaskMenu(
        deleteTaskAction: {},
        editTaskAction: {}
    )
}
