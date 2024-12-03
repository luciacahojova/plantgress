//
//  MainFlowController.swift
//  Plantgress
//
//  Created by Lucia Cahojova on 03.12.2024.
//

import UIToolkit
import UIKit
import Plants
import Explore
import Profile

enum MainTab: Int {
    case plants
    case explore
    case profile
}

protocol MainFlowControllerDelegate: AnyObject {
    func presentOnboarding(
        message: String?,
        animated: Bool,
        completion: (() -> Void)?
    )
}

final class MainFlowController: FlowController {
    
    weak var delegate: MainFlowControllerDelegate?
    
    override func setup() -> UIViewController {
        let main = UITabBarController()
        main.viewControllers = [setupPlantsTab(), setupDiagnosticsTab(), setupProfileTab()]
        return main
    }
    
    private func setupPlantsTab() -> UINavigationController {
        let nc = NavigationController()
        nc.tabBarItem = UITabBarItem(
            title: "Plants",
            image: UIImage(systemName: "pencil"),
            tag: MainTab.plants.rawValue
        )
        let fc = PlantsFlowController(navigationController: nc)
//        fc.delegate = self
        let rootVC = startChildFlow(fc)
        nc.viewControllers = [rootVC]
        return nc
    }
    
    private func setupDiagnosticsTab() -> UINavigationController {
        let nc = NavigationController()
        nc.tabBarItem = UITabBarItem(
            title: "Explore",
            image: UIImage(systemName: "pencil"),
            tag: MainTab.explore.rawValue
        )
        let fc = ExploreFlowController(navigationController: nc)
        let rootVC = startChildFlow(fc)
        nc.viewControllers = [rootVC]
        return nc
    }
    
    private func setupProfileTab() -> UINavigationController {
        let nc = NavigationController()
        nc.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "pencil"),
            tag: MainTab.profile.rawValue
        )
        let fc = PlantsFlowController(navigationController: nc)
//        fc.delegate = self
        let vc = startChildFlow(fc)
        nc.viewControllers = [vc]
        return nc
    }
    
    func presentOnboarding(message: String?) {
        delegate?.presentOnboarding(
            message: message,
            animated: true
        ) { [weak self] in
            self?.navigationController.viewControllers = []
            self?.stopFlow()
        }
    }
    
    @discardableResult private func switchTab(_ index: MainTab) -> FlowController? {
        guard let tabController = rootViewController as? UITabBarController,
            let tabs = tabController.viewControllers, index.rawValue < tabs.count else { return nil }
        tabController.selectedIndex = index.rawValue
        return childControllers[index.rawValue]
    }
}
