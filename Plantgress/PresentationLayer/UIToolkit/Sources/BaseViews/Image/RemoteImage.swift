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
    
    @Injected private var downloadImageUseCase: DownloadImageUseCase
    
    @State private var image: Image?
    private let urlString: String?
    private let placeholder: Image
    private let contentMode: ContentMode
    
    public init(
        urlString: String?,
        placeholder: Image = Asset.Icons.alarmClock.image, // TODO: placeholder
        contentMode: ContentMode = .fit
    ) {
        self.urlString = urlString
        self.placeholder = placeholder
        self.contentMode = contentMode
    }
    
    public var body: some View {
        VStack {
            if let image {
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else {
                Text("Placeholder")
            }
        }
        .onAppear {
            Task {
                guard let urlString else { return }
                image = await downloadImageUseCase.execute(urlString: urlString)
            }
        }
    }
}

#Preview {
    Resolver.registerUseCasesForPreviews()
    
    return RemoteImage(
        urlString: "https://fastly.picsum.photos/id/248/3872/2592.jpg?hmac=_F3LsKQyGyWnwQJogUtsd_wyx2YDYnYZ6VZmSMBCxNI"
    )
}
