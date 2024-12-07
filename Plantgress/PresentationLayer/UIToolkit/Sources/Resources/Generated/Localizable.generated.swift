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
  /// Welcome
  public static let welcome = Strings.tr("Localizable", "welcome", fallback: "Welcome")
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
