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
  String get roleSelectionTitle => 'Community Healthcare';

  @override
  String get roleSelectionSubtitle =>
      'Empowering health workers across Rwanda with smart, calm tools for better care.';

  @override
  String get rolePatient => 'Patient';

  @override
  String get rolePatientDescription => 'Health records & appointments';

  @override
  String get roleCommunityHealthWorker => 'Community Health Worker';

  @override
  String get roleCommunityHealthWorkerDescription =>
      'Patients, referrals & field visits';

  @override
  String get roleDoctor => 'Doctor / Clinician';

  @override
  String get roleDoctorDescription => 'Diagnose, prescribe & refer';

  @override
  String get rwandaHealth => 'Rwanda Health';

  @override
  String get selectYourRole => 'Select your role';

  @override
  String get signIn => 'Sign In';

  @override
  String get createAccount => 'Create Account';

  @override
  String get securedAndTrusted => 'Secured & Trusted';

  @override
  String get trustHipaaAligned => 'HIPAA Aligned';

  @override
  String get trustOfflineReady => 'Offline Ready';

  @override
  String get trustMadeForRwanda => 'Made for Rwanda';

  @override
  String get roleBadgeChw => 'CHW';

  @override
  String get roleBadgePatient => 'Patient';

  @override
  String get roleBadgeDoctor => 'MD';
}
