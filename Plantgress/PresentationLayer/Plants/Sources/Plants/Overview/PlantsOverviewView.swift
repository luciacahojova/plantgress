//
//  PlantsOverviewView.swift
//  Plants
//
//  Created by Lucia Cahojova on 03.12.2024.
//

import Resolver
import SharedDomain
import SwiftUI
import UIToolkit
import AVFoundation // TODO: Delete
import Photos
import PhotosUI

struct PlantsOverviewView: View {
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: PlantsOverviewViewModel
    
    @State private var isCameraPickerPresented = false
    @State private var isImagePickerPresented = false
    @State private var isImageSheetPresented = false
    private let images: [UIImage] = []

    // MARK: - Init
    
    init(viewModel: PlantsOverviewViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Constants.Spacing.xLarge) {
                SectionPicker(
                    selectedOption: Binding<PlantsOverviewViewModel.SectionPickerOption> (
                        get: { viewModel.selectedSection },
                        set: { selectedSection in
                            viewModel.onIntent(.selectedSectionChanged(selectedSection))
                        }
                    ),
                    options: PlantsOverviewViewModel.SectionPickerOption.allCases
                ) { option in
                    Text(option.sectionTitle)
                }
                
                VStack(spacing: Constants.Spacing.large) {
                    switch viewModel.selectedSection {
                    case .plants:
                        PlantList(
                            plants: .mock, // TODO: Actual data
                            trackPlantProgressAction: { plantId in
                                isImageSheetPresented = true
                            },
                            trackTaskAction: { taskType in
                                // TODO: Add task + show snackbar
                            }
                        )
                    case .rooms:
                        Text("Room")
                        Text("Room")
                        Text("Room")
                    case .tasks:
                        Text("Task")
                        Text("Task")
                        Text("Task")
                    }
                }
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.onIntent(.plusButtonTapped)
                } label: {
                    Asset.Icons.plus.image
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                }
            }
        }
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
        .actionSheet(isPresented: $isImageSheetPresented) {
            ImagePickerActionSheet(
                cameraAction: {
                    self.isCameraPickerPresented.toggle()
                    
                    
                    
                    
                    
                },
                libraryAction: {
                    self.isImagePickerPresented.toggle()
//                    let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
//                        switch status {
//                        case .authorized:
//                            print("Authorized")
//                            self.isImagePickerPresented.toggle()
//                        case .notDetermined:
//                           PHPhotoLibrary.requestAuthorization(for: .readWrite) { authStatus in
//                               switch authStatus {
//                               case .notDetermined:
//                                   print("DenotDeterminednied")
//                               case .restricted:
//                                   print("restricted")
//                               case .denied:
//                                   print("denied")
//                               case .authorized:
//                                   print("authorized")
//                               case .limited:
//                                   print("limited")
//                               @unknown default:
//                                   print("default")
//                               }
//                           }
//                        case .restricted, .denied:
//                            print("Denied")
//                        case .limited:
//                            print("Limited")
//                        @unknown default:
//                            print("Default")
//                        }
//                    
                }
            )
            .actionSheet
        }
        .sheet(isPresented: $isImagePickerPresented) {
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
        .fullScreenCover(isPresented: $isCameraPickerPresented) {
            CameraPicker(
                selectedImage: { image in
                    viewModel.onIntent(.uploadImage(image))
//                    if let image, let data = image.jpegData(compressionQuality: 0.2) {
//                        viewModel.onIntent(.uploadImage(data: data))
//                    } else {
//                        print("No data")
//                    }
//                    guard let image = image?.fixOrientation(), let imageData = image.jpegData(compressionQuality: 0.2) else { return }
                    // TODO: Intent
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
    
    let vm = PlantsOverviewViewModel(flowController: nil)
    
    return PlantsOverviewView(viewModel: vm)
}
