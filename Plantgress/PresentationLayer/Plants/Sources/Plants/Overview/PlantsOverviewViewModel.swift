//
//  PlantsOverviewViewModel.swift
//  Plants
//
//  Created by Lucia Cahojova on 13.12.2024.
//

import Foundation
import SharedDomain
import UIToolkit
import UIKit

final class PlantsOverviewViewModel: BaseViewModel, ViewModel, ObservableObject {
    
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
            case .rooms: "Rooms" //Strings.roomsTitle
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
        case showPlantDetail(plantId: String)
        case alertDataChanged(AlertData?)
        case snackbarDataChanged(SnackbarData?)
        case selectedSectionChanged(SectionPickerOption)
    }

    func onIntent(_ intent: Intent) {
        switch intent {
        case .showPlantDetail(let plantId): showPlantDetail(plantId)
        case .snackbarDataChanged(let snackbarData): snackbarDataChanged(snackbarData)
        case .alertDataChanged(let alertData): alertDataChanged(alertData)
        case .selectedSectionChanged(let selectedSection): selectedSectionChanged(selectedSection)
        }
    }
    
    private func alertDataChanged(_ alertData: AlertData?) {
        state.alertData = alertData
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
        #warning("TODO: Handle flow")
    }
        
    private func updateTitle() {
        flowController?.navigationController.viewControllers.first?.title = selectedSection.title
    }
}
