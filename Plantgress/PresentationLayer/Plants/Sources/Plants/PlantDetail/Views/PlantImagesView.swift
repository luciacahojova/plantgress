//
//  PlantImagesView.swift
//  Plants
//
//  Created by Lucia Cahojova on 30.12.2024.
//

import Resolver
import SharedDomain
import SwiftUI
import UIToolkit

struct PlantImagesView: View {
    
    private let images: [ImageData]
    @State private var selectedImage: UUID
    
    private let imageHeight: CGFloat = 355
    
    init(
        images: [ImageData]
    ) {
        self.images = images
        self.selectedImage = images.first?.id ?? UUID()
    }
    
    var body: some View {
        VStack {
            if !images.isEmpty {
                TabView(selection: $selectedImage) {
                    ForEach(images, id: \.id) { image in
                        ZStack(alignment: .top) {
                            RemoteImage(
                                urlString: image.urlString,
                                contentMode: .fill,
                                height: imageHeight
                            )
                            .frame(width: UIScreen.main.bounds.size.width, height: imageHeight)
                            .clipped()
                            
                            VStack(spacing: Constants.Spacing.xSmall) {
                                Text(image.date.toString(formatter: Formatter.Date.MMMdyyyy))
                                    .font(Fonts.calloutSemibold)
                                
                                Text(image.date.toString(formatter: Formatter.Date.HHmm))
                                    .font(Fonts.captionMedium)
                            }
                            .padding(.horizontal, Constants.Spacing.xMedium)
                            .padding(.top, Constants.Spacing.medium)
                            .padding(.bottom, Constants.Spacing.small)
                            .background(Colors.secondaryBackground.opacity(0.8))
                            .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.xxxLarge))
                            .padding(.top, Constants.statusBarHeight + Constants.Spacing.small)
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .tag(image.id)
                    }
                }
                .frame(height: imageHeight)
                .tabViewStyle(PageTabViewStyle())
            } else {
                Icons.placeholder
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Colors.primaryText)
                    .frame(maxWidth: .infinity)
                    .frame(height: Constants.IconSize.large)
                    .frame(height: imageHeight)
                    .background(Colors.secondaryBackground)
            }
        }
        .onAppear {
            selectedImage = images.first?.id ?? UUID()
        }
        .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    Resolver.registerUseCasesForPreviews()
    
    return PlantImagesView(
        images: .mock
    )
    .frame(maxHeight: .infinity)
    .background(Colors.primaryBackground)
}
