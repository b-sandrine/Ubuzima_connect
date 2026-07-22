// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Ubuzima Connect';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get retry => 'Réessayer';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get loading => 'Chargement...';

  @override
  String get noInternetConnection => 'Aucune connexion Internet';

  @override
  String get somethingWentWrong => 'Une erreur est survenue';

  @override
  String get offlineBannerMessage =>
      'Vous êtes hors ligne. Les modifications seront synchronisées dès que vous serez de nouveau en ligne.';

  @override
  String get login => 'Connexion';

  @override
  String get home => 'Accueil';

  @override
  String get welcomeMessage => 'Bienvenue sur Ubuzima Connect';
}
