// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kinyarwanda (`rw`).
class AppLocalizationsRw extends AppLocalizations {
  AppLocalizationsRw([String locale = 'rw']) : super(locale);

  @override
  String get appTitle => 'Ubuzima Connect';

  @override
  String get save => 'Bika';

  @override
  String get cancel => 'Hagarika';

  @override
  String get retry => 'Ongera ugerageze';

  @override
  String get ok => 'Yego';

  @override
  String get yes => 'Yego';

  @override
  String get no => 'Oya';

  @override
  String get loading => 'Birimo gupakira...';

  @override
  String get noInternetConnection => 'Nta interineti ihari';

  @override
  String get somethingWentWrong => 'Habaye ikibazo';

  @override
  String get offlineBannerMessage =>
      'Nta interineti ufite. Impinduka zizahuzwa nyuma yo kongera guhuza na interineti.';

  @override
  String get login => 'Injira';

  @override
  String get home => 'Ahabanza';

  @override
  String get welcomeMessage => 'Murakaza neza kuri Ubuzima Connect';

  @override
  String get continueLabel => 'Komeza';

  @override
  String get roleSelectionTitle => 'Uzakoresha ute Ubuzima Connect?';

  @override
  String get roleSelectionSubtitle =>
      'Hitamo uruhare rukwerekeye. Ushobora kuruhindura nyuma muri Igenamiterere.';

  @override
  String get rolePatient => 'Umurwayi';

  @override
  String get rolePatientDescription =>
      'Reba amateka y\'ubuzima bwawe, gahunda zo kwivuza, n\'imiti wandikiwe.';

  @override
  String get roleCommunityHealthWorker => 'Umujyanama w\'ubuzima';

  @override
  String get roleCommunityHealthWorkerDescription =>
      'Sura ingo, andika isuzuma, kandi wohereze abarwayi ku bavuzi.';

  @override
  String get roleDoctor => 'Muganga';

  @override
  String get roleDoctorDescription =>
      'Suzuma aboherejwe, wandike imiti, kandi ucunge gahunda zo kwivuza.';
}
