//
//  Font+Extensions.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 07.12.2024.
//

import SwiftUICore
import UIKit

extension Font {
    static func custom(
        relativeTo style: UIFont.TextStyle,
        size: CGFloat?,
        weight: UIFont.Weight = .regular
    ) -> Font {
        let uiFont: UIFont = UIFont.custom(relativeTo: style, size: size, weight: weight)
        return Font(uiFont)
    }
}
