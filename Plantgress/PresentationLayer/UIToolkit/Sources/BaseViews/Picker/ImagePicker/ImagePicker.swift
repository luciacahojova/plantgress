//
//  ImagePicker.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 15.12.2024.
//

import PhotosUI
import SharedDomain
import SwiftUI

public struct ImagePicker: UIViewControllerRepresentable {
    @Binding private var images: [(Date, UIImage)]
    private let selectionLimit: Int
    
    public init(
        images: Binding<[(Date, UIImage)]>,
        selectionLimit: Int = 6
    ) {
        self._images = images
        self.selectionLimit = selectionLimit
    }
    
    public typealias UIViewControllerType = PHPickerViewController
    
    public func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        configuration.selectionLimit = self.selectionLimit
        configuration.selection = .ordered
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        
        return picker
    }
    
    public func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(with: self)
    }
    
    public class Coordinator: NSObject, PHPickerViewControllerDelegate, UIImagePickerControllerDelegate {
        var photoPicker: ImagePicker
        
        public init(with photoPicker: ImagePicker) {
            self.photoPicker = photoPicker
        }
        
        public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            loadMedia(from: results)
        }
        
        private func loadMedia(from results: [PHPickerResult]) {
            for result in results {
                if let assetIdentifier = result.assetIdentifier {
                    let assets = PHAsset.fetchAssets(withLocalIdentifiers: [assetIdentifier], options: nil)
                    guard let asset = assets.firstObject else { continue }
                    
                    let creationDate = asset.creationDate ?? Date()
                    
                    if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                            guard let self else { return }
                            
                            if let image = image as? UIImage {
                                DispatchQueue.main.async {
                                    self.photoPicker.images.append((creationDate, image))
                                }
                            } else if let error {
                                print("📷 Failed to load image: \(error.localizedDescription)")
                            }
                        }
                    }
                } else {
                    print("📷 No asset identifier available.")
                }
            }
        }
    }
}
