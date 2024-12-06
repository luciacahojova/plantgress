//
//  LaunchView.swift
//  Plantgress
//
//  Created by Lucia Cahojova on 03.12.2024.
//

import SwiftUI

struct LaunchView: View {
    
    init() {}
    
    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            ProgressView("Loading...")
                .progressViewStyle(CircularProgressViewStyle())
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    LaunchView()
}
