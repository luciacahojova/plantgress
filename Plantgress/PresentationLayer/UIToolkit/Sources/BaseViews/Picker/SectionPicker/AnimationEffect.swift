//
//  AnimationEffect.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 13.12.2024.
//

import SwiftUI

struct AnimationEffect: ViewModifier {
    private var isSelected: Bool
    private var id: String
    private var namespace: Namespace.ID
    
    init(
        isSelected: Bool,
        id: String,
        namespace: Namespace.ID
    ) {
        self.isSelected = isSelected
        self.id = id
        self.namespace = namespace
    }
    
    func body(content: Content) -> some View {
        if isSelected {
            content.matchedGeometryEffect(id: id, in: namespace)
        } else {
            content
        }
    }
}
