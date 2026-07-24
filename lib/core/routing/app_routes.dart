/// Path constants for every route in the app. Each feature will eventually
/// contribute its own block here (or, once route ownership moves fully into
/// features, in its own `<feature>_routes.dart`) — foundation-stage only
/// defines the shell routes needed to boot the app.
abstract final class AppRoutes {
  static const String splash = '/';
  static const String roleSelection = '/role-selection';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  /// PAT-03 — the patient's current-medications screen.
  static const String patientMedications = '/medications';

  /// DOC-06 — the doctor's referral management board and creation form.
  static const String referralManagement = '/referrals';
  static const String newReferral = '/referrals/new';

  /// CHW-06b — the community health worker's referral-to-hospital form.
  static const String chwReferral = '/chw/referral';

  /// DOC-04 — the doctor's patient medical timeline.
  static const String patientTimeline = '/timeline';

  /// Demo hub listing every delivered screen (not a product screen).
  static const String showcase = '/showcase';

  /// Routes openable from the demo hub without a real session. These are the
  /// standalone feature screens delivered ahead of the auth/session flow, so
  /// the guard lets them through for demoing.
  static const Set<String> demoReachable = {
    showcase,
    patientMedications,
    referralManagement,
    newReferral,
    chwReferral,
    patientTimeline,
  };
}
