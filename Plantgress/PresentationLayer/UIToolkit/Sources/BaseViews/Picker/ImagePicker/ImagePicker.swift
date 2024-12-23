//
//  ImagePicker.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 15.12.2024.
//

import PhotosUI
import SwiftUI

public struct ImagePicker: UIViewControllerRepresentable {
    @Binding private var images: [UIImage]
    private let selectionLimit: Int
    
    public init(
        images: Binding<[UIImage]>,
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
        configuration.preselectedAssetIdentifiers = self.images.compactMap { media in
            return media.accessibilityIdentifier
        }
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
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                        guard let self else { return }
                        
                        if let image = image as? UIImage {
                            DispatchQueue.main.schedule {
                                self.photoPicker.images.append(image)
                            }
                        } else if let error {
                            print("📷 Failed to load image \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
}
