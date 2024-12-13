//
//  PlantsFlowController.swift
//  Plants
//
//  Created by Lucia Cahojova on 03.12.2024.
//

import UIToolkit
import UIKit

enum PlantsFlow: Flow {
    
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
            
        }
    }
}
