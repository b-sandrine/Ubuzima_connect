import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/emergency_contact.dart';
import '../../domain/models/user_profile_summary.dart';

/// Seeded data behind [MockDoctorSettingsRepository]. Kept in its own file
/// so swapping in a Firestore-backed repository later is a data-source
/// change only — nothing in `presentation/` has to move.
abstract final class DummyDoctorSettingsData {
  static const UserProfileSummary profile = UserProfileSummary(
    fullName: 'Dr. Jean-Pierre Habimana',
    roleLabel: 'Doctor',
    facility: 'Kigali District Hospital',
    displayId: 'DOC-1042',
    accentColor: AppColors.roleDoctor,
  );

  static const List<EmergencyContact> emergencyContacts = [
    EmergencyContact(
      id: 'contact-dept-head',
      name: 'Dr. E. Nkurunziza',
      relationship: 'Department Head',
      phoneNumber: '+250 788 445 210',
      icon: LucideIcons.userRound,
      iconColor: AppColors.secondary,
    ),
    EmergencyContact(
      id: 'contact-security',
      name: 'Hospital Security',
      relationship: 'On-Site',
      phoneNumber: '+250 788 990 011',
      icon: LucideIcons.shield,
      iconColor: AppColors.warning,
    ),
  ];
}
