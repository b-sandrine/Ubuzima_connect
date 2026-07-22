// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Ubuzima Connect';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get retry => 'Retry';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get loading => 'Loading...';

  @override
  String get noInternetConnection => 'No internet connection';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get offlineBannerMessage =>
      'You\'re offline. Changes will sync when you\'re back online.';

  @override
  String get login => 'Login';

  @override
  String get home => 'Home';

  @override
  String get welcomeMessage => 'Welcome to Ubuzima Connect';

  @override
  String get continueLabel => 'Continue';

  @override
  String get roleSelectionTitle => 'How will you use Ubuzima Connect?';

  @override
  String get roleSelectionSubtitle =>
      'Choose the role that describes you. You can change this later in Settings.';

  @override
  String get rolePatient => 'Patient';

  @override
  String get rolePatientDescription =>
      'View your health records, appointments, and prescriptions.';

  @override
  String get roleCommunityHealthWorker => 'Community Health Worker';

  @override
  String get roleCommunityHealthWorkerDescription =>
      'Visit households, record assessments, and refer patients.';

  @override
  String get roleDoctor => 'Doctor';

  @override
  String get roleDoctorDescription =>
      'Review referrals, write prescriptions, and manage appointments.';
}
