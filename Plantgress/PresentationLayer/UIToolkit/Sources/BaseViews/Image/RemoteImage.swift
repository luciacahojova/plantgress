//
//  RemoteImage.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 15.12.2024.
//

import Resolver
import SharedDomain
import SwiftUI

public struct RemoteImage<Content: View>: View {
    
    @Injected private var downloadImageUseCase: DownloadImageUseCase
    
    @State private var image: Image?
    
    private let urlString: String?
    private let contentMode: ContentMode
    private let height: CGFloat?
    private var placeholder: Content

    public init(
        urlString: String?,
        contentMode: ContentMode = .fit,
        height: CGFloat? = nil,
        @ViewBuilder customPlaceholder: () -> Content = {
            Icons.placeholder
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: Constants.IconSize.large)
                .foregroundStyle(Colors.secondaryText)
        }
    ) {
        self.urlString = urlString
        self.contentMode = contentMode
        self.height = height
        self.placeholder = customPlaceholder()
    }

    public var body: some View {
        VStack {
            if let image {
                image
                    .resizable()
                    .aspectRatio(contentMode: self.contentMode)
                    .frame(height: self.height)
                    .clipped()
            } else if let urlString {
                placeholder
                    .onAppear {
                        Task {
                            image = await downloadImageUseCase.execute(urlString: urlString)
                        }
                    }
            } else {
                placeholder
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Colors.green)
    }
}

#Preview {
    Resolver.registerUseCaseMocks()
    
    return RemoteImage(
        urlString: "https://fastly.picsum.photos/id/248/3872/2592.jpg?hmac=_F3LsKQyGyWnwQJogUtsd_wyx2YDYnYZ6VZmSMBCxNI"
    )
}
