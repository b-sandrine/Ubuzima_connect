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
  String get roleSelectionTitle => 'Santé communautaire';

  @override
  String get roleSelectionSubtitle =>
      'Des outils simples et fiables pour les agents de santé du Rwanda, au service de meilleurs soins.';

  @override
  String get rolePatient => 'Patient';

  @override
  String get rolePatientDescription => 'Dossiers de santé et rendez-vous';

  @override
  String get roleCommunityHealthWorker => 'Agent de santé communautaire';

  @override
  String get roleCommunityHealthWorkerDescription =>
      'Patients, orientations et visites';

  @override
  String get roleDoctor => 'Médecin / Clinicien';

  @override
  String get roleDoctorDescription => 'Diagnostiquer, prescrire, orienter';

  @override
  String get rwandaHealth => 'Santé Rwanda';

  @override
  String get selectYourRole => 'Choisissez votre rôle';

  @override
  String get signIn => 'Se connecter';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get securedAndTrusted => 'Sécurisé et fiable';

  @override
  String get trustHipaaAligned => 'Conforme HIPAA';

  @override
  String get trustOfflineReady => 'Hors ligne';

  @override
  String get trustMadeForRwanda => 'Conçu pour le Rwanda';

  @override
  String get roleBadgeChw => 'ASC';

  @override
  String get roleBadgePatient => 'Patient';

  @override
  String get roleBadgeDoctor => 'MD';
}
