//
//  HostingController.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 03.12.2024.
//

import SwiftUI

public class HostingController<Content>: UIHostingController<Content> where Content: View {
    
    private var statusBarStyle: UIStatusBarStyle?
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle ?? navigationController?.preferredStatusBarStyle ?? .default
    }
    
    public convenience init(rootView: Content, statusBarStyle: UIStatusBarStyle) {
        self.init(rootView: rootView)
        self.statusBarStyle = statusBarStyle
    }
    
    override public init(rootView: Content) {
        super.init(rootView: rootView)
        print("\(type(of: self)) initialized")
        setupUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("\(type(of: self)) initialized")
        setupUI()
    }
    
    deinit {
        print("\(type(of: self)) deinitialized")
    }
    
    private func setupUI() {
        #warning("TODO: Setup UI")
    }
}
