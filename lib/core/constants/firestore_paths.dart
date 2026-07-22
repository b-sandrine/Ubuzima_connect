/// Single source of truth for every Firestore collection/subcollection name.
///
/// Features must reference these constants instead of literal strings so a
/// typo can never silently fragment a collection in production.
abstract final class FirestorePaths {
  static const String users = 'users';
  static const String patients = 'patients';
  static const String communityHealthWorkers = 'community_health_workers';
  static const String doctors = 'doctors';
  static const String medicalRecords = 'medical_records';
  static const String riskAssessments = 'risk_assessments';
  static const String appointments = 'appointments';
  static const String prescriptions = 'prescriptions';
  static const String referrals = 'referrals';
  static const String notifications = 'notifications';
  static const String pharmacies = 'pharmacies';
  static const String syncQueue = 'sync_queue';
}
