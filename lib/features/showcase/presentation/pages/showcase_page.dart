import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/backgrounds/app_gradient_background.dart';
import '../../../../shared/widgets/branding/ubuzima_wordmark.dart';
import '../../../../shared/widgets/pills/status_pill.dart';

/// A demo hub that makes every delivered screen openable in the running app.
/// This is a showcase entry point, not a product screen — the real app shell
/// (home, auth flow) will own navigation once those land. Each card pushes
/// the actual route so in-screen navigation (e.g. DOC-06's "+ New") keeps
/// working.
class ShowcasePage extends StatelessWidget {
  const ShowcasePage({super.key});

  static const List<_ShowcaseEntry> _entries = [
    _ShowcaseEntry(
      task: 'AUTH-01',
      title: 'Welcome',
      subtitle: 'Onboarding · language + continue',
      icon: Icons.waving_hand_outlined,
      color: AppColors.primary,
      route: AppRoutes.splash,
    ),
    _ShowcaseEntry(
      task: 'AUTH-05',
      title: 'Role Selection',
      subtitle: 'Onboarding · pick a role, sign in or create account',
      icon: Icons.badge_outlined,
      color: AppColors.primary,
      route: AppRoutes.roleSelection,
    ),
    _ShowcaseEntry(
      task: 'AUTH-02',
      title: 'Login',
      subtitle: 'Auth · role-aware phone/email sign-in',
      icon: Icons.login,
      color: AppColors.roleChw,
      route: AppRoutes.login,
    ),
    _ShowcaseEntry(
      task: 'AUTH-03',
      title: 'Register',
      subtitle: 'Auth · create account with selected role',
      icon: Icons.person_add_alt_1_outlined,
      color: AppColors.secondary,
      route: AppRoutes.register,
    ),
    _ShowcaseEntry(
      task: 'CHW-01',
      title: 'CHW Dashboard',
      subtitle: 'CHW · today summary, quick actions & patients',
      icon: Icons.dashboard_outlined,
      color: AppColors.roleChw,
      route: AppRoutes.chwDashboard,
    ),
    _ShowcaseEntry(
      task: 'PAT-03',
      title: 'Current Medications',
      subtitle: 'Patient · today’s doses, adherence & refills',
      icon: Icons.medication_outlined,
      color: AppColors.secondary,
      route: AppRoutes.patientMedications,
    ),
    _ShowcaseEntry(
      task: 'DOC-04',
      title: 'Patient Timeline',
      subtitle: 'Doctor · chronological history, trends & search',
      icon: Icons.timeline,
      color: Color(0xFF7C3AED),
      route: AppRoutes.patientTimeline,
    ),
    _ShowcaseEntry(
      task: 'PAT-02b',
      title: 'My Health Timeline',
      subtitle: 'Patient · same record, a warmer read of your own history',
      icon: Icons.favorite_border,
      color: AppColors.rolePatient,
      route: AppRoutes.patientMedicalTimeline,
    ),
    _ShowcaseEntry(
      task: 'SETTINGS-01',
      title: 'Language',
      subtitle: 'Shared · switch between English, Kinyarwanda & Français',
      icon: Icons.translate,
      color: AppColors.primary,
      route: AppRoutes.languageSettings,
    ),
    _ShowcaseEntry(
      task: 'DOCTOR',
      title: 'Doctor Dashboard',
      subtitle: 'Doctor · home overview, alerts, queue & referrals',
      icon: Icons.dashboard_outlined,
      color: AppColors.roleDoctor,
      route: AppRoutes.doctorDashboard,
    ),
    _ShowcaseEntry(
      task: 'DOCTOR',
      title: 'Patient Search',
      subtitle: 'Doctor · search, filters & recent patient records',
      icon: Icons.person_search_outlined,
      color: AppColors.roleDoctor,
      route: AppRoutes.patientSearch,
    ),
    _ShowcaseEntry(
      task: 'DOCTOR',
      title: 'Patient Details',
      subtitle: 'Doctor · risk scores, vitals, allergies & clinical notes',
      icon: Icons.medical_information_outlined,
      color: AppColors.roleDoctor,
      route: AppRoutes.patientDetail,
    ),
    _ShowcaseEntry(
      task: 'DOCTOR',
      title: 'Consultation · Vitals',
      subtitle: 'Doctor · active visit, editable vitals & quick actions',
      icon: Icons.monitor_heart_outlined,
      color: AppColors.roleDoctor,
      route: AppRoutes.consultation,
    ),
    _ShowcaseEntry(
      task: 'PATIENT',
      title: 'Patient Dashboard',
      subtitle: 'Patient · health score, vitals, meds & AI insight',
      icon: Icons.favorite_outline,
      color: AppColors.rolePatient,
      route: AppRoutes.patientDashboard,
    ),
    _ShowcaseEntry(
      task: 'PATIENT',
      title: 'AI Insights',
      subtitle: 'Patient · health score, risk signals & personalized guidance',
      icon: Icons.psychology_outlined,
      color: AppColors.rolePatient,
      route: AppRoutes.patientAiInsights,
    ),
    _ShowcaseEntry(
      task: 'PATIENT',
      title: 'Medical Records',
      subtitle: 'Patient · visit summaries, search & record tabs',
      icon: Icons.folder_shared_outlined,
      color: AppColors.rolePatient,
      route: AppRoutes.patientRecords,
    ),
    _ShowcaseEntry(
      task: 'DOCTOR',
      title: 'Doctor Alerts',
      subtitle: 'Doctor · priority, appointment, referral & AI notifications',
      icon: Icons.notifications_outlined,
      color: AppColors.roleDoctor,
      route: AppRoutes.doctorNotifications,
    ),
    _ShowcaseEntry(
      task: 'PATIENT',
      title: 'Patient Alerts',
      subtitle: 'Patient · medication, appointment & AI notifications',
      icon: Icons.notifications_outlined,
      color: AppColors.rolePatient,
      route: AppRoutes.patientNotifications,
    ),
    _ShowcaseEntry(
      task: 'DOCTOR',
      title: 'Doctor Settings',
      subtitle: 'Doctor · profile, appearance, emergency contacts & support',
      icon: Icons.settings_outlined,
      color: AppColors.roleDoctor,
      route: AppRoutes.doctorSettings,
    ),
    _ShowcaseEntry(
      task: 'PATIENT',
      title: 'Patient Settings',
      subtitle: 'Patient · profile, appearance, emergency contacts & support',
      icon: Icons.settings_outlined,
      color: AppColors.rolePatient,
      route: AppRoutes.patientSettings,
    ),
    _ShowcaseEntry(
      task: 'OFFLINE-01',
      title: 'Offline Indicator',
      subtitle: 'Shared · global banner reacting to real connectivity',
      icon: Icons.wifi_off,
      color: AppColors.warning,
      route: AppRoutes.offlineIndicatorInfo,
    ),
    _ShowcaseEntry(
      task: 'TUTORIAL-01',
      title: 'Onboarding Tutorial',
      subtitle: 'Shared · 3-slide intro shown before role selection',
      icon: Icons.slideshow,
      color: AppColors.roleDoctor,
      route: AppRoutes.onboarding,
    ),
    _ShowcaseEntry(
      task: 'DOC-06',
      title: 'Referral Management',
      subtitle: 'Doctor · queues, accept/decline & new referral',
      icon: Icons.swap_horiz,
      color: AppColors.roleDoctor,
      route: AppRoutes.referralManagement,
    ),
    _ShowcaseEntry(
      task: 'CHW-06b',
      title: 'Refer to Hospital',
      subtitle: 'CHW · escalate a patient from the field',
      icon: Icons.local_hospital_outlined,
      color: AppColors.warning,
      route: AppRoutes.chwReferral,
    ),
    _ShowcaseEntry(
      task: 'CHW',
      title: 'Health Record',
      subtitle: 'CHW · patient record, AI risk & next steps',
      icon: Icons.folder_shared_outlined,
      color: AppColors.roleChw,
      route: AppRoutes.chwHealthRecord,
    ),
    _ShowcaseEntry(
      task: 'CHW',
      title: 'New Patient Registration',
      subtitle: 'CHW · 3-step intake: identity, demographics, confirm',
      icon: Icons.person_add_alt_1_outlined,
      color: AppColors.roleChw,
      route: AppRoutes.newPatientIntake,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            children: [
              const Center(child: UbuzimaWordmark()),
              const SizedBox(height: 22),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Screen Showcase',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  StatusPill(
                    label: '${_entries.length} screens',
                    color: AppColors.primary,
                    icon: Icons.grid_view_rounded,
                    fontSize: 11.5,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Open any delivered screen. Each is fully interactive over '
                'seeded demo data.',
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.4,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              for (final entry in _entries) ...[
                _ShowcaseCard(entry: entry),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ShowcaseEntry {
  final String task;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String route;

  const _ShowcaseEntry({
    required this.task,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.route,
  });
}

class _ShowcaseCard extends StatelessWidget {
  final _ShowcaseEntry entry;

  const _ShowcaseCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () => context.push(entry.route),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A0F172A),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: entry.color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(entry.icon, color: entry.color, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            entry.title,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        StatusPill(
                          label: entry.task,
                          color: entry.color,
                          fontSize: 9.5,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      entry.subtitle,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: AppColors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}
