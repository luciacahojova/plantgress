//
//  PlantsFlowController.swift
//  Plants
//
//  Created by Lucia Cahojova on 03.12.2024.
//

import SharedDomain
import UIToolkit
import UIKit

enum PlantsFlow: Flow {
    case openSettings
    case showPlantDetail(UUID)
    case showRoomDetail(Room)
    case showAddPlant(editingId: UUID?, plantName: String?, onShouldRefresh: () -> Void)
    case showAddRoom(editingId: UUID?, onShouldRefresh: () -> Void, onDelete: () -> Void)
    case presentAddTask(editingId: UUID?, onShouldRefresh: () -> Void)
    case showPlantSettings(plantId: UUID?, onShouldRefresh: () -> Void)
    case presentPickRoom(onSave: (Room?) -> Void)
    case presentPickPlants(selectedPlants: [Plant], onSave: ([Plant]) -> Void)
    case showPeriodSettings(periods: [TaskPeriod], onSave: ([TaskPeriod]) -> Void)
    case dismiss
    case pop
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
        case .showRoomDetail(let room): showRoomDetail(room)
        case let .showAddPlant(editingId, plantName, onShouldRefresh): showAddPlant(
            editingId: editingId,
            plantName: plantName,
            onShouldRefresh: onShouldRefresh
        )
        case let .showAddRoom(editingId, onShouldRefresh, onDelete): showAddRoom(
            editingId: editingId,
            onShouldRefresh: onShouldRefresh,
            onDelete: onDelete
        )
        case let .presentAddTask(editingId, onShouldRefresh): presentAddTask(editingId: editingId, onShouldRefresh: onShouldRefresh)
        case let .showPlantSettings(plantId, onShouldRefresh): showPlantSettings(plantId: plantId, onShouldRefresh: onShouldRefresh)
        case .presentPickRoom(let onSave): presentPickRoom(onSave: onSave)
        case let .presentPickPlants(selectedPlants, onSave): presentPickPlants(selectedPlants: selectedPlants, onSave: onSave)
        case let .showPeriodSettings(periods, onSave): showPeriodSettings(periods: periods, onSave: onSave)
        case .dismiss: dismissView()
        case .pop: pop()
        }
    }
    
    private func showPeriodSettings(
        periods: [TaskPeriod],
        onSave: @escaping ([TaskPeriod]) -> Void
    ) {
        let vm = PeriodSettingsViewModel(
            flowController: self,
            periods: periods,
            onSave: onSave
        )
        let view = PeriodSettingsView(viewModel: vm)
        let vc = HostingController(
            rootView: view,
            title: Strings.plantCreationAddAnotherTrackingPeriodsTitle,
            prefersLargeTitles: false
        )
        vc.hidesBottomBarWhenPushed = true
        
        navigationController.show(vc, sender: nil)
    }
    
    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func showPlantDetail(_ plantId: UUID) {
        let vm = PlantDetailViewModel(
            flowController: self,
            plantId: plantId
        )
        let view = PlantDetailView(viewModel: vm)
        let vc = HostingController(
            rootView: view,
            showsNavigationBar: false
        )
        
        navigationController.show(vc, sender: nil)
    }
    
    private func showRoomDetail(_ room: Room) {
        let vm = RoomDetailViewModel(
            flowController: self,
            room: room
        )
        let view = RoomDetailView(viewModel: vm)
        let vc = HostingController(
            rootView: view
        )
        
        navigationController.show(vc, sender: nil)
    }
    
    private func showAddPlant(
        editingId: UUID?,
        plantName: String? = nil,
        onShouldRefresh: @escaping () -> Void
    ) {
        let vm = AddPlantViewModel(
            flowController: self,
            editingId: editingId,
            onShouldRefresh: onShouldRefresh
        )
        let view = AddPlantView(viewModel: vm)
        let vc = HostingController(
            rootView: view,
            title: editingId != nil
                ? "\(plantName ?? "") \(Strings.settingsButton)"
                : Strings.plantCreationTitle
        )
        vc.hidesBottomBarWhenPushed = true
        
        navigationController.show(vc, sender: nil)
    }
    
    private func showAddRoom(
        editingId: UUID?,
        onShouldRefresh: @escaping () -> Void, 
        onDelete: @escaping () -> Void
    ) {
        let vm = AddRoomViewModel(
            flowController: self,
            editingId: editingId,
            onShouldRefresh: onShouldRefresh,
            onDelete: onDelete
        )
        let view = AddRoomView(viewModel: vm)
        let vc = HostingController(
            rootView: view,
            title: editingId != nil ? Strings.editRoomTitle : Strings.createRoomTitle
        )
        vc.hidesBottomBarWhenPushed = true
        
        navigationController.show(vc, sender: nil)
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
    
    private func dismissView() {
        navigationController.dismiss(animated: true)
    }
    
    private func presentPickRoom(
        onSave: @escaping (Room?) -> Void
    ) {
        let vm = SelectRoomViewModel(
            flowController: self,
            onSave: onSave
        )
        let view = SelectRoomView(viewModel: vm)
        let vc = HostingController(
            rootView: view
        )
        
        navigationController.present(vc, animated: true)
    }
    
    private func presentPickPlants(
        selectedPlants: [Plant],
        onSave: @escaping ([Plant]) -> Void
    ) {
        let vm = SelectPlantsViewModel(
            flowController: self,
            selectedPlants: selectedPlants,
            onSave: onSave
        )
        let view = SelectPlantsView(viewModel: vm)
        let vc = HostingController(
            rootView: view
        )
        
        navigationController.present(vc, animated: true)
    }
}
