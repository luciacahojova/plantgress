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
    private let height: CGFloat
    
    init(
        urlStrings: [String],
        height: CGFloat
    ) {
        self.urlStrings = urlStrings
        self.height = height
    }
    
    var body: some View {
        let columns: [GridItem] = getDynamicColumns()
        
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(Array(urlStrings.enumerated()), id: \.offset) { _, urlString in
                RemoteImage(urlString: urlString, contentMode: .fill)
                    .frame(height: height)
                    .clipped()
            }
        }
        .frame(height: height)
    }
    
    private func getDynamicColumns() -> [GridItem] {
        switch urlStrings.count {
        case 1:
            return [GridItem(.flexible(), spacing: 0)]
        case 2:
            return [GridItem(.flexible(), spacing: 0), GridItem(.flexible(), spacing: 0)]
        default:
            return [GridItem(.flexible(), spacing: 0), GridItem(.flexible(), spacing: 0), GridItem(.flexible(), spacing: 0)]
        }
    }
}

#Preview {
    Resolver.registerUseCasesForPreviews()
    
    return DynamicImagesView(
        urlStrings: [
            "https://fastly.picsum.photos/id/248/3872/2592.jpg?hmac=_F3LsKQyGyWnwQJogUtsd_wyx2YDYnYZ6VZmSMBCxNI",
            "https://fastly.picsum.photos/id/248/3872/2592.jpg?hmac=_F3LsKQyGyWnwQJogUtsd_wyx2YDYnYZ6VZmSMBCxNI"
        ],
        height: 215
    )
    .padding()
}
