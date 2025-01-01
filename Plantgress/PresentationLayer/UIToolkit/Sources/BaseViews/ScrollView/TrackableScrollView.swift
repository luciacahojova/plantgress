//
//  TrackableScrollView.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 30.12.2024.
//

import SwiftUI

public struct TrackableScrollView<Content: View>: View {
    
    private let axes: Axis.Set
    private let showsIndicators: Bool
    private let content: Content
    
    @Binding private var contentOffset: CGFloat
    
    @Namespace private var scrollCoordinateSpace
    
    public init(
        axes: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        contentOffset: Binding<CGFloat>,
        @ViewBuilder content: () -> Content
    ) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self._contentOffset = contentOffset
        self.content = content()
    }
    
    public var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            VStack(spacing: 0) {
                content
                    .background(
                        GeometryReader {
                            Color.clear.preference(
                                key: ViewOffsetKey.self,
                                value: -$0.frame(in: .named(scrollCoordinateSpace)).origin.y
                            )
                        }
                    )
            }
            .onPreferenceChange(ViewOffsetKey.self) { value in
                contentOffset = value
            }
        }
        .coordinateSpace(name: scrollCoordinateSpace)
    }
}

struct ViewOffsetKey: PreferenceKey {
    
    typealias Value = CGFloat
    
    static var defaultValue = CGFloat.zero
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

#Preview {
    TrackableScrollView(
        contentOffset: .constant(0.0),
        content: {
            Text("Hello, World!")
        }
    )
}
