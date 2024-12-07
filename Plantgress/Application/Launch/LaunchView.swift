//
//  LaunchView.swift
//  Plantgress
//
//  Created by Lucia Cahojova on 03.12.2024.
//

import SwiftUI
import UIToolkit

struct LaunchView: View {
    @State private var iconSize: CGFloat = 0

    var body: some View {
        Images.logoWithText
            .resizable()
            .scaledToFit()
            .frame(width: iconSize, height: iconSize)
            .onAppear {
                withAnimation(.easeInOut(duration: 1)) {
                    iconSize = Constants.IconSize.maxi
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
            .background(Colors.primaryBackground)
    }
}

#Preview {
    LaunchView()
}
