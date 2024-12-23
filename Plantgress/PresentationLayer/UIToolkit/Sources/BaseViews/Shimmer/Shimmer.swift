//
//  SwiftUIView.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 16.12.2024.
//

import SwiftUI

public struct Shimmer: ViewModifier {
    @State private var phase: CGFloat = 0.0
    
    var duration: CGFloat
    var bounce: Bool
    
    init(
        duration: CGFloat,
        bounce: Bool
    ) {
        self.duration = duration
        self.bounce = bounce
    }

    public func body(content: Content) -> some View {
        content
            .modifier(AnimatedMask(phase: phase))
            .onAppear {
                startAnimation()
            }
            .cornerRadius(10)
    }

    private func startAnimation() {
        withAnimation(
            Animation.timingCurve(0.1, 0.2, 0.9, 1.0, duration: duration)
                .repeatForever(autoreverses: bounce)
        ) {
            phase = 1
        }
    }
    
    struct AnimatedMask: AnimatableModifier {
        var phase: CGFloat = 0

        var animatableData: CGFloat {
            get { phase }
            set { phase = newValue }
        }

        func body(content: Content) -> some View {
            content
                .mask(
                    GradientMask(phase: phase)
                        .scaleEffect(7)
                )
        }
    }
    
    struct GradientMask: View {
        let phase: CGFloat
        let centerColor = Color.black.opacity(0.7)
        let edgeColor = Color.black.opacity(0.6)

        var body: some View {
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: edgeColor, location: phase),
                    .init(color: centerColor, location: phase + 0.2),
                    .init(color: edgeColor, location: phase + 0.4)
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
        }
    }
}
