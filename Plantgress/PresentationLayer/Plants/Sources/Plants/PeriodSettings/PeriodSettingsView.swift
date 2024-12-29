//
//  PeriodSettingsView.swift
//  Plants
//
//  Created by Lucia Cahojova on 29.12.2024.
//

import SwiftUI

struct PeriodSettingsView: View {
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: PeriodSettingsViewModel
    
    // MARK: - Init
    
    init(viewModel: PeriodSettingsViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            Text("ahoj")
        }
        .onDisappear {
            viewModel.onIntent(.save)
        }
        .lifecycle(viewModel)
    }
}

#Preview {
    let vm = PeriodSettingsViewModel(
        flowController: nil,
        periods: [],
        onSave: { _ in }
    )
    
    return PeriodSettingsView(viewModel: vm)
}
