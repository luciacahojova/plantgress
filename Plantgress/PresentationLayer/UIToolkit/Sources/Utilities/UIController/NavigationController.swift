//
//  NavigationController.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 03.12.2024.
//

import UIKit

public final class NavigationController: UINavigationController {
    
    private var statusBarStyle: UIStatusBarStyle = .default
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    override public var childForStatusBarStyle: UIViewController? {
        return visibleViewController
    }
    
    public convenience init(statusBarStyle: UIStatusBarStyle) {
        self.init(nibName: nil, bundle: nil)
        self.statusBarStyle = statusBarStyle
    }
}
