//
//  ProfileFlowController.swift
//  Profile
//
//  Created by Lucia Cahojova on 03.12.2024.
//

import UIToolkit
import UIKit

enum ProfileFlow: Flow {
    
}

public final class ProfileFlowController: FlowController {
    
    public override func setup() -> UIViewController {
        let view = ProfileOverviewView()
        let vc = HostingController(rootView: view)
        
        return vc
    }
    
    public override func handleFlow(_ flow: Flow) {
        guard let flow = flow as? ProfileFlow else { return }
        switch flow {
            
        }
    }
}
