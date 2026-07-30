/// Path constants for every route in the app. Each feature will eventually
/// contribute its own block here (or, once route ownership moves fully into
/// features, in its own `<feature>_routes.dart`) — foundation-stage only
/// defines the shell routes needed to boot the app.
abstract final class AppRoutes {
  static const String splash = '/';
  static const String roleSelection = '/role-selection';
  static const String login = '/login';
  static const String register = '/register';
  static const String resetPassword = '/reset-password';
  static const String home = '/home';
  static const String chwDashboard = '/chw/dashboard';

  /// PAT-03 — the patient's current-medications screen.
  static const String patientMedications = '/medications';

  /// DOC-06 — the doctor's referral management board and creation form.
  static const String referralManagement = '/referrals';
  static const String newReferral = '/referrals/new';

  /// CHW-06b — the community health worker's referral-to-hospital form.
  static const String chwReferral = '/chw/referral';

  /// The community health worker's patient health record.
  static const String chwHealthRecord = '/chw/record';

  /// DOC-04 — the doctor's patient medical timeline.
  static const String patientTimeline = '/timeline';

  /// PAT-02b — the patient's own medical timeline.
  static const String patientMedicalTimeline = '/patient/timeline';

  /// The doctor's home dashboard.
  static const String doctorDashboard = '/doctor/dashboard';

  /// The doctor's patient search / records screen.
  static const String patientSearch = '/doctor/patients';

  /// SETTINGS-01 — the language switcher.
  static const String languageSettings = '/settings/language';
  /// The doctor's patient details screen.
  static const String patientDetail = '/doctor/patients/detail';

  /// The patient's home dashboard.
  static const String patientDashboard = '/patient/dashboard';

  /// The patient's medical records screen.
  static const String patientRecords = '/patient/records';

  /// The doctor's notifications / alerts feed.
  static const String doctorNotifications = '/doctor/notifications';

  /// The patient's notifications / alerts feed.
  static const String patientNotifications = '/patient/notifications';

  /// Demo hub listing every delivered screen (not a product screen).
  static const String showcase = '/showcase';

  /// Routes openable without a Firebase session.
  /// Clinical Firestore screens require auth; only the showcase hub and the
  /// CHW offline dashboard stay reachable for demos / offline continue.
  static const Set<String> demoReachable = {
    showcase,
    chwDashboard,
    chwReferral,
    chwHealthRecord,
    patientTimeline,
    patientMedicalTimeline,
    doctorDashboard,
    patientSearch,
    languageSettings,
    patientDetail,
    patientDashboard,
    patientRecords,
    patientMedications,
    doctorNotifications,
    patientNotifications,
  };
}
