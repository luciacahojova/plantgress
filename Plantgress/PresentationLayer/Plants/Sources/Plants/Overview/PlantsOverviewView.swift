//
//  PlantsOverviewView.swift
//  Plants
//
//  Created by Lucia Cahojova on 03.12.2024.
//

import SwiftUI
import UIToolkit

struct PlantsOverviewView: View {
    
    init() {}
    
    var body: some View {
        ScrollView {
            VStack {
                Text(Strings.plantsTitle)
                Text(Strings.plantsTitle)
                Text(Strings.plantsTitle)
                Text(Strings.plantsTitle)
                Text(Strings.plantsTitle)
                Text(Strings.plantsTitle)
                Text(Strings.plantsTitle)
                Text(Strings.plantsTitle)
                Text(Strings.plantsTitle)
                Text(Strings.plantsTitle)
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    PlantsOverviewView()
}
