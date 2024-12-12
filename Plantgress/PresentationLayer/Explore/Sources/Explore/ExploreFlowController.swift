//
//  ExploreFlowController.swift
//  Explore
//
//  Created by Lucia Cahojova on 03.12.2024.
//

import UIToolkit
import UIKit

enum ExploreFlow: Flow {
    
}

public final class ExploreFlowController: FlowController {
    
    public override func setup() -> UIViewController {
        let view = ExploreOverviewView()
        let vc = HostingController(
            rootView: view,
            title: Strings.exploreTitle
        )
        
        return vc
    }
    
    public override func handleFlow(_ flow: Flow) {
        guard let flow = flow as? ExploreFlow else { return }
        switch flow {
            
        }
    }
}
