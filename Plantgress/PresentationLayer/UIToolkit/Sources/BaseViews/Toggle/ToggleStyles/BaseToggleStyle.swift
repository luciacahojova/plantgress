//
//  BaseToggleStyle.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 12.12.2024.
//

import SwiftUI

struct BaseToggleStyle: ToggleStyle {
    var onColor: Color
    var offColor: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            RoundedRectangle(cornerRadius: 16, style: .circular)
                .fill(configuration.isOn ? onColor : offColor)
                .frame(width: 50, height: 30)
                .overlay(
                    Circle()
                        .fill(Colors.white)
                        .shadow(radius: 1, x: 0, y: 1)
                        .padding(Constants.Spacing.xSmall)
                        .offset(x: configuration.isOn ? 10 : -10)
                )
                .animation(.easeInOut(duration: 0.1), value: configuration.isOn)
        }
    }
}

#Preview {
    VStack {
        Toggle(isOn: .constant(true)) {}
            .toggleStyle(
                BaseToggleStyle(
                    onColor: Colors.primaryText,
                    offColor: .gray
                )
            )
        
        Toggle(isOn: .constant(false)) {}
            .toggleStyle(
                BaseToggleStyle(
                    onColor: Colors.primaryText,
                    offColor: .gray
                )
            )
    }
    .colorScheme(.dark)
}
