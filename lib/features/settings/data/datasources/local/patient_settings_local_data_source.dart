import 'package:injectable/injectable.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/models/emergency_contact.dart';
import '../../../domain/models/user_profile_summary.dart';

/// Seed values for the patient Settings screen, written into Firestore on
/// first read. Icon/colour are cosmetic constants keyed by id rather than
/// stored data — [PatientSettingsRemoteDataSource] pairs them with the
/// live name/relationship/phone fields.
abstract interface class PatientSettingsLocalDataSource {
  UserProfileSummary readProfile();

  List<EmergencyContact> readEmergencyContacts();
}

@LazySingleton(as: PatientSettingsLocalDataSource)
class PatientSettingsLocalDataSourceImpl
    implements PatientSettingsLocalDataSource {
  @override
  UserProfileSummary readProfile() => const UserProfileSummary(
    fullName: 'Marie Uwase',
    roleLabel: 'Patient',
    facility: 'Gasabo CHC',
    displayId: 'RW-2024-0042',
    accentColor: AppColors.rolePatient,
  );

  @override
  List<EmergencyContact> readEmergencyContacts() => const [
    EmergencyContact(
      id: 'contact-spouse',
      name: 'Jean Uwimana',
      relationship: 'Spouse',
      phoneNumber: '+250 788 123 456',
      icon: LucideIcons.userRound,
      iconColor: AppColors.danger,
    ),
    EmergencyContact(
      id: 'contact-doctor',
      name: 'Dr. Mukamana',
      relationship: 'Primary Doctor',
      phoneNumber: '+250 722 987 654',
      icon: LucideIcons.userRound,
      iconColor: AppColors.secondary,
    ),
  ];
}
