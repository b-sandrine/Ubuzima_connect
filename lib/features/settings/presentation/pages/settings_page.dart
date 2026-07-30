import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/accessibility/accessibility_cubit.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/storage/local_storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../shared/widgets/backgrounds/app_gradient_background.dart';
import '../../../../shared/widgets/error/error_view.dart';
import '../../../../shared/widgets/loading/loading_indicator.dart';
import '../../../../shared/widgets/navigation/app_top_bar.dart';
import '../../../../shared/widgets/pills/status_pill.dart';
import '../../../doctors/presentation/widgets/doctor_bottom_navigation_bar.dart';
import '../../../patients/presentation/widgets/patient_bottom_navigation_bar.dart';
import '../../data/repositories/mock_doctor_settings_repository.dart';
import '../../data/repositories/mock_patient_settings_repository.dart';
import '../../domain/models/emergency_contact.dart';
import '../../domain/models/user_profile_summary.dart';
import '../../domain/repositories/settings_repository.dart';
import '../widgets/emergency_contact_card.dart';
import '../widgets/emergency_sos_card.dart';
import '../widgets/language_quick_switch_tile.dart';
import '../widgets/network_status_tile.dart';
import '../widgets/settings_group_card.dart';
import '../widgets/settings_profile_card.dart';
import '../widgets/settings_tile.dart';
import '../widgets/sign_out_tile.dart';
import '../widgets/text_size_stepper.dart';

/// Which role's settings a [SettingsPage] renders — drives the default
/// repository, seeded emergency contacts, and bottom nav / cross-navigation
/// wiring, while the page layout itself stays identical (only the Patient
/// screen was designed; the Doctor screen reuses the same layout with
/// doctor content, matching how Notifications handled the same gap).
enum SettingsAudience { doctor, patient }

/// The shared Settings screen for both the doctor and patient roles:
/// profile card, Appearance & Accessibility, Emergency Contacts, Account
/// Preferences, Connectivity, and App Support.
///
/// Data comes from a [SettingsRepository] — a mock per audience by default
/// — so swapping in a Firestore-backed implementation later only touches
/// the constructor call, not this screen.
class SettingsPage extends StatefulWidget {
  final SettingsAudience audience;
  final SettingsRepository? repository;

  const SettingsPage({super.key, required this.audience, this.repository});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsData {
  final UserProfileSummary profile;
  final List<EmergencyContact> contacts;

  const _SettingsData({required this.profile, required this.contacts});
}

class _SettingsPageState extends State<SettingsPage> {
  late Future<_SettingsData> _future;
  int _navIndex = 4;

  final LocalStorageService _storage = getIt<LocalStorageService>();
  late bool _pushNotifications;
  late bool _biometricLogin;
  late bool _dataSharing;
  late bool _offlineMode;
  late bool _autoSync;

  SettingsRepository get _repository =>
      widget.repository ??
      (widget.audience == SettingsAudience.doctor
          ? const MockDoctorSettingsRepository()
          : const MockPatientSettingsRepository());

  @override
  void initState() {
    super.initState();
    _future = _load();
    _pushNotifications =
        _storage.getBool(StorageKeys.pushNotificationsEnabled) ?? true;
    _biometricLogin =
        _storage.getBool(StorageKeys.biometricLoginEnabled) ?? true;
    _dataSharing = _storage.getBool(StorageKeys.dataSharingEnabled) ?? true;
    _offlineMode = _storage.getBool(StorageKeys.offlineModeEnabled) ?? false;
    _autoSync = _storage.getBool(StorageKeys.autoSyncEnabled) ?? true;
  }

  Future<_SettingsData> _load() async {
    final results = await Future.wait([
      _repository.getProfile(),
      _repository.getEmergencyContacts(),
    ]);

    return _SettingsData(
      profile: results[0] as UserProfileSummary,
      contacts: results[1] as List<EmergencyContact>,
    );
  }

  Future<void> _refresh() async {
    final next = _load();
    setState(() => _future = next);
    await next;
  }

  void _onNavTap(int index) {
    final isDoctor = widget.audience == SettingsAudience.doctor;
    switch (index) {
      case 0:
        context.go(isDoctor ? AppRoutes.doctorDashboard : AppRoutes.patientDashboard);
      case 1:
        context.go(isDoctor ? AppRoutes.patientSearch : AppRoutes.patientRecords);
      case 3:
        context.go(
          isDoctor ? AppRoutes.doctorNotifications : AppRoutes.patientNotifications,
        );
      case 4:
        break;
      default:
        setState(() => _navIndex = index);
    }
  }

  void _printAction(String action) => debugPrint('Tapped: $action');

  @override
  Widget build(BuildContext context) {
    final isDoctor = widget.audience == SettingsAudience.doctor;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          child: FutureBuilder<_SettingsData>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const LoadingIndicator(message: 'Loading settings…');
              }
              if (snapshot.hasError) {
                return ErrorView(
                  message: 'Could not load settings. Please try again.',
                  onRetry: _refresh,
                );
              }

              final data = snapshot.requireData;
              return RefreshIndicator(
                onRefresh: _refresh,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.sm,
                    AppSpacing.md,
                    AppSpacing.xl,
                  ),
                  children: [
                    const AppTopBar(
                      trailing: [CircleIconButton(icon: LucideIcons.bell)],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Preferences, accessibility & support',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SettingsProfileCard(
                      profile: data.profile,
                      onEditProfile: () => _printAction('Edit Profile'),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const _SectionTitle('Appearance & Accessibility'),
                    const SizedBox(height: AppSpacing.sm + 2),
                    _AppearanceSection(),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const _SectionTitle('Emergency Contacts'),
                        InkWell(
                          onTap: () => _printAction('Emergency Contacts · Add'),
                          borderRadius: BorderRadius.circular(AppRadius.full),
                          child: const StatusPill(
                            label: '+ Add',
                            color: AppColors.danger,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm + 2),
                    for (final contact in data.contacts) ...[
                      EmergencyContactCard(
                        contact: contact,
                        onCall: () => _printAction('Call · ${contact.name}'),
                        onMore: () => _printAction('More · ${contact.name}'),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                    EmergencySosCard(
                      facilityLabel: data.profile.facility,
                      emergencyNumber: '112',
                      onCall: () => _printAction('Emergency SOS · Call'),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const _SectionTitle('Account Preferences'),
                    const SizedBox(height: AppSpacing.sm + 2),
                    SettingsGroupCard(
                      children: [
                        SettingsTile(
                          icon: LucideIcons.bell,
                          iconColor: AppColors.warning,
                          title: 'Push Notifications',
                          subtitle: 'Medication & appointment alerts',
                          trailing: Switch(
                            value: _pushNotifications,
                            onChanged: (value) {
                              setState(() => _pushNotifications = value);
                              _storage.setBool(
                                StorageKeys.pushNotificationsEnabled,
                                value,
                              );
                            },
                          ),
                        ),
                        SettingsTile(
                          icon: LucideIcons.fingerprint,
                          iconColor: AppColors.success,
                          title: 'Biometric Login',
                          subtitle: 'Fingerprint / Face ID',
                          trailing: Switch(
                            value: _biometricLogin,
                            onChanged: (value) {
                              setState(() => _biometricLogin = value);
                              _storage.setBool(
                                StorageKeys.biometricLoginEnabled,
                                value,
                              );
                              // TODO: wire to `local_auth` once biometric
                              // sign-in is implemented; this only persists
                              // the user's preference for now.
                            },
                          ),
                        ),
                        SettingsTile(
                          icon: LucideIcons.share2,
                          iconColor: const Color(0xFF6366F1),
                          title: 'Data Sharing',
                          subtitle: 'Share health data with doctor',
                          trailing: Switch(
                            value: _dataSharing,
                            onChanged: (value) {
                              setState(() => _dataSharing = value);
                              _storage.setBool(
                                StorageKeys.dataSharingEnabled,
                                value,
                              );
                            },
                          ),
                        ),
                        SettingsTile(
                          icon: LucideIcons.shield,
                          iconColor: AppColors.secondary,
                          title: 'Privacy Policy',
                          subtitle: 'View data usage terms',
                          onTap: () => _printAction('Privacy Policy'),
                        ),
                        SettingsTile(
                          icon: LucideIcons.keyRound,
                          iconColor: AppColors.warning,
                          title: 'Change PIN',
                          subtitle: 'Update your security PIN',
                          onTap: () => _printAction('Change PIN'),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const _SectionTitle('Connectivity'),
                    const SizedBox(height: AppSpacing.sm + 2),
                    SettingsGroupCard(
                      children: [
                        const NetworkStatusTile(),
                        SettingsTile(
                          icon: LucideIcons.cloudOff,
                          iconColor: const Color(0xFF6366F1),
                          title: 'Offline Mode',
                          subtitle: 'Access records without internet',
                          trailing: Switch(
                            value: _offlineMode,
                            onChanged: (value) {
                              setState(() => _offlineMode = value);
                              _storage.setBool(
                                StorageKeys.offlineModeEnabled,
                                value,
                              );
                              // TODO: wire to `features/offline_sync` once
                              // that feature's local cache is implemented.
                            },
                          ),
                        ),
                        SettingsTile(
                          icon: LucideIcons.refreshCw,
                          iconColor: AppColors.success,
                          title: 'Auto Sync',
                          subtitle: 'Sync health data automatically',
                          trailing: Switch(
                            value: _autoSync,
                            onChanged: (value) {
                              setState(() => _autoSync = value);
                              _storage.setBool(
                                StorageKeys.autoSyncEnabled,
                                value,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm + 2),
                    const _InfoBanner(
                      message:
                          'Ubuzima works in low-connectivity areas — offline '
                          'mode lets you cache your records when data is '
                          'unavailable in rural zones.',
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const _SectionTitle('App Support'),
                    const SizedBox(height: AppSpacing.sm + 2),
                    SettingsGroupCard(
                      children: [
                        SettingsTile(
                          icon: LucideIcons.helpCircle,
                          iconColor: AppColors.success,
                          title: 'Help Center',
                          subtitle: 'FAQs and user guides',
                          onTap: () => _printAction('Help Center'),
                        ),
                        SettingsTile(
                          icon: LucideIcons.messageSquare,
                          iconColor: AppColors.secondary,
                          title: 'Send Feedback',
                          subtitle: 'Report issues or suggestions',
                          onTap: () => _printAction('Send Feedback'),
                        ),
                        SettingsTile(
                          icon: LucideIcons.info,
                          iconColor: AppColors.secondary,
                          title: 'About Ubuzima',
                          subtitle: 'Version 2.4.1 · Rwanda MoH',
                          onTap: () => _printAction('About Ubuzima'),
                        ),
                        SettingsTile(
                          icon: LucideIcons.star,
                          iconColor: AppColors.warning,
                          title: 'Rate the App',
                          subtitle: 'Share your experience',
                          onTap: () => _printAction('Rate the App'),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm + 2),
                    SignOutTile(
                      signedInAsLabel: 'Logged in as ${data.profile.fullName}',
                      // TODO: call the real sign-out flow once this screen
                      // is reached from an authenticated session — kept as
                      // a no-op here per the existing auth flow.
                      onTap: () => _printAction('Sign Out'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: isDoctor
          ? DoctorBottomNavigationBar(currentIndex: _navIndex, onTap: _onNavTap)
          : PatientBottomNavigationBar(currentIndex: _navIndex, onTap: _onNavTap),
    );
  }
}

class _AppearanceSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final accessibility = context.watch<AccessibilityCubit>().state;

    return SettingsGroupCard(
      children: [
        SettingsTile(
          icon: LucideIcons.moon,
          iconColor: const Color(0xFF6366F1),
          title: 'Dark Mode',
          subtitle: 'Switch to dark theme',
          trailing: Switch(
            value: themeMode == ThemeMode.dark,
            onChanged: (value) => context.read<ThemeCubit>().toggleDark(value),
          ),
        ),
        SettingsTile(
          icon: LucideIcons.type,
          iconColor: AppColors.secondary,
          title: 'Text Size',
          subtitle: 'Adjust for readability',
          trailing: const TextSizeStepper(),
        ),
        SettingsTile(
          icon: LucideIcons.contrast,
          iconColor: AppColors.warning,
          title: 'High Contrast',
          subtitle: 'Improve visual clarity',
          trailing: Switch(
            value: accessibility.highContrast,
            onChanged: (value) =>
                context.read<AccessibilityCubit>().setHighContrast(value),
          ),
        ),
        SettingsTile(
          icon: LucideIcons.accessibility,
          iconColor: AppColors.success,
          title: 'Screen Reader',
          subtitle: 'Voice-over support',
          trailing: Switch(
            value: accessibility.screenReaderHint,
            onChanged: (value) =>
                context.read<AccessibilityCubit>().setScreenReaderHint(value),
          ),
        ),
        const LanguageQuickSwitchTile(),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        color: AppColors.textTertiary,
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  final String message;

  const _InfoBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm + 4),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(LucideIcons.info, size: 15, color: AppColors.secondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 12,
                height: 1.4,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
