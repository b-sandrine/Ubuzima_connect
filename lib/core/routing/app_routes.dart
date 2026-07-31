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

  /// CHW-02 — searchable list of registered community patients.
  static const String chwPatientList = '/chw/patients';

  /// The community health worker's patient health record.
  /// Use [chwHealthRecordFor] when opening a specific registered patient.
  static const String chwHealthRecord = '/chw/record';

  static String chwHealthRecordFor(String patientId) =>
      '$chwHealthRecord/$patientId';

  static bool isChwHealthRecord(String location) =>
      location == chwHealthRecord || location.startsWith('$chwHealthRecord/');

  /// CHW alerts / notifications feed.
  static const String chwNotifications = '/chw/alerts';

  /// CHW settings.
  static const String chwSettings = '/chw/settings';

  /// The three-step New Patient Registration flow (Identity & Household,
  /// Demographics & Contact, Confirm & Submit).
  static const String newPatientIntake = '/patients/new';

  /// DOC-04 — the doctor's patient medical timeline.
  static const String patientTimeline = '/timeline';

  /// PAT-02b — the patient's own medical timeline.
  static const String patientMedicalTimeline = '/patient/timeline';

  /// The doctor's home dashboard.
  static const String doctorDashboard = '/doctor/dashboard';

  /// The doctor's patient search / records screen.
  static const String patientSearch = '/doctor/patients';

  /// The doctor's active-visit Consultation screen (Vitals, Diagnosis,
  /// Notes, Treatment).
  static const String consultation = '/doctor/consultation';
  /// SETTINGS-01 — the language switcher.
  static const String languageSettings = '/settings/language';

  /// The doctor's patient details screen.
  static const String patientDetail = '/doctor/patients/detail';

  /// The patient's home dashboard.
  static const String patientDashboard = '/patient/dashboard';

  /// The patient's medical records screen.
  static const String patientRecords = '/patient/records';

  /// The patient's AI Insights screen.
  static const String patientAiInsights = '/patient/ai-insights';

  /// The doctor's notifications / alerts feed.
  static const String doctorNotifications = '/doctor/notifications';

  /// The patient's notifications / alerts feed.
  static const String patientNotifications = '/patient/notifications';

  /// The doctor's main settings screen.
  static const String doctorSettings = '/doctor/settings';

  /// The patient's main settings screen.
  static const String patientSettings = '/patient/settings';

  /// TUTORIAL-01 — the onboarding tutorial, shown once before role
  /// selection. See `route_guards.dart` for where that redirect is wired.
  static const String onboarding = '/onboarding';

  /// Routes openable without a Firebase session. Clinical Firestore screens
  /// require auth; only the CHW offline flow ("Continue Offline" on the CHW
  /// login) and onboarding itself stay reachable pre-auth.
  static const Set<String> demoReachable = {
    chwDashboard,
    chwReferral,
    chwPatientList,
    chwHealthRecord,
    chwNotifications,
    chwSettings,
    newPatientIntake,
    onboarding,
  };
}
