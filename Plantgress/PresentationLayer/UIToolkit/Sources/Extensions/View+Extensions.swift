//
//  View+Extensions.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 06.12.2024.
//

import SwiftUI

@MainActor
public extension View {
    @inlinable func lifecycle(_ viewModel: BaseViewModel) -> some View {
        self
            .onAppear {
                viewModel.onAppear()
            }
            .onDisappear {
                viewModel.onDisappear()
            }
    }
    
    func snackbar(
        _ snackbarData: Binding<SnackbarData?>
    ) -> some View {
        self.modifier(
            SnackbarModifier(
                snackbarData: snackbarData
            )
        )
    }
    
    func animationEffect(isSelected: Bool, id: String, in namespace: Namespace.ID) -> some View {
        modifier(AnimationEffect(isSelected: isSelected, id: id, namespace: namespace))
    }
    
    func pickerTextStyle(isSelected: Bool) -> some View {
        modifier(PickerStyle(isSelected: isSelected))
    }
}
