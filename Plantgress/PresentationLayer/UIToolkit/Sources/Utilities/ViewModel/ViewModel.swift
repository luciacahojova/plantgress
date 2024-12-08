//
//  ViewModel.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 04.12.2024.
//

@MainActor
public protocol ViewModel {
    // Lifecycle
    func onAppear()
    func onDisappear()
    
    // State
    associatedtype State
    var state: State { get }
    
    // Intent
    associatedtype Intent
    func onIntent(_ intent: Intent)
}
