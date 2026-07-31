import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/accessibility/accessibility_cubit.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/security/secure_storage_service.dart';
import '../../../../core/storage/local_storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../shared/utils/coming_soon.dart';
import '../../../../shared/widgets/backgrounds/app_gradient_background.dart';
import '../../../../shared/widgets/error/error_view.dart';
import '../../../../shared/widgets/loading/loading_indicator.dart';
import '../../../../shared/widgets/navigation/app_top_bar.dart';
import '../../../../shared/widgets/pills/status_pill.dart';
import '../../../authentication/domain/usecases/sign_out.dart';
import '../../../community_health_workers/presentation/widgets/chw_bottom_nav.dart';
import '../../../doctors/presentation/widgets/doctor_bottom_navigation_bar.dart';
import '../../../patients/presentation/widgets/patient_bottom_navigation_bar.dart';
import '../../data/repositories/mock_chw_settings_repository.dart';
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

enum SettingsAudience { doctor, patient, chw }

/// Shared Settings screen for doctor, patient, and CHW audiences.
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

  _SettingsData copyWith({
    UserProfileSummary? profile,
    List<EmergencyContact>? contacts,
  }) {
    return _SettingsData(
      profile: profile ?? this.profile,
      contacts: contacts ?? this.contacts,
    );
  }
}

class _SettingsPageState extends State<SettingsPage> {
  late Future<_SettingsData> _future;
  _SettingsData? _data;
  int _navIndex = 4;

  final LocalStorageService _storage = getIt<LocalStorageService>();
  final SecureStorageService _secure = getIt<SecureStorageService>();

  late bool _pushNotifications;
  late bool _biometricLogin;
  late bool _dataSharing;
  late bool _offlineMode;
  late bool _autoSync;

  String get _audienceKey => widget.audience.name;

  SettingsRepository get _repository {
    if (widget.repository != null) return widget.repository!;
    return switch (widget.audience) {
      SettingsAudience.doctor => const MockDoctorSettingsRepository(),
      SettingsAudience.patient => const MockPatientSettingsRepository(),
      SettingsAudience.chw => const MockChwSettingsRepository(),
    };
  }

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

    var profile = results[0] as UserProfileSummary;
    var contacts = List<EmergencyContact>.from(
      results[1] as List<EmergencyContact>,
    );

    final savedName = _storage.getString(
      '${StorageKeys.settingsProfileName}.$_audienceKey',
    );
    final savedFacility = _storage.getString(
      '${StorageKeys.settingsProfileFacility}.$_audienceKey',
    );
    if ((savedName != null && savedName.trim().isNotEmpty) ||
        (savedFacility != null && savedFacility.trim().isNotEmpty)) {
      profile = UserProfileSummary(
        fullName: savedName?.trim().isNotEmpty == true
            ? savedName!.trim()
            : profile.fullName,
        roleLabel: profile.roleLabel,
        facility: savedFacility?.trim().isNotEmpty == true
            ? savedFacility!.trim()
            : profile.facility,
        displayId: profile.displayId,
        accentColor: profile.accentColor,
        photoUrl: profile.photoUrl,
        isActive: profile.isActive,
      );
    }

    final savedContacts = _storage.getString(
      '${StorageKeys.settingsEmergencyContacts}.$_audienceKey',
    );
    if (savedContacts != null && savedContacts.isNotEmpty) {
      try {
        final decoded = jsonDecode(savedContacts) as List<dynamic>;
        contacts = decoded
            .map((raw) => _contactFromJson(raw as Map<String, dynamic>))
            .toList();
      } catch (_) {
        // Keep seeded contacts if persisted JSON is corrupt.
      }
    }

    final data = _SettingsData(profile: profile, contacts: contacts);
    _data = data;
    return data;
  }

  Future<void> _refresh() async {
    final next = _load();
    setState(() => _future = next);
    await next;
  }

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _onNavTap(int index) {
    switch (widget.audience) {
      case SettingsAudience.chw:
        ChwBottomNav.handleTap(context, index);
      case SettingsAudience.doctor:
        switch (index) {
          case 0:
            context.go(AppRoutes.doctorDashboard);
          case 1:
            context.go(AppRoutes.patientSearch);
          case 2:
            showComingSoon(context, 'AI Insights');
          case 3:
            context.go(AppRoutes.doctorNotifications);
          case 4:
            break;
          default:
            setState(() => _navIndex = index);
        }
      case SettingsAudience.patient:
        switch (index) {
          case 0:
            context.go(AppRoutes.patientDashboard);
          case 1:
            context.go(AppRoutes.patientRecords);
          case 2:
            context.go(AppRoutes.patientAiInsights);
          case 3:
            context.go(AppRoutes.patientNotifications);
          case 4:
            break;
          default:
            setState(() => _navIndex = index);
        }
    }
  }

  Future<void> _signOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text(
          'You will need to sign in again to access clinical data.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final result = await getIt<SignOut>()();
    if (!mounted) return;
    result.fold(
      (failure) => _snack(failure.message),
      (_) => context.go(AppRoutes.splash),
    );
  }

  Future<void> _editProfile() async {
    final data = _data;
    if (data == null) return;
    final nameCtrl = TextEditingController(text: data.profile.fullName);
    final facilityCtrl = TextEditingController(text: data.profile.facility);

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Full name'),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: facilityCtrl,
              decoration: const InputDecoration(labelText: 'Facility / sector'),
              textCapitalization: TextCapitalization.words,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (saved != true || !mounted) return;
    final name = nameCtrl.text.trim();
    final facility = facilityCtrl.text.trim();
    if (name.isEmpty) {
      _snack('Name cannot be empty.');
      return;
    }

    await _storage.setString(
      '${StorageKeys.settingsProfileName}.$_audienceKey',
      name,
    );
    await _storage.setString(
      '${StorageKeys.settingsProfileFacility}.$_audienceKey',
      facility.isEmpty ? data.profile.facility : facility,
    );

    setState(() {
      _data = data.copyWith(
        profile: UserProfileSummary(
          fullName: name,
          roleLabel: data.profile.roleLabel,
          facility: facility.isEmpty ? data.profile.facility : facility,
          displayId: data.profile.displayId,
          accentColor: data.profile.accentColor,
          photoUrl: data.profile.photoUrl,
          isActive: data.profile.isActive,
        ),
      );
      _future = Future.value(_data);
    });
    _snack('Profile updated.');
  }

  Future<void> _addContact() async {
    final data = _data;
    if (data == null) return;
    final nameCtrl = TextEditingController();
    final relationCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add emergency contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: relationCtrl,
              decoration: const InputDecoration(labelText: 'Relationship'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(labelText: 'Phone number'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (saved != true || !mounted) return;
    final name = nameCtrl.text.trim();
    final phone = phoneCtrl.text.trim();
    if (name.isEmpty || phone.isEmpty) {
      _snack('Name and phone are required.');
      return;
    }

    final contact = EmergencyContact(
      id: 'contact-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      relationship: relationCtrl.text.trim().isEmpty
          ? 'Contact'
          : relationCtrl.text.trim(),
      phoneNumber: phone,
      icon: LucideIcons.userRound,
      iconColor: AppColors.roleChw,
    );

    final next = [...data.contacts, contact];
    await _persistContacts(next);
    setState(() {
      _data = data.copyWith(contacts: next);
      _future = Future.value(_data);
    });
    _snack('Contact added.');
  }

  Future<void> _persistContacts(List<EmergencyContact> contacts) async {
    final payload = jsonEncode([
      for (final c in contacts)
        {
          'id': c.id,
          'name': c.name,
          'relationship': c.relationship,
          'phoneNumber': c.phoneNumber,
        },
    ]);
    await _storage.setString(
      '${StorageKeys.settingsEmergencyContacts}.$_audienceKey',
      payload,
    );
  }

  EmergencyContact _contactFromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: json['id'] as String? ?? 'contact',
      name: json['name'] as String? ?? '',
      relationship: json['relationship'] as String? ?? 'Contact',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      icon: LucideIcons.userRound,
      iconColor: AppColors.danger,
    );
  }

  Future<void> _callNumber(String name, String number) async {
    await Clipboard.setData(ClipboardData(text: number));
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Call $name'),
        content: Text(
          'Phone number $number was copied to your clipboard. '
          'Paste it into your dialer to place the call.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _snack('Number copied: $number');
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Future<void> _contactMore(EmergencyContact contact) async {
    final data = _data;
    if (data == null) return;

    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(LucideIcons.phone),
              title: const Text('Call'),
              onTap: () => Navigator.pop(context, 'call'),
            ),
            ListTile(
              leading: const Icon(LucideIcons.copy),
              title: const Text('Copy number'),
              onTap: () => Navigator.pop(context, 'copy'),
            ),
            ListTile(
              leading: const Icon(LucideIcons.trash2, color: AppColors.danger),
              title: const Text(
                'Remove contact',
                style: TextStyle(color: AppColors.danger),
              ),
              onTap: () => Navigator.pop(context, 'remove'),
            ),
          ],
        ),
      ),
    );

    if (!mounted || action == null) return;
    switch (action) {
      case 'call':
        await _callNumber(contact.name, contact.phoneNumber);
      case 'copy':
        await Clipboard.setData(ClipboardData(text: contact.phoneNumber));
        _snack('Copied ${contact.phoneNumber}');
      case 'remove':
        final next = data.contacts.where((c) => c.id != contact.id).toList();
        await _persistContacts(next);
        setState(() {
          _data = data.copyWith(contacts: next);
          _future = Future.value(_data);
        });
        _snack('Removed ${contact.name}');
    }
  }

  Future<void> _showPrivacyPolicy() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'Ubuzima Connect processes health information to support '
            'community care, referrals, and clinical follow-up in Rwanda.\n\n'
            '• Patient data is used only for care coordination.\n'
            '• Access is role-based (CHW, doctor, patient).\n'
            '• You can turn off data sharing in Account Preferences.\n'
            '• Offline mode keeps a local cache on this device.\n\n'
            'For questions, contact your facility administrator or the '
            'Ministry of Health support desk.',
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  Future<void> _changePin() async {
    final currentCtrl = TextEditingController();
    final nextCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change PIN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentCtrl,
              decoration: const InputDecoration(labelText: 'Current PIN'),
              keyboardType: TextInputType.number,
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nextCtrl,
              decoration: const InputDecoration(labelText: 'New PIN (4+ digits)'),
              keyboardType: TextInputType.number,
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: confirmCtrl,
              decoration: const InputDecoration(labelText: 'Confirm new PIN'),
              keyboardType: TextInputType.number,
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Update'),
          ),
        ],
      ),
    );

    if (saved != true || !mounted) return;

    final existing = await _secure.read(StorageKeys.appPin);
    final current = currentCtrl.text.trim();
    final next = nextCtrl.text.trim();
    final confirm = confirmCtrl.text.trim();

    if (existing != null && existing.isNotEmpty && current != existing) {
      _snack('Current PIN is incorrect.');
      return;
    }
    if (next.length < 4 || !RegExp(r'^\d+$').hasMatch(next)) {
      _snack('PIN must be at least 4 digits.');
      return;
    }
    if (next != confirm) {
      _snack('New PIN confirmation does not match.');
      return;
    }

    await _secure.write(StorageKeys.appPin, next);
    _snack('PIN updated securely.');
  }

  Future<void> _showHelpCenter() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help Center'),
        content: const SingleChildScrollView(
          child: Text(
            'Quick guides\n\n'
            '1. Register a patient from the + Register tab.\n'
            '2. Open Patients to search your caseload.\n'
            '3. Use Alerts for high-risk and emergency flags.\n'
            '4. Start a visit or referral from a patient record.\n'
            '5. Enable Offline Mode before traveling to low-signal areas.\n\n'
            'Need more help? Send feedback from Settings → App Support.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.push(AppRoutes.languageSettings, extra: widget.audience);
            },
            child: const Text('Language'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _sendFeedback() async {
    final ctrl = TextEditingController();
    final sent = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send feedback'),
        content: TextField(
          controller: ctrl,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Describe an issue or suggestion…',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Send'),
          ),
        ],
      ),
    );

    if (sent != true || !mounted) return;
    final text = ctrl.text.trim();
    if (text.isEmpty) {
      _snack('Please enter feedback before sending.');
      return;
    }
    await _storage.setString(
      'prefs.feedback.${DateTime.now().millisecondsSinceEpoch}',
      text,
    );
    _snack('Thanks — feedback saved on this device.');
  }

  Future<void> _showAbout() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Ubuzima'),
        content: const Text(
          'Ubuzima Connect\n'
          'Version 2.4.1\n'
          'Rwanda Ministry of Health\n\n'
          'Community health records, referrals, and clinical coordination '
          'for CHWs, doctors, and patients.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _rateApp() async {
    var rating = 5;
    final submitted = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setLocal) {
            return AlertDialog(
              title: const Text('Rate Ubuzima'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('How is the app working for your community work?'),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 1; i <= 5; i++)
                        IconButton(
                          onPressed: () => setLocal(() => rating = i),
                          icon: Icon(
                            i <= rating ? Icons.star : Icons.star_border,
                            color: AppColors.warning,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );

    if (submitted == true && mounted) {
      await _storage.setString('prefs.app_rating', '$rating');
      _snack('Thanks for rating Ubuzima $rating/5.');
    }
  }

  void _openAlerts() {
    switch (widget.audience) {
      case SettingsAudience.chw:
        context.go(AppRoutes.chwNotifications);
      case SettingsAudience.doctor:
        context.go(AppRoutes.doctorNotifications);
      case SettingsAudience.patient:
        context.go(AppRoutes.patientNotifications);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          child: FutureBuilder<_SettingsData>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done &&
                  _data == null) {
                return const LoadingIndicator(message: 'Loading settings…');
              }
              if (snapshot.hasError && _data == null) {
                return ErrorView(
                  message: 'Could not load settings. Please try again.',
                  onRetry: _refresh,
                );
              }

              final data = _data ?? snapshot.requireData;
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
                    AppTopBar(
                      trailing: [
                        CircleIconButton(
                          icon: LucideIcons.bell,
                          onTap: _openAlerts,
                        ),
                      ],
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
                      onEditProfile: _editProfile,
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
                          onTap: _addContact,
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
                        onCall: () =>
                            _callNumber(contact.name, contact.phoneNumber),
                        onMore: () => _contactMore(contact),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                    EmergencySosCard(
                      facilityLabel: data.profile.facility,
                      emergencyNumber: '112',
                      onCall: () => _callNumber('Emergency SOS', '112'),
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
                              _snack(
                                value
                                    ? 'Push notifications enabled'
                                    : 'Push notifications disabled',
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
                              _snack(
                                value
                                    ? 'Biometric login preference saved'
                                    : 'Biometric login preference off',
                              );
                            },
                          ),
                        ),
                        SettingsTile(
                          icon: LucideIcons.share2,
                          iconColor: const Color(0xFF6366F1),
                          title: 'Data Sharing',
                          subtitle: 'Share health data with care team',
                          trailing: Switch(
                            value: _dataSharing,
                            onChanged: (value) {
                              setState(() => _dataSharing = value);
                              _storage.setBool(
                                StorageKeys.dataSharingEnabled,
                                value,
                              );
                              _snack(
                                value
                                    ? 'Data sharing enabled'
                                    : 'Data sharing disabled',
                              );
                            },
                          ),
                        ),
                        SettingsTile(
                          icon: LucideIcons.shield,
                          iconColor: AppColors.secondary,
                          title: 'Privacy Policy',
                          subtitle: 'View data usage terms',
                          onTap: _showPrivacyPolicy,
                        ),
                        SettingsTile(
                          icon: LucideIcons.keyRound,
                          iconColor: AppColors.warning,
                          title: 'Change PIN',
                          subtitle: 'Update your security PIN',
                          onTap: _changePin,
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
                              _snack(
                                value
                                    ? 'Offline mode enabled'
                                    : 'Offline mode disabled',
                              );
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
                              _snack(
                                value
                                    ? 'Auto sync enabled'
                                    : 'Auto sync disabled',
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
                          onTap: _showHelpCenter,
                        ),
                        SettingsTile(
                          icon: LucideIcons.messageSquare,
                          iconColor: AppColors.secondary,
                          title: 'Send Feedback',
                          subtitle: 'Report issues or suggestions',
                          onTap: _sendFeedback,
                        ),
                        SettingsTile(
                          icon: LucideIcons.info,
                          iconColor: AppColors.secondary,
                          title: 'About Ubuzima',
                          subtitle: 'Version 2.4.1 · Rwanda MoH',
                          onTap: _showAbout,
                        ),
                        SettingsTile(
                          icon: LucideIcons.star,
                          iconColor: AppColors.warning,
                          title: 'Rate the App',
                          subtitle: 'Share your experience',
                          onTap: _rateApp,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm + 2),
                    SignOutTile(
                      signedInAsLabel: 'Logged in as ${data.profile.fullName}',
                      onTap: _signOut,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: switch (widget.audience) {
        SettingsAudience.chw => const ChwBottomNav(currentIndex: 4),
        SettingsAudience.doctor => DoctorBottomNavigationBar(
          currentIndex: _navIndex,
          onTap: _onNavTap,
        ),
        SettingsAudience.patient => PatientBottomNavigationBar(
          currentIndex: _navIndex,
          onTap: _onNavTap,
        ),
      },
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
