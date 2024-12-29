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
            Text(Strings.plantCreationImages) 
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
                    .frame(
                        height: imageSize + Constants.Spacing.small,
                        alignment: .bottom
                    )
                    
                    ForEach(images, id: \.id) { image in
                        ZStack(alignment: .topTrailing) {
                            RemoteImage(
                                urlString: image.urlString,
                                contentMode: .fill,
                                customPlaceholder: {
                                    ProgressView()
                                        .tint(Colors.primaryText)
                                }
                            )
                            .frame(width: imageSize, height: imageSize)
                            .cornerRadius(Constants.CornerRadius.large)
                            .clipped()
                            .overlay {
                                RoundedRectangle(cornerRadius: Constants.CornerRadius.large)
                                    .strokeBorder(Colors.secondaryBackground, lineWidth: 2)
                            }
                            .padding([.top, .trailing], Constants.Spacing.small)
                            
                            if !image.isLoading {
                                Button {
                                    deleteImageAction(image.id)
                                } label :{
                                    RoundedIcon(
                                        icon: Icons.trash,
                                        isFilled: true,
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.primaryText
                                    )
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
