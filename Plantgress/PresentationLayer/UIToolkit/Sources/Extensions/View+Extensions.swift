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
}
