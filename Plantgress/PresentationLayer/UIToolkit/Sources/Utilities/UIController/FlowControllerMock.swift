//
//  FlowControllerMock.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 05.01.2025.
//

import Foundation

public class FlowControllerMock<T: Flow & Equatable>: FlowController {
    
    public var flowCount = 0
    public var flowValue: T?
    
    override public func handleFlow(_ flow: Flow) {
        flowCount += 1
        flowValue = flow as? T
    }
}
