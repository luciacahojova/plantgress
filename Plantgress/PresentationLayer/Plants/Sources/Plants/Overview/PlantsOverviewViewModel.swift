//
//  PlantsOverviewViewModel.swift
//  Plants
//
//  Created by Lucia Cahojova on 13.12.2024.
//

import Foundation
import Resolver
import SharedDomain
import UIToolkit
import UIKit
import SwiftUI

final class PlantsOverviewViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    @Injected private var uploadImageUseCase: UploadImageUseCase
    
    // MARK: - Dependencies
    
    private weak var flowController: FlowController?
    
    // MARK: - Init

    init(
        flowController: FlowController?
    ) {
        self.flowController = flowController
        super.init()
    }
    
    // MARK: - Lifecycle
    
    override func onAppear() {
        super.onAppear()
        
        updateTitle()
    }
    
    // MARK: - Tab selection
    
    
    enum SectionPickerOption: CaseIterable {
        case plants
        case rooms
        case tasks

        var title: String {
            switch self {
            case .plants: Strings.plantsTitleWithEmoji
            case .rooms: Strings.roomsTitleWithEmoji
            case .tasks: Strings.tasksTitleWithEmoji
            }
        }
        
        var sectionTitle: String {
            switch self {
            case .plants: Strings.plantsTitle
            case .rooms: Strings.roomsTitle
            case .tasks: Strings.tasksTitle
            }
        }
    }
    
    // MARK: - State
    
    @Published private(set) var state: State = State()
    @Published private(set) var selectedSection: SectionPickerOption = .plants {
        didSet {
            updateTitle()
        }
    }

    struct State {
        var alertData: AlertData?
        var snackbarData: SnackbarData?
    }
    
    // MARK: - Intent
    enum Intent {
        case plusButtonTapped
        
        case showPlantDetail(plantId: String)
        case showRoomDetail(roomId: String)
        
        case uploadImage
        
        case alertDataChanged(AlertData?)
        case snackbarDataChanged(SnackbarData?)
        
        case selectedSectionChanged(SectionPickerOption)
    }

    func onIntent(_ intent: Intent) {
        switch intent {
        case .plusButtonTapped: plusButtonTapped()
        case .showPlantDetail(let plantId): showPlantDetail(plantId)
        case .showRoomDetail(let roomId): showRoomDetail(roomId)
        case .uploadImage: uploadImage() // TODO: Delete
        case .snackbarDataChanged(let snackbarData): snackbarDataChanged(snackbarData)
        case .alertDataChanged(let alertData): alertDataChanged(alertData)
        case .selectedSectionChanged(let selectedSection): selectedSectionChanged(selectedSection)
        }
    }
    
    private func alertDataChanged(_ alertData: AlertData?) {
        state.alertData = alertData
    }
    
    private func plusButtonTapped() {
        switch selectedSection {
        case .plants:
            #warning("TODO: Handle flow")
        case .rooms:
            #warning("TODO: Handle flow")
        case .tasks:
            #warning("TODO: Handle flow")
        }
    }
    
    private func uploadImage() {
        let useCase = uploadImageUseCase
        executeTask(
            Task {
                do {
                    print("UPLOADING")
                    guard let data = Asset.Images.primaryOnboardingBackground.uiImage.jpegData(compressionQuality: 0.9) else {
                        throw ImagesError.invalidUrl
                    }
                    
                    let url = try await useCase.execute(
                        userId: "aaaa",
                        imageId: "aaaaaaaa",
                        imageData: data
                    )
                    print("New url: \(url)")
                } catch {
                    print("ERROR: \(error.localizedDescription)")
                }
            }
        )
    }
    
    private func snackbarDataChanged(_ snackbarData: SnackbarData?) {
        state.snackbarData = snackbarData
    }
    
    private func selectedSectionChanged(_ selectedSection: SectionPickerOption) {
        self.selectedSection = selectedSection
    }
    
    private func dismissAlert() {
        state.alertData = nil
    }
    
    private func showPlantDetail(_ plantId: String) {
        
    }
    
    private func showRoomDetail(_ roomId: String) {
        #warning("TODO: Handle flow")
    }
        
    private func updateTitle() {
        flowController?.navigationController.viewControllers.first?.title = selectedSection.title
        self.flowController?.navigationController.tabBarItem.title = nil
    }
}
