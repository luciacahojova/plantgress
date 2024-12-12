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
  /// Cancel
  public static let cancelButton = Strings.tr("Localizable", "cancel_button", fallback: "Cancel")
  /// Close
  public static let closeButton = Strings.tr("Localizable", "close_button", fallback: "Close")
  /// Something went wrong.
  public static let defaultErrorMessage = Strings.tr("Localizable", "default_error_message", fallback: "Something went wrong.")
  /// Dismiss
  public static let dismissButton = Strings.tr("Localizable", "dismiss_button", fallback: "Dismiss")
  /// Email is already in use.
  public static let emailAlreadyInUseErrorMessage = Strings.tr("Localizable", "email_already_in_use_error_message", fallback: "Email is already in use.")
  /// Your email address is already verified.
  public static let emailAlreadyVerifiedMessage = Strings.tr("Localizable", "email_already_verified_message", fallback: "Your email address is already verified.")
  /// Email is not registered.
  public static let emailNotRegisteredErrorMessage = Strings.tr("Localizable", "email_not_registered_error_message", fallback: "Email is not registered.")
  /// Your email address is not verified.
  public static let emailNotVerifiedErrorMessage = Strings.tr("Localizable", "email_not_verified_error_message", fallback: "Your email address is not verified.")
  /// Email verification link has been resent.
  public static let emailVerificationResentSnackbarMessage = Strings.tr("Localizable", "email_verification_resent_snackbar_message", fallback: "Email verification link has been resent.")
  /// Explore
  public static let exploreTitle = Strings.tr("Localizable", "explore_title", fallback: "Explore")
  /// Forgotten password
  public static let forgottenPasswordTitle = Strings.tr("Localizable", "forgotten_password_title", fallback: "Forgotten password")
  /// Please enter a valid email address.
  public static let invalidEmailFormatErrorMessage = Strings.tr("Localizable", "invalid_email_format_error_message", fallback: "Please enter a valid email address.")
  /// Password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, and one number.
  public static let invalidPasswordFormatErrorMessage = Strings.tr("Localizable", "invalid_password_format_error_message", fallback: "Password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, and one number.")
  /// Send verification link
  public static let loginSendVerificationLinkButton = Strings.tr("Localizable", "login_send_verification_link_button", fallback: "Send verification link")
  /// Log In
  public static let loginTitle = Strings.tr("Localizable", "login_title", fallback: "Log In")
  /// Are you sure you want to log out?
  public static let logoutAlertMessage = Strings.tr("Localizable", "logout_alert_message", fallback: "Are you sure you want to log out?")
  /// Logout
  public static let logoutAlertTitle = Strings.tr("Localizable", "logout_alert_title", fallback: "Logout")
  /// Log Out
  public static let logoutButton = Strings.tr("Localizable", "logout_button", fallback: "Log Out")
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
  /// A reset link will be sent to the provided email address. If it doesn’t arrive within a few minutes, check the email address or resend the link.
  public static let passwordResetMessage = Strings.tr("Localizable", "password_reset_message", fallback: "A reset link will be sent to the provided email address. If it doesn’t arrive within a few minutes, check the email address or resend the link.")
  /// Passwords do not match.
  public static let passwordsDontMatchErrorMessage = Strings.tr("Localizable", "passwords_dont_match_error_message", fallback: "Passwords do not match.")
  /// Profile
  public static let profileTitle = Strings.tr("Localizable", "profile_title", fallback: "Profile")
  /// Register
  public static let registrationTitle = Strings.tr("Localizable", "registration_title", fallback: "Register")
  /// Resend verification link
  public static let resendVerificationLinkButton = Strings.tr("Localizable", "resend_verification_link_button", fallback: "Resend verification link")
  /// Send password reset
  public static let resetPasswordButtom = Strings.tr("Localizable", "reset_password_buttom", fallback: "Send password reset")
  /// Password reset link has been sent.
  public static let resetPasswordSnackbarMessage = Strings.tr("Localizable", "reset_password_snackbar_message", fallback: "Password reset link has been sent.")
  /// Too many requests.
  public static let tooManyRequestsErrorMessage = Strings.tr("Localizable", "too_many_requests_error_message", fallback: "Too many requests.")
  /// A verification link has been sent to your email address. It may take a few minutes to arrive. Once verified, you can log into the app. If you didn’t receive the email, you can request to resend the link.
  public static let verificationLinkSentMessage = Strings.tr("Localizable", "verification_link_sent_message", fallback: "A verification link has been sent to your email address. It may take a few minutes to arrive. Once verified, you can log into the app. If you didn’t receive the email, you can request to resend the link.")
  /// Verification link sent
  public static let verificationLinkTitle = Strings.tr("Localizable", "verification_link_title", fallback: "Verification link sent")
  /// Wrong password.
  public static let wrongPasswordErrorMessage = Strings.tr("Localizable", "wrong_password_error_message", fallback: "Wrong password.")
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
