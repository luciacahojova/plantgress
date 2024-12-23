//
//  PlantsFlowController.swift
//  Plants
//
//  Created by Lucia Cahojova on 03.12.2024.
//

import UIToolkit
import UIKit

enum PlantsFlow: Flow {
    case openSettings
    case showPlantDetail(UUID)
    case showRoomDetail(UUID)
    case showAddPlant(editingId: UUID?, onShouldRefresh: () -> Void)
    case showAddRoom(editingId: UUID?, onShouldRefresh: () -> Void)
    case presentAddTask(editingId: UUID?, onShouldRefresh: () -> Void)
    case showPlantSettings(plantId: UUID?, onShouldRefresh: () -> Void)
}

public final class PlantsFlowController: FlowController {
    
    public override func setup() -> UIViewController {
        let vm = PlantsOverviewViewModel(
            flowController: self
        )
        let view = PlantsOverviewView(
            viewModel: vm
        )
        let vc = HostingController(
            rootView: view,
            title: Strings.plantsTitle
        )
        
        return vc
    }
    
    public override func handleFlow(_ flow: Flow) {
        guard let flow = flow as? PlantsFlow else { return }
        switch flow {
        case .openSettings: openSettings()
        case .showPlantDetail(let plantId): showPlantDetail(plantId)
        case .showRoomDetail(let roomId): showRoomDetail(roomId)
        case let .showAddPlant(editingId, onShouldRefresh): showAddPlant(editingId: editingId, onShouldRefresh: onShouldRefresh)
        case let .showAddRoom(editingId, onShouldRefresh): showAddRoom(editingId: editingId, onShouldRefresh: onShouldRefresh)
        case let .presentAddTask(editingId, onShouldRefresh): presentAddTask(editingId: editingId, onShouldRefresh: onShouldRefresh)
        case let .showPlantSettings(plantId, onShouldRefresh): showPlantSettings(plantId: plantId, onShouldRefresh: onShouldRefresh)
        }
    }
    
    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func showPlantDetail(_ plantId: UUID) {
        
    }
    
    private func showRoomDetail(_ roomId: UUID) {
        
    }
    
    private func showAddPlant(
        editingId: UUID?,
        onShouldRefresh: @escaping () -> Void
    ) {
        #warning("TODO: Add implementation")
    }
    
    private func showAddRoom(
        editingId: UUID?,
        onShouldRefresh: @escaping () -> Void
    ) {
        #warning("TODO: Add implementation")
    }
    
    private func presentAddTask(
        editingId: UUID?,
        onShouldRefresh: @escaping () -> Void
    ) {
        #warning("TODO: Add implementation")
    }
    
    private func showPlantSettings(
        plantId: UUID?,
        onShouldRefresh: @escaping () -> Void
    ) {
        #warning("TODO: Add implementation")
    }
}
