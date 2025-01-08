//
//  PlantsFlowController.swift
//  Plants
//
//  Created by Lucia Cahojova on 03.12.2024.
//

import SharedDomain
import UIToolkit
import UIKit

public enum PlantsFlow: Flow, Equatable {
    case openSettings
    case showPlantDetail(plantId: UUID, onShouldRefresh: () -> Void)
    case showRoomDetail(UUID)
    case showAddPlant(editingId: UUID?, plantName: String?, onShouldRefresh: () -> Void)
    case showAddRoom(editingId: UUID?, onShouldRefresh: () -> Void)
    case presentAddTask(editingId: UUID?, onShouldRefresh: () -> Void)
    case showPlantSettings(plantId: UUID?, onShouldRefresh: () -> Void)
    case presentPickRoom(selectedRoom: Room?, onSave: (Room?) -> Void)
    case presentPickPlants(selectedPlants: [Plant], onSave: ([Plant]) -> Void)
    case showPeriodSettings(periods: [TaskPeriod], onSave: ([TaskPeriod]) -> Void)
    case presentShareImages(images: [UIImage], onShareSuccess: () -> Void)
    case dismiss
    case pop
    case popToRoot
    
    public static func == (lhs: PlantsFlow, rhs: PlantsFlow) -> Bool {
        switch (lhs, rhs) {
        case (.openSettings, .openSettings),
             (.dismiss, .dismiss),
             (.pop, .pop),
             (.presentPickRoom, .presentPickRoom):
            return true
        case let (.showPlantDetail(id1, _), .showPlantDetail(id2, _)):
            return id1 == id2
        case let (.showRoomDetail(id1), .showRoomDetail(id2)):
            return id1 == id2
        case let (.showAddPlant(id1, name1, _), .showAddPlant(id2, name2, _)):
            return id1 == id2 && name1 == name2
        case let (.showAddRoom(id1, _), .showAddRoom(id2, _)):
            return id1 == id2
        case let (.presentAddTask(id1, _), .presentAddTask(id2, _)):
            return id1 == id2
        case let (.showPlantSettings(id1, _), .showPlantSettings(id2, _)):
            return id1 == id2
        case let (.presentPickPlants(selected1, _), .presentPickPlants(selected2, _)):
            return selected1 == selected2
        case let (.showPeriodSettings(periods1, _), .showPeriodSettings(periods2, _)):
            return periods1 == periods2
        case let (.presentShareImages(images1, _), .presentShareImages(images2, _)):
            return images1 == images2
        default:
            return false
        }
    }
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
        case let .showPlantDetail(plantId, onShouldRefresh): showPlantDetail(plantId, onShouldRefresh: onShouldRefresh)
        case .showRoomDetail(let roomId): showRoomDetail(roomId)
        case let .showAddPlant(editingId, plantName, onShouldRefresh): showAddPlant(
            editingId: editingId,
            plantName: plantName,
            onShouldRefresh: onShouldRefresh
        )
        case let .showAddRoom(editingId, onShouldRefresh): showAddRoom(
            editingId: editingId,
            onShouldRefresh: onShouldRefresh
        )
        case let .presentAddTask(editingId, onShouldRefresh): presentAddTask(editingId: editingId, onShouldRefresh: onShouldRefresh)
        case let .showPlantSettings(plantId, onShouldRefresh): showPlantSettings(plantId: plantId, onShouldRefresh: onShouldRefresh)
        case let .presentPickRoom(selectedRoom, onSave): presentPickRoom(selectedRoom: selectedRoom, onSave: onSave)
        case let .presentPickPlants(selectedPlants, onSave): presentPickPlants(selectedPlants: selectedPlants, onSave: onSave)
        case let .showPeriodSettings(periods, onSave): showPeriodSettings(periods: periods, onSave: onSave)
        case let .presentShareImages(images, onShareSuccess): presentShareImages(images: images, onShareSuccess: onShareSuccess)
        case .dismiss: dismissView()
        case .pop: pop()
        case .popToRoot: popToRoot()
        }
    }
    
    private func presentShareImages(
        images: [UIImage],
        onShareSuccess: @escaping () -> Void
    ) {
        let activityViewController = UIActivityViewController(activityItems: images, applicationActivities: nil)

        activityViewController.completionWithItemsHandler = { activityType, completed, returnedItems, error in
            if completed {
                onShareSuccess()
            }
        }

        navigationController.present(activityViewController, animated: true)
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
    
    private func showPlantDetail(
        _ plantId: UUID,
        onShouldRefresh: @escaping () -> Void
    ) {
        let vm = PlantDetailViewModel(
            flowController: self,
            plantId: plantId,
            onShouldRefresh: onShouldRefresh
        )
        let view = PlantDetailView(viewModel: vm)
        let vc = HostingController(
            rootView: view,
            showsNavigationBar: false
        )
        
        navigationController.show(vc, sender: nil)
    }
    
    private func showRoomDetail(_ roomId: UUID) {
        let vm = RoomDetailViewModel(
            flowController: self,
            roomId: roomId
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
        onShouldRefresh: @escaping () -> Void
    ) {
        let vm = AddRoomViewModel(
            flowController: self,
            editingId: editingId,
            onShouldRefresh: onShouldRefresh
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
        selectedRoom: Room?,
        onSave: @escaping (Room?) -> Void
    ) {
        let vm = SelectRoomViewModel(
            flowController: self,
            selectedRoom: selectedRoom,
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
    
    private func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
}
