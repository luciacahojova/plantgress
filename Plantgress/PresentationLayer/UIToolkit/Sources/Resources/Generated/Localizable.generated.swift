// Template is based on the default strings/flat-swift5.stencil
// https://github.com/SwiftGen/SwiftGen/blob/stable/Sources/SwiftGenCLI/templates/strings/structured-swift5.stencil
// Revision: 7e13d641745b56775d9a7f983a5468d2d9952ada

// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum Strings {
  /// Log In
  public static let loginTitle = Strings.tr("Localizable", "login_title", fallback: "Log In")
  /// Email
  public static let onboardingEmailPlaceholder = Strings.tr("Localizable", "onboarding_email_placeholder", fallback: "Email")
  /// Log In
  public static let onboardingLoginButton = Strings.tr("Localizable", "onboarding_login_button", fallback: "Log In")
  /// Name
  public static let onboardingNamePlaceholder = Strings.tr("Localizable", "onboarding_name_placeholder", fallback: "Name")
  /// Password
  public static let onboardingPasswordPlaceholder = Strings.tr("Localizable", "onboarding_password_placeholder", fallback: "Password")
  /// Register
  public static let onboardingRegistrationButton = Strings.tr("Localizable", "onboarding_registration_button", fallback: "Register")
  /// Repeat password
  public static let onboardingRepeatPasswordPlaceholder = Strings.tr("Localizable", "onboarding_repeat_password_placeholder", fallback: "Repeat password")
  /// Surname
  public static let onboardingSurnamePlaceholder = Strings.tr("Localizable", "onboarding_surname_placeholder", fallback: "Surname")
  /// Register
  public static let registrationTitle = Strings.tr("Localizable", "registration_title", fallback: "Register")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Strings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    if let preview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"], preview == "1",
     let path = BundleToken.bundle.path(forResource: Locale.current.identifier, ofType: "lproj"), let bundle = Bundle(path: path) {
      let format = bundle.localizedString(forKey: key, value: nil, table: table)
      return String(format: format, locale: Locale.current, arguments: args)
    } else {
      let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
      return String(format: format, locale: Locale.current, arguments: args)
    }
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
