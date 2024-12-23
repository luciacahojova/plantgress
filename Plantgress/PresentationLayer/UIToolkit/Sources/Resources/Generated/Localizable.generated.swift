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
  /// Account
  public static let accountTitle = Strings.tr("Localizable", "account_title", fallback: "Account")
  /// Camera
  public static let cameraAction = Strings.tr("Localizable", "camera_action", fallback: "Camera")
  /// To continue, grant access to your camera in Settings.
  public static let cameraPermissionAlertMessage = Strings.tr("Localizable", "camera_permission_alert_message", fallback: "To continue, grant access to your camera in Settings.")
  /// Cancel
  public static let cancelButton = Strings.tr("Localizable", "cancel_button", fallback: "Cancel")
  /// Change Email
  public static let changeEmailButton = Strings.tr("Localizable", "change_email_button", fallback: "Change Email")
  /// Change Name
  public static let changeNameButton = Strings.tr("Localizable", "change_name_button", fallback: "Change Name")
  /// Change Password
  public static let changePasswordButton = Strings.tr("Localizable", "change_password_button", fallback: "Change Password")
  /// Choose action
  public static let chooseActionTitle = Strings.tr("Localizable", "choose_action_title", fallback: "Choose action")
  /// Clean
  public static let cleanName = Strings.tr("Localizable", "clean_name", fallback: "Clean")
  /// Cleaning
  public static let cleaningTitle = Strings.tr("Localizable", "cleaning_title", fallback: "Cleaning")
  /// Close
  public static let closeButton = Strings.tr("Localizable", "close_button", fallback: "Close")
  /// Completed Tasks
  public static let completedTasksTitle = Strings.tr("Localizable", "completed_tasks_title", fallback: "Completed Tasks")
  /// Failed to load.
  public static let dataLoadFailedSnackbarMessage = Strings.tr("Localizable", "data_load_failed_snackbar_message", fallback: "Failed to load.")
  /// Something went wrong.
  public static let defaultErrorMessage = Strings.tr("Localizable", "default_error_message", fallback: "Something went wrong.")
  /// Are you sure you want to permanently delete your account?
  public static let deleteAccountAlertMessage = Strings.tr("Localizable", "delete_account_alert_message", fallback: "Are you sure you want to permanently delete your account?")
  /// Delete Account
  public static let deleteAccountAlertTitle = Strings.tr("Localizable", "delete_account_alert_title", fallback: "Delete Account")
  /// Delete Account
  public static let deleteAccountButton = Strings.tr("Localizable", "delete_account_button", fallback: "Delete Account")
  /// Delete
  public static let deleteButton = Strings.tr("Localizable", "delete_button", fallback: "Delete")
  /// Dismiss
  public static let dismissButton = Strings.tr("Localizable", "dismiss_button", fallback: "Dismiss")
  /// Upraviť
  public static let editButton = Strings.tr("Localizable", "edit_button", fallback: "Upraviť")
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
  /// Extra Tools 🔨
  public static let exploreTitleWithEmoji = Strings.tr("Localizable", "explore_title_with_emoji", fallback: "Extra Tools 🔨")
  /// Fertilize
  public static let fertilizeName = Strings.tr("Localizable", "fertilize_name", fallback: "Fertilize")
  /// Fertilizing
  public static let fertilizingTitle = Strings.tr("Localizable", "fertilizing_title", fallback: "Fertilizing")
  /// Forgotten password
  public static let forgottenPasswordTitle = Strings.tr("Localizable", "forgotten_password_title", fallback: "Forgotten password")
  /// Failed to upload image.
  public static let imageUploadFailedSnackbarMessage = Strings.tr("Localizable", "image_upload_failed_snackbar_message", fallback: "Failed to upload image.")
  /// Inspect
  public static let inspectName = Strings.tr("Localizable", "inspect_name", fallback: "Inspect")
  /// Please enter a valid email address.
  public static let invalidEmailFormatErrorMessage = Strings.tr("Localizable", "invalid_email_format_error_message", fallback: "Please enter a valid email address.")
  /// Password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, and one number.
  public static let invalidPasswordFormatErrorMessage = Strings.tr("Localizable", "invalid_password_format_error_message", fallback: "Password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, and one number.")
  /// Library
  public static let libraryAction = Strings.tr("Localizable", "library_action", fallback: "Library")
  /// To continue, you must log in again.
  public static let loginContinuteMessage = Strings.tr("Localizable", "login_continute_message", fallback: "To continue, you must log in again.")
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
  /// No Camera Access
  public static let noCameraAccessAlertTitle = Strings.tr("Localizable", "no_camera_access_alert_title", fallback: "No Camera Access")
  /// No Photos Access
  public static let noPhotosAccessAlertTitle = Strings.tr("Localizable", "no_photos_access_alert_title", fallback: "No Photos Access")
  /// You have no rooms.
  public static let noRoomsMessage = Strings.tr("Localizable", "no_rooms_message", fallback: "You have no rooms.")
  /// You have no tracked tasks.
  public static let noTrackedTasksMessage = Strings.tr("Localizable", "no_tracked_tasks_message", fallback: "You have no tracked tasks.")
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
  /// Pest Inspection
  public static let pestInspectionTitle = Strings.tr("Localizable", "pest_inspection_title", fallback: "Pest Inspection")
  /// To continue, grant access to Photos in Settings.
  public static let photosPermissionAlertMessage = Strings.tr("Localizable", "photos_permission_alert_message", fallback: "To continue, grant access to Photos in Settings.")
  /// You have no plants.
  public static let plantCollectionEmptyMessage = Strings.tr("Localizable", "plant_collection_empty_message", fallback: "You have no plants.")
  /// Plants
  public static let plantsTitle = Strings.tr("Localizable", "plants_title", fallback: "Plants")
  /// Plants 🪴
  public static let plantsTitleWithEmoji = Strings.tr("Localizable", "plants_title_with_emoji", fallback: "Plants 🪴")
  /// Profile
  public static let profileTitle = Strings.tr("Localizable", "profile_title", fallback: "Profile")
  /// Progress saved!
  public static let progressSavedSnackbarMessage = Strings.tr("Localizable", "progress_saved_snackbar_message", fallback: "Progress saved!")
  /// Progress Tracking
  public static let progressTrackingTitle = Strings.tr("Localizable", "progress_tracking_title", fallback: "Progress Tracking")
  /// Propagate
  public static let propagateName = Strings.tr("Localizable", "propagate_name", fallback: "Propagate")
  /// Propagating
  public static let propagatingTitle = Strings.tr("Localizable", "propagating_title", fallback: "Propagating")
  /// Register
  public static let registrationTitle = Strings.tr("Localizable", "registration_title", fallback: "Register")
  /// Repot
  public static let repotName = Strings.tr("Localizable", "repot_name", fallback: "Repot")
  /// Repotting
  public static let repottingTitle = Strings.tr("Localizable", "repotting_title", fallback: "Repotting")
  /// Resend verification link
  public static let resendVerificationLinkButton = Strings.tr("Localizable", "resend_verification_link_button", fallback: "Resend verification link")
  /// Send password reset
  public static let resetPasswordButtom = Strings.tr("Localizable", "reset_password_buttom", fallback: "Send password reset")
  /// Password reset link has been sent.
  public static let resetPasswordSnackbarMessage = Strings.tr("Localizable", "reset_password_snackbar_message", fallback: "Password reset link has been sent.")
  /// Rooms
  public static let roomsTitle = Strings.tr("Localizable", "rooms_title", fallback: "Rooms")
  /// Rooms 🏡
  public static let roomsTitleWithEmoji = Strings.tr("Localizable", "rooms_title_with_emoji", fallback: "Rooms 🏡")
  /// Settings
  public static let settingsButton = Strings.tr("Localizable", "settings_button", fallback: "Settings")
  /// Failed to complete task
  public static let taskCompleteFailedSnackbarMessage = Strings.tr("Localizable", "task_complete_failed_snackbar_message", fallback: "Failed to complete task")
  /// Completed on %@
  public static func taskCompletedOnTitle(_ p1: Any) -> String {
    return Strings.tr("Localizable", "task_completed_on_title", String(describing: p1), fallback: "Completed on %@")
  }
  /// %@ completed
  public static func taskCompletedSnackbarMessage(_ p1: Any) -> String {
    return Strings.tr("Localizable", "task_completed_snackbar_message", String(describing: p1), fallback: "%@ completed")
  }
  /// Failed to delete task.
  public static let taskDeleteFailedSnackbarMessage = Strings.tr("Localizable", "task_delete_failed_snackbar_message", fallback: "Failed to delete task.")
  /// Due in %@ days
  public static func taskDueDaysFewTitle(_ p1: Any) -> String {
    return Strings.tr("Localizable", "task_due_days_few_title", String(describing: p1), fallback: "Due in %@ days")
  }
  /// Due in %@ days
  public static func taskDueDaysManyTitle(_ p1: Any) -> String {
    return Strings.tr("Localizable", "task_due_days_many_title", String(describing: p1), fallback: "Due in %@ days")
  }
  /// Due in 1 day
  public static let taskDueDaysOneTitle = Strings.tr("Localizable", "task_due_days_one_title", fallback: "Due in 1 day")
  /// Today
  public static let taskDueTodayTitle = Strings.tr("Localizable", "task_due_today_title", fallback: "Today")
  /// Overdue by %@ days
  public static func taskOverdueDaysManyTitle(_ p1: Any) -> String {
    return Strings.tr("Localizable", "task_overdue_days_many_title", String(describing: p1), fallback: "Overdue by %@ days")
  }
  /// Overdue by 1 day
  public static let taskOverdueDaysOneTitle = Strings.tr("Localizable", "task_overdue_days_one_title", fallback: "Overdue by 1 day")
  /// Start
  public static let taskStart = Strings.tr("Localizable", "task_start", fallback: "Start")
  /// Time
  public static let taskTime = Strings.tr("Localizable", "task_time", fallback: "Time")
  /// Tasks
  public static let tasksTitle = Strings.tr("Localizable", "tasks_title", fallback: "Tasks")
  /// Tasks 📝
  public static let tasksTitleWithEmoji = Strings.tr("Localizable", "tasks_title_with_emoji", fallback: "Tasks 📝")
  /// Too many requests.
  public static let tooManyRequestsErrorMessage = Strings.tr("Localizable", "too_many_requests_error_message", fallback: "Too many requests.")
  /// Track
  public static let trackButton = Strings.tr("Localizable", "track_button", fallback: "Track")
  /// Track Progress
  public static let trackProgressName = Strings.tr("Localizable", "track_progress_name", fallback: "Track Progress")
  /// Späť
  public static let undoButton = Strings.tr("Localizable", "undo_button", fallback: "Späť")
  /// Upcoming Tasks
  public static let upcomingTasksTitle = Strings.tr("Localizable", "upcoming_tasks_title", fallback: "Upcoming Tasks")
  /// A verification link has been sent to your email address. It may take a few minutes to arrive. Once verified, you can log into the app. If you didn’t receive the email, you can request to resend the link.
  public static let verificationLinkSentMessage = Strings.tr("Localizable", "verification_link_sent_message", fallback: "A verification link has been sent to your email address. It may take a few minutes to arrive. Once verified, you can log into the app. If you didn’t receive the email, you can request to resend the link.")
  /// Verification link sent
  public static let verificationLinkTitle = Strings.tr("Localizable", "verification_link_title", fallback: "Verification link sent")
  /// Water
  public static let waterName = Strings.tr("Localizable", "water_name", fallback: "Water")
  /// Watering
  public static let wateringTitle = Strings.tr("Localizable", "watering_title", fallback: "Watering")
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
