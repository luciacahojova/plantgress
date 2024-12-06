//
//  BaseViewModel.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 04.12.2024.
//

import Foundation

@MainActor
open class BaseViewModel {
    
    /// All tasks that are currently executed
    public private(set) var tasks: [Task<Void, Never>] = []
    
    public init() {
        print("\(type(of: self)) initialized")
    }
    
    deinit {
        print("\(type(of: self)) deinitialized")
    }
    
    /// Override this method in a subclass for custom behavior when a view appears
    open func onAppear() {}
    
    /// Override this method in a subclass for custom behavior when a view disappears
    open func onDisappear() {
        // Cancel all tasks when we are going away
        tasks.forEach { $0.cancel() }
    }
    
    @discardableResult
    public func executeTask(_ task: Task<Void, Never>) -> Task<Void, Never> {
        tasks.append(task)
        Task {
            await task.value
            
            // Remove task when done
            objc_sync_enter(tasks)
            tasks = tasks.filter { $0 != task }
            objc_sync_exit(tasks)
        }
        return task
    }
    
    public func awaitAllTasks() async {
        for task in tasks { await task.value }
    }
}
