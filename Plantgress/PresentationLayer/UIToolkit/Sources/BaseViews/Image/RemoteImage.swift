//
//  RemoteImage.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 15.12.2024.
//

import Resolver
import SharedDomain
import SwiftUI

public struct RemoteImage: View {
    private let urlString: String?
    private let contentMode: ContentMode
    private let height: CGFloat?
    
    public init(
        urlString: String?,
        contentMode: ContentMode = .fit,
        height: CGFloat? = nil
    ) {
        self.urlString = urlString
        self.contentMode = contentMode
        self.height = height
    }

    public var body: some View {
        if let urlString, let url = URL(string: urlString) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: self.contentMode)
                        .frame(height: self.height)
                        .clipped()
                case .failure:
                    Colors.secondaryBackground
                case .empty:
                    ProgressView()
                @unknown default:
                    Colors.secondaryBackground
                }
            }
        } else {
            Colors.secondaryBackground
        }
    }
}

#Preview {
    Resolver.registerUseCasesForPreviews()
    
    return RemoteImage(
        urlString: "https://fastly.picsum.photos/id/248/3872/2592.jpg?hmac=_F3LsKQyGyWnwQJogUtsd_wyx2YDYnYZ6VZmSMBCxNI"
    )
}
