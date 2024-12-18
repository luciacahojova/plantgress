//
//  BaseEmptyContentView.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import SwiftUI

public struct BaseEmptyContentView: View {
    private let message: String
    private let fixedTopPadding: CGFloat
    
    public init(
        message: String,
        fixedTopPadding: CGFloat = 0
    ) {
        self.message = message
        self.fixedTopPadding = fixedTopPadding
    }
    
    public var body: some View {
        VStack(spacing: Constants.Spacing.mediumLarge) {
            Spacer()
                .frame(height: fixedTopPadding)
            
            Text("🌱")
                .font(Fonts.largeTitleBold)
            
            Text(message)
                .font(Fonts.bodySemibold)
        }
        .foregroundStyle(Colors.secondaryText)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    BaseEmptyContentView(
        message: "You haven't added any plants yet"
    )
}
