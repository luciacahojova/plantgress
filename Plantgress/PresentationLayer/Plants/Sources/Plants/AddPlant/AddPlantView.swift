//
//  AddPlantView.swift
//  Plants
//
//  Created by Lucia Cahojova on 23.12.2024.
//

import Resolver
import SwiftUI
import UIToolkit

struct AddPlantView: View {
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: AddPlantViewModel
    
    private let images: [UIImage] = []
    
    // MARK: - Init
    
    init(viewModel: AddPlantViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                BaseList(title: "Name") { // TODO: String
                    OutlinedTextField(
                        text: Binding<String>(
                            get: { viewModel.state.name },
                            set: { newName in viewModel.onIntent(.nameChanged(newName))}
                        ),
                        placeholder: "Plant name", // TODO: String
                        backgroundColor: Colors.white,
                        deleteTextAction: {
                            viewModel.onIntent(.nameChanged(""))
                        }
                    )
                }
                
                // TODO: Pick room handling
                
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .alert(item: Binding<AlertData?>(
            get: { viewModel.state.alertData },
            set: { alertData in
                viewModel.onIntent(.alertDataChanged(alertData))
            }
        )) { alert in .init(alert) }
        .snackbar(
            Binding<SnackbarData?>(
                get: { viewModel.state.snackbarData },
                set: { snackbarData in viewModel.onIntent(.snackbarDataChanged(snackbarData)) }
            )
        )
        .actionSheet(isPresented: Binding<Bool>(
            get: { viewModel.state.isImageSheetPresented },
            set: { _ in viewModel.onIntent(.toggleImageActionSheet) }
        )) {
            ImagePickerActionSheet(
                cameraAction: {
                    viewModel.onIntent(.toggleCameraPicker)
                },
                libraryAction: {
                    viewModel.onIntent(.toggleImagePicker)
                }
            )
            .actionSheet
        }
        .sheet(isPresented: Binding<Bool>(
            get: { viewModel.state.isImagePickerPresented },
            set: { _ in viewModel.onIntent(.toggleImagePicker) }
        )) {
            ImagePicker(
                images: Binding<[UIImage]>(
                    get: { images },
                    set: { images in
                        viewModel.onIntent(.uploadImages(images))
                    }
                )
            )
            .edgesIgnoringSafeArea(.bottom)
        }
        .fullScreenCover(isPresented: Binding<Bool>(
            get: { viewModel.state.isCameraPickerPresented },
            set: { _ in viewModel.onIntent(.toggleCameraPicker) }
        )) {
            CameraPicker(
                selectedImage: { image in
                    viewModel.onIntent(.uploadImage(image))
                }
            )
            .ignoresSafeArea(edges: .all)
        }
        .foregroundStyle(Colors.primaryText)
        .lifecycle(viewModel)
    }
}

#Preview {
    Resolver.registerUseCasesForPreviews()
    
    let viewModel = AddPlantViewModel(
        flowController: nil,
        editingId: nil,
        onShouldRefresh: {}
    )
    
    return AddPlantView(
        viewModel: viewModel
    )
    .background(Colors.primaryBackground)
}
