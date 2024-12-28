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
        VStack(alignment: .leading, spacing: Constants.Spacing.small) {
            Text("Images") // TODO: String
                .textCase(.uppercase)
                .padding(.leading, Constants.Spacing.medium + Constants.Spacing.mediumLarge)
                .font(Fonts.calloutSemibold)
                .foregroundStyle(Colors.secondaryText)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Constants.Spacing.medium) {
                    Button(action: addImageAction) {
                        ZStack {
                            Rectangle()
                                .fill(Colors.secondaryBackground)
                                .frame(width: imageSize, height: imageSize)
                                .cornerRadius(Constants.CornerRadius.large)
                            
                            Icons.plus
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(Colors.primaryText)
                                .frame(width: Constants.IconSize.xMedium)
                        }
                    }
                    
                    ForEach(images, id: \.id) { image in
                        Button { // TODO: New design with xmark
                            deleteImageAction(image.id)
                        } label: {
                            if let urlString = image.urlString {
                                RemoteImage(
                                    urlString: urlString,
                                    contentMode: .fill,
                                    customPlaceholder: { Color.clear } // TODO: keep default with new design
                                )
                                .frame(width: imageSize, height: imageSize)
                                .cornerRadius(Constants.CornerRadius.large)
                                .clipped()
                                .overlay {
                                    Colors.white.opacity(0.5)
                                        .cornerRadius(Constants.CornerRadius.large)
                                    
                                    if !image.isLoading {
                                        Icons.trash
                                            .renderingMode(.template)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: Constants.IconSize.xMedium)
                                            .foregroundStyle(Colors.secondaryBackground)
                                    }
                                    
                                    RoundedRectangle(cornerRadius: Constants.CornerRadius.large)
                                        .strokeBorder(Colors.secondaryBackground, lineWidth: 2)
                                }
                            } else {
                                ZStack {
                                    Colors.green
                                    
                                    Colors.white.opacity(0.5)
                                    
                                    ProgressView()
                                }
                                .frame(width: imageSize, height: imageSize)
                                .cornerRadius(Constants.CornerRadius.large)
                                .clipped()
                                .overlay {
                                    RoundedRectangle(cornerRadius: Constants.CornerRadius.large)
                                        .strokeBorder(Colors.white, lineWidth: 2)
                                }
                            }
                        }
                    }
                    
                }
                .padding(.horizontal)
            }
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
