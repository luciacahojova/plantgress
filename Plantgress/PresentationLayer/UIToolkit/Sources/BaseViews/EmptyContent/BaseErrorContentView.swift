//
//  BaseErrorContentView.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import SwiftUI

public struct BaseErrorContentView: View {
    
    private let errorMessage: String
    private let refreshAction: () -> Void
    private let fixedTopPadding: CGFloat
    
    public init(
        errorMessage: String = Strings.defaultErrorMessage,
        refreshAction: @escaping () -> Void,
        fixedTopPadding: CGFloat = 0
    ) {
        self.errorMessage = errorMessage
        self.refreshAction = refreshAction
        self.fixedTopPadding = fixedTopPadding
    }
    
    public var body: some View {
        VStack(spacing: Constants.Spacing.mediumLarge) {
            Spacer()
                .frame(height: fixedTopPadding)
            
            Button(action: refreshAction) {
                Text("🔄")
                    .font(Fonts.largeTitleBold)
            }
            
            Text(errorMessage)
                .font(Fonts.bodySemibold)
        }
        .foregroundStyle(Colors.secondaryText)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    BaseErrorContentView(
        errorMessage: "Something went wrong.",
        refreshAction: {}
    )
}
