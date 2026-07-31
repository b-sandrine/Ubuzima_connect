import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/emergency_contact.dart';
import '../../domain/models/user_profile_summary.dart';

abstract final class DummyChwSettingsData {
  static const UserProfileSummary profile = UserProfileSummary(
    fullName: 'Community Health Worker',
    roleLabel: 'CHW',
    facility: 'Kigali Sector',
    displayId: 'CHW-2048',
    accentColor: AppColors.roleChw,
  );

  static const List<EmergencyContact> emergencyContacts = [
    EmergencyContact(
      id: 'contact-health-center',
      name: 'Sector Health Center',
      relationship: 'Facility',
      phoneNumber: '+250 788 100 200',
      icon: LucideIcons.hospital,
      iconColor: AppColors.primary,
    ),
    EmergencyContact(
      id: 'contact-supervisor',
      name: 'CHW Supervisor',
      relationship: 'Supervisor',
      phoneNumber: '+250 788 300 400',
      icon: LucideIcons.userRound,
      iconColor: AppColors.secondary,
    ),
  ];
}
