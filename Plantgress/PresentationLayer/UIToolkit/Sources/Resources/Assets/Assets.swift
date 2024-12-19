//
//  Assets.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 06.12.2024.
//

import SwiftUI
import Foundation
import SwiftUICore

public enum Icons {
    public static let chevronLeft = Asset.Icons.chevronLeft.image
    public static let chevronRight = Asset.Icons.chevronRight.image
    public static let chevronSelectorVertical = Asset.Icons.chevronSelectorVertical.image
    public static let fileCheck = Asset.Icons.fileCheck.image
    public static let plus = Asset.Icons.plus.image
    public static let xMark = Asset.Icons.xMark.image
    public static let dotsHorizontal = Asset.Icons.dotsHorizontal.image
    public static let gear = Asset.Icons.gear.image
    public static let send = Asset.Icons.send.image
    public static let alarmClock = Asset.Icons.alarmClock.image
    public static let clock = Asset.Icons.clock.image
    public static let bag = Asset.Icons.bag.image
    public static let calendar = Asset.Icons.calendar.image
    public static let cameraPlus = Asset.Icons.cameraPlus.image
    public static let stars = Asset.Icons.stars.image
    public static let drop = Asset.Icons.drop.image
    public static let search = Asset.Icons.search.image
    public static let scissors = Asset.Icons.scissors.image
    public static let heartHand = Asset.Icons.heartHand.image
    public static let tag = Asset.Icons.tag.image
    public static let recycle = Asset.Icons.recycle.image
    public static let lightbulb = Asset.Icons.lightbulb.image
    public static let globe = Asset.Icons.globe.image
    public static let doctorBag = Asset.Icons.doctorBag.image
    public static let leaf = Asset.Icons.leaf.image
    public static let user = Asset.Icons.user.image
    public static let trash = Asset.Icons.trash.image
    public static let placeholder = Asset.Icons.placeholder.image
    public static let edit = Asset.Icons.edit.image
    public static let check = Asset.Icons.check.image
    public static let refresh = Asset.Icons.refresh.image
    public static let faceSmile = Asset.Icons.faceSmile.image
}

public enum Colors {
    public static let green = Asset.Colors.green.color
    public static let gray = Asset.Colors.gray.color
    public static let white = Asset.Colors.white.color
    public static let yellow = Asset.Colors.yellow.color
    public static let orange = Asset.Colors.orange.color
    public static let blue = Asset.Colors.blue.color
    public static let pink = Asset.Colors.pink.color
    public static let purple = Asset.Colors.purple.color
    public static let red = Asset.Colors.red.color
    public static let coral = Asset.Colors.coral.color
    public static let primaryText = Asset.Colors.primaryText.color
    public static let secondaryText = Asset.Colors.secondaryText.color
    public static let tertiaryText = Asset.Colors.tertiaryText.color
    public static let primaryBackground = Asset.Colors.primaryBackground.color
    public static let secondaryBackground = Asset.Colors.secondaryBackground.color
    public static let primaryButton = Asset.Colors.primaryButton.color
    public static let secondaryButton = Asset.Colors.secondaryButton.color
}

public enum Images {
    public static let logo = Asset.Images.logo.image
    public static let logoWithText = Asset.Images.logoWithText.image
    public static let primaryOnboardingBackground = Asset.Images.primaryOnboardingBackground.image
    public static let secondaryOnboardingBackground = Asset.Images.secondaryOnboardingBackground.image
}

public enum Fonts {
    public static let largeTitleBold: Font = .custom(relativeTo: .largeTitle, size: 34, weight: .bold)
    
    public static let titleRegular: Font = .custom(relativeTo: .title2, size: 22, weight: .regular)
    public static let titleSemibold: Font = .custom(relativeTo: .title2, size: 22, weight: .semibold)
    public static let titleBold: Font = .custom(relativeTo: .title2, size: 22, weight: .bold)
    
    public static let bodyRegular: Font = .custom(relativeTo: .body, size: 17, weight: .regular)
    public static let bodyMedium: Font = .custom(relativeTo: .body, size: 17, weight: .medium)
    public static let bodySemibold: Font = .custom(relativeTo: .body, size: 17, weight: .semibold)
    public static let bodyBold: Font = .custom(relativeTo: .body, size: 17, weight: .bold)

    public static let subheadlineMedium: Font = .custom(relativeTo: .subheadline, size: 15, weight: .medium)
    public static let subheadlineSemibold: Font = .custom(relativeTo: .subheadline, size: 15, weight: .semibold)
    public static let subheadlineBold: Font = .custom(relativeTo: .subheadline, size: 15, weight: .bold)

    public static let calloutRegular: Font = .custom(relativeTo: .footnote, size: 13, weight: .regular)
    public static let calloutMedium: Font = .custom(relativeTo: .footnote, size: 13, weight: .medium)
    public static let calloutSemibold: Font = .custom(relativeTo: .footnote, size: 13, weight: .semibold)

    public static let captionMedium: Font = .custom(relativeTo: .caption2, size: 11, weight: .medium)
    
    public static let footnoteRegular: Font = .custom(relativeTo: .footnote, size: 8, weight: .regular)
    public static let footnotetMedium: Font = .custom(relativeTo: .footnote, size: 8, weight: .medium)
    public static let footnoteSemibold: Font = .custom(relativeTo: .footnote, size: 8, weight: .semibold)
    public static let footnoteBold: Font = .custom(relativeTo: .footnote, size: 8, weight: .bold)
}
