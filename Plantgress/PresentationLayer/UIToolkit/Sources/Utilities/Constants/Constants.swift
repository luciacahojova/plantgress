//
//  Constants.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 07.12.2024.
//

import UIKit

public struct Constants {
    
    // MARK: - Spacing
    public enum Spacing {
        /**
         * Spacing of 2
         */
        public static let xSmall: CGFloat = 2

        /**
         * Spacing of 4
         */
        public static let small: CGFloat = 4
        
        /**
         * Spacing of 8
         */
        public static let medium: CGFloat = 8
        
        /**
         * Spacing of 12
         */
        public static let xMedium: CGFloat = 12

        /**
         * Spacing of 16
         */
        public static let mediumLarge: CGFloat = 16
        
        /**
         * Spacing of 24
         */
        public static let large: CGFloat = 24
        
        /**
         * Spacing of 32
         */
        public static let xLarge: CGFloat = 32

        /**
         * Spacing of 36
         */
        public static let xxLarge: CGFloat = 36

        /**
         * Spacing of 40
         */
        public static let xxxLarge: CGFloat = 40

        /**
         * Spacing of 48
         */
        public static let xxxxLarge: CGFloat = 48
    }

    // MARK: - Icon Sizes
    public enum IconSize {
        /**
         * Icon size of 20
         */
        public static let small: CGFloat = 20

        /**
         * Icon size of 32
         */
        public static let medium: CGFloat = 32

        /**
         * Icon size of 40
         */
        public static let large: CGFloat = 40

        /**
         * Icon size of 200
         */
        public static let maxi: CGFloat = 200
    }
    
    // MARK: - Frames
    public enum Frame {
        /**
         * Frame of size 40
         */
        public static let primaryButtonHeight: CGFloat = 40
    }
    
    // MARK: - CornerRadiuses
    public enum CornerRadius {
        /**
         * CornerRadius of size 8
         */
        public static let small: CGFloat = 8
        
        /**
         * CornerRadius of size 12
         */
        public static let medium: CGFloat = 12
        
        /**
         * CornerRadius of size 16
         */
        public static let large: CGFloat = 16
        
        /**
         * CornerRadius of size 24
         */
        public static let xLarge: CGFloat = 24
        
        /**
         * CornerRadius of size 50
         */
        public static let xxxLarge: CGFloat = 50
    }
    
    // MARK: - List
    public enum List {
        /**
         * Corner radius of size 16
         */
        public static let cornerRadius: CGFloat = 16
        
        /**
         * Main HStack spacing of size 12
         */
        public static let spacing: CGFloat = 12
        
        /**
         * Spacing between trailing text and icon of size 4
         */
        public static let trailingIconTextSpacing: CGFloat = 4
        
        /**
         * Leading padding for primary row of size 16
         */
        public static let leadingPaddingPrimary: CGFloat = 16
        
        /**
         * Leading padding for secondary row of size 36
         */
        public static let leadingPaddingSecondary: CGFloat = 36
        
        /**
         * Trailing padding of size 12
         */
        public static let trailingPadding: CGFloat = 12
    }
}
