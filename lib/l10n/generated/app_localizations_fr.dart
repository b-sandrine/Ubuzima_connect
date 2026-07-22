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

  @override
  String get continueLabel => 'Continuer';

  @override
  String get roleSelectionTitle =>
      'Comment allez-vous utiliser Ubuzima Connect ?';

  @override
  String get roleSelectionSubtitle =>
      'Choisissez le rôle qui vous correspond. Vous pourrez le modifier plus tard dans les Paramètres.';

  @override
  String get rolePatient => 'Patient';

  @override
  String get rolePatientDescription =>
      'Consultez votre dossier médical, vos rendez-vous et vos ordonnances.';

  @override
  String get roleCommunityHealthWorker => 'Agent de santé communautaire';

  @override
  String get roleCommunityHealthWorkerDescription =>
      'Visitez les ménages, enregistrez les évaluations et orientez les patients.';

  @override
  String get roleDoctor => 'Médecin';

  @override
  String get roleDoctorDescription =>
      'Examinez les orientations, rédigez des ordonnances et gérez les rendez-vous.';
}
