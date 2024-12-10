//
//  HostingController.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 03.12.2024.
//

import SwiftUI

public class HostingController<Content>: UIHostingController<AnyView> where Content: View {

    private let prefersLargeTitles: Bool
    private let showsNavigationBar: Bool
    private var statusBarStyle: UIStatusBarStyle?
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle ?? navigationController?.preferredStatusBarStyle ?? .default
    }
    
    public init(
        rootView: Content,
        title: String? = nil,
        prefersLargeTitles: Bool = true,
        showsNavigationBar: Bool = true,
        statusBarStyle: UIStatusBarStyle? = nil
    ) {
        self.showsNavigationBar = showsNavigationBar
        self.prefersLargeTitles = prefersLargeTitles
        super.init(
            rootView: AnyView(
                GeometryReader { geo in
                    VStack(alignment: .leading) {
                        if !showsNavigationBar, let title {
                            Text(title)
                                .font(Fonts.largeTitleBold)
                                .foregroundStyle(Colors.primaryText)
                                .padding(.horizontal)
                                .edgesIgnoringSafeArea(.top)
                                .padding(.top, geo.safeAreaInsets.top)
                        }
                        
                        rootView
                            .navigationBarTitleDisplayMode(.large)
                            .navigationBarHidden(!showsNavigationBar)
                    }
                }
            )
        )
        self.title = title
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitles
        navigationController?.setNavigationBarHidden(!showsNavigationBar, animated: animated)
    }
    
    dynamic required init?(coder aDecoder: NSCoder) {
        self.showsNavigationBar = true
        self.prefersLargeTitles = false
        super.init(coder: aDecoder)
    }
    
    deinit {
        print("\(type(of: self)) deinitialized")
    }
    
    private func setupUI() {
        view.backgroundColor = Asset.Colors.primaryBackground.uiColor
        navigationItem.backBarButtonItem = UIBarButtonItem(image: nil, style: .done, target: nil, action: nil)
    }
}
