//
//  UIFont+Extensions.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 07.12.2024.
//

import UIKit

extension UIFont {
    class func custom(
        relativeTo style: TextStyle,
        size: CGFloat?,
        weight: Weight = .regular
    ) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        
        let descriptor = preferredFont(forTextStyle: style).fontDescriptor
        let defaultSize = descriptor.pointSize
        
        let fontToScale = UIFont.systemFont(ofSize: size ?? defaultSize, weight: weight)
        
        return metrics.scaledFont(for: fontToScale)
    }
}
