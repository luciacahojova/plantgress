//
//  AddPlantImagesView.swift
//  Plants
//
//  Created by Lucia Cahojova on 23.12.2024.
//

import Resolver
import SharedDomain
import SwiftUI
import UIToolkit

struct AddPlantImagesView: View {
    
    private let images: [ImageData]
    private let addImageAction: () -> Void
    private let deleteImageAction: (UUID) -> Void
    
    private let imageSize: CGFloat = 100
    
    init(
        images: [ImageData],
        addImageAction: @escaping () -> Void,
        deleteImageAction: @escaping (UUID) -> Void
    ) {
        self.images = images
        self.addImageAction = addImageAction
        self.deleteImageAction = deleteImageAction
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Constants.Spacing.medium) {
                Button(action: addImageAction) {
                    ZStack {
                        Rectangle()
                            .fill(Colors.white)
                            .frame(width: imageSize, height: imageSize)
                            .cornerRadius(Constants.CornerRadius.large)
                        
                        Icons.plus
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(Colors.primaryText)
                            .frame(width: Constants.IconSize.small)
                    }
                }
                
                
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    Resolver.registerUseCasesForPreviews()
    
    return AddPlantImagesView(
        images: .mock,
        addImageAction: {},
        deleteImageAction: { _ in }
    )
    .background(Colors.primaryBackground)
}
