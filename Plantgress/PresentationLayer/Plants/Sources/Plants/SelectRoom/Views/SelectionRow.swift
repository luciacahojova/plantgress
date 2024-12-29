//
//  SelectionRow.swift
//  Plants
//
//  Created by Lucia Cahojova on 29.12.2024.
//

import Resolver
import SwiftUI
import UIToolkit

struct SelectionRow: View {
    
    private let title: String
    private let isSelected: Bool
    private let actionType: ActionType
    private let imageUrlString: String?
    
    private let selectAction: () -> Void
    private let deleteAction: (() -> Void)?
    
    private let skeleton: Bool
    
    init(
        title: String,
        isSelected: Bool,
        actionType: ActionType,
        imageUrlString: String?,
        selectAction: @escaping () -> Void,
        deleteAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.isSelected = isSelected
        self.actionType = actionType
        self.imageUrlString = imageUrlString
        self.selectAction = selectAction
        self.deleteAction = deleteAction
        self.skeleton = false
    }
    
    private init() {
        self.title = "Monstera"
        self.isSelected = false
        self.actionType = .none
        self.imageUrlString = "https://fastly.picsum.photos/id/248/3872/2592.jpg?hmac=_F3LsKQyGyWnwQJogUtsd_wyx2YDYnYZ6VZmSMBCxNI"
        self.selectAction = {}
        self.deleteAction = {}
        self.skeleton = true
    }
    
    static var skeleton: SelectionRow {
        self.init()
    }
    
    enum ActionType {
        case checkmark
        case trash
        case none
    }
    
    var body: some View {
        Button(action: selectAction) {
            HStack(spacing: Constants.Spacing.mediumLarge) {
                RemoteImage(
                    urlString: imageUrlString,
                    contentMode: .fill
                )
                .frame(width: 140, height: 50)
                .cornerRadius(Constants.CornerRadius.large)
                
                Text(title)
                    .font(Fonts.bodyMedium)
                
                Spacer()
                
                if actionType == .trash {
                    Button {
                        deleteAction?()
                    } label: {
                        Icons.trash
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: Constants.IconSize.xMedium)
                    }
                } else if actionType == .checkmark {
                    RoundedIcon(
                        icon: Icons.check,
                        isFilled: isSelected
                    )
                }
            }
        }
        .foregroundStyle(Colors.primaryText)
        .padding([.vertical, .leading], Constants.Spacing.medium)
        .padding(.trailing)
        .frame(maxWidth: .infinity)
        .background(Colors.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.large))
        .overlay {
            RoundedRectangle(cornerRadius: Constants.CornerRadius.large)
                .strokeBorder(
                    Colors.primaryText,
                    lineWidth: isSelected ? 2 : 0
                )
        }
        .skeleton(skeleton)
    }
}

#Preview {
    Resolver.registerUseCasesForPreviews()
    
    return ScrollView {
        SelectionRow(
            title: "Monstera",
            isSelected: true,
            actionType: .trash,
            imageUrlString: "https://fastly.picsum.photos/id/248/3872/2592.jpg?hmac=_F3LsKQyGyWnwQJogUtsd_wyx2YDYnYZ6VZmSMBCxNI",
            selectAction: {},
            deleteAction: {}
        )
        
        SelectionRow(
            title: "Monstera",
            isSelected: true,
            actionType: .checkmark,
            imageUrlString: "https://fastly.picsum.photos/id/248/3872/2592.jpg?hmac=_F3LsKQyGyWnwQJogUtsd_wyx2YDYnYZ6VZmSMBCxNI",
            selectAction: {},
            deleteAction: {}
        )
        
        SelectionRow(
            title: "Ficus",
            isSelected: true,
            actionType: .none,
            imageUrlString: "https://fastly.picsum.photos/id/248/3872/2592.jpg?hmac=_F3LsKQyGyWnwQJogUtsd_wyx2YDYnYZ6VZmSMBCxNI",
            selectAction: {},
            deleteAction: {}
        )
    }
    .background(Colors.primaryBackground)
}
