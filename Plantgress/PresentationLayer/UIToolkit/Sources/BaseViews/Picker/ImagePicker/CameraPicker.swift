//
//  CameraPicker.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 15.12.2024.
//

import PhotosUI
import SwiftUI

public struct CameraPicker: UIViewControllerRepresentable {

    var selectedImage: (UIImage?) -> Void
    @Environment(\.presentationMode) var isPresented
    
    public init(
        selectedImage: @escaping (UIImage?) -> Void
    ) {
        self.selectedImage = selectedImage
    }
    
    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
    
    public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var picker: CameraPicker
        
        public init(picker: CameraPicker) {
            self.picker = picker
        }
        
        public func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            guard let image = info[.originalImage] as? UIImage else {
                print("📷 Failed to load image")
                return
            }
            
            self.picker.selectedImage(image)
            self.picker.isPresented.wrappedValue.dismiss()
        }
    }
}
