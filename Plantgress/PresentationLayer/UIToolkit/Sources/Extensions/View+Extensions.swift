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
    
    /// - Inspiration (https://www.avanderlee.com/swiftui/redacted-view-modifier/)
    @ViewBuilder
    func skeleton(
        _ isActive: @autoclosure () -> Bool,
        duration: Double = 1.5,
        bounce: Bool = false
    ) -> some View {
        redacted(reason: isActive() ? .placeholder : [])
            .shimmer(isActive: isActive(), duration: duration, bounce: bounce)
    }
    
    @ViewBuilder
    func shimmer(
        isActive: Bool,
        duration: Double,
        bounce: Bool
    ) -> some View {
        if isActive {
            modifier(
                Shimmer(
                    duration: duration,
                    bounce: bounce
                )
            )
        } else {
            self
        }
    }
}
