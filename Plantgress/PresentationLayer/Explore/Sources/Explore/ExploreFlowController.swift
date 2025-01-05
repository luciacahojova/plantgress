//
//  ExploreFlowController.swift
//  Explore
//
//  Created by Lucia Cahojova on 03.12.2024.
//

import UIToolkit
import UIKit

public enum ExploreFlow: Flow {
    case showPlantDiagnostics
    case showLuxmeter
}

public final class ExploreFlowController: FlowController {
    
    public override func setup() -> UIViewController {
        let vm = ExploreOverviewViewModel(flowController: self)
        
        let view = ExploreOverviewView(viewModel: vm)
        let vc = HostingController(
            rootView: view,
            title: Strings.exploreTitleWithEmoji
        )
        
        return vc
    }
    
    public override func handleFlow(_ flow: Flow) {
        guard let flow = flow as? ExploreFlow else { return }
        switch flow {
        case .showPlantDiagnostics: showPlantDiagnostics()
        case .showLuxmeter: showLuxmeter()
        }
    }
    
    private func showPlantDiagnostics() {
        #warning("TOOD: Add implementation")
    }
    
    private func showLuxmeter() {
        #warning("TOOD: Add implementation")
    }
}
