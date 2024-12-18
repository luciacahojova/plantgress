//
//  DynamicImagesView.swift
//  Plants
//
//  Created by Lucia Cahojova on 15.12.2024.
//

import Resolver
import SwiftUI
import UIToolkit

struct DynamicImagesView: View {
    private let urlStrings: [String]
    private let secondImageWidth: CGFloat
    
    init(
        urlStrings: [String]
    ) {
        self.urlStrings = urlStrings
        self.secondImageWidth = .random(in: 170...200)
    }
    
    var body: some View {
        HStack(spacing: 0) {
            if let firstImageUrl =  urlStrings.first {
                RemoteImage(urlString: firstImageUrl, contentMode: .fill)
                    .clipped()
            }
            
            if urlStrings.count > 1, let secondImageUrl = urlStrings.last {
                RemoteImage(urlString: secondImageUrl, contentMode: .fill)
                    .frame(width: secondImageWidth)
                    .clipped()
            }
        }
        // Workaround because without specifying the width the images stretched too much
        // The value should match the padding on the RoomList
        .frame(width: UIScreen.main.bounds.size.width - Constants.Spacing.mediumLarge*2)
        .clipped()
    }
}

#Preview {
    Resolver.registerUseCasesForPreviews()
    
    return DynamicImagesView(
        urlStrings: [
            "https://fastly.picsum.photos/id/248/3872/2592.jpg?hmac=_F3LsKQyGyWnwQJogUtsd_wyx2YDYnYZ6VZmSMBCxNI",
            "https://fastly.picsum.photos/id/248/3872/2592.jpg?hmac=_F3LsKQyGyWnwQJogUtsd_wyx2YDYnYZ6VZmSMBCxNI"
        ]
    )
    .frame(height: 150)
    .padding()
}
