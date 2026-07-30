import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/emergency_contact.dart';
import '../../domain/models/user_profile_summary.dart';

/// Seeded data behind [MockPatientSettingsRepository]. Kept in its own file
/// so swapping in a Firestore-backed repository later is a data-source
/// change only — nothing in `presentation/` has to move.
abstract final class DummyPatientSettingsData {
  static const UserProfileSummary profile = UserProfileSummary(
    fullName: 'Marie Uwase',
    roleLabel: 'Patient',
    facility: 'Gasabo CHC',
    displayId: 'RW-2024-0042',
    accentColor: AppColors.rolePatient,
  );

  static const List<EmergencyContact> emergencyContacts = [
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
