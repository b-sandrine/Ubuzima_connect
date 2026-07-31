import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/backgrounds/app_gradient_background.dart';
import '../../../../shared/widgets/error/error_view.dart';
import '../../../../shared/widgets/loading/loading_indicator.dart';
import '../../../../shared/widgets/navigation/app_top_bar.dart';
import '../../../doctors/presentation/widgets/doctor_bottom_navigation_bar.dart';
import '../../../patients/presentation/widgets/patient_bottom_navigation_bar.dart';
import '../../data/repositories/mock_doctor_notifications_repository.dart';
import '../../data/repositories/patient_notifications_repository_impl.dart';
import '../../domain/models/notification_section.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../widgets/notification_card.dart';
import '../widgets/notification_section_header.dart';

/// Which role's notification feed a [NotificationsPage] renders — drives
/// the default repository and which role's bottom nav / cross-navigation
/// wires up, while the page layout itself stays identical.
enum NotificationsAudience { doctor, patient }

/// The shared Notifications / Alerts screen for both the doctor and
/// patient roles: one app bar, one sectioned list, one card design —
/// [audience] only changes which seeded feed and bottom nav are used.
///
/// Data comes from a [NotificationsRepository] — a mock per audience by
/// default — so swapping in a Firestore-backed implementation later only
/// touches the constructor call, not this screen.
class NotificationsPage extends StatefulWidget {
  final NotificationsAudience audience;
  final NotificationsRepository? repository;

  const NotificationsPage({
    super.key,
    required this.audience,
    this.repository,
  });

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late Future<List<NotificationSection>> _future;
  int _navIndex = 3;

  NotificationsRepository get _repository =>
      widget.repository ??
      (widget.audience == NotificationsAudience.doctor
          ? const MockDoctorNotificationsRepository()
          : getIt<PatientNotificationsRepositoryImpl>());

  @override
  void initState() {
    super.initState();
    _future = _repository.getSections();
  }

  Future<void> _refresh() async {
    final next = _repository.getSections();
    setState(() => _future = next);
    await next;
  }

  void _onNavTap(int index) {
    final isDoctor = widget.audience == NotificationsAudience.doctor;
    switch (index) {
      case 0:
        context.go(isDoctor ? AppRoutes.doctorDashboard : AppRoutes.patientDashboard);
      case 1:
        context.go(isDoctor ? AppRoutes.patientSearch : AppRoutes.patientRecords);
      case 2:
        if (!isDoctor) context.go(AppRoutes.patientAiInsights);
      case 3:
        break;
      case 4:
        context.go(isDoctor ? AppRoutes.doctorSettings : AppRoutes.patientSettings);
      default:
        setState(() => _navIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDoctor = widget.audience == NotificationsAudience.doctor;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          child: FutureBuilder<List<NotificationSection>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const LoadingIndicator(message: 'Loading alerts…');
              }
              if (snapshot.hasError) {
                return ErrorView(
                  message: 'Could not load notifications. Please try again.',
                  onRetry: _refresh,
                );
              }

              final sections = snapshot.requireData;
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
                      contextLabel: 'ALERTS',
                      contextIcon: LucideIcons.bell,
                      trailing: const [
                        CircleIconButton(icon: LucideIcons.checkCheck),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    for (final section in sections) ...[
                      NotificationSectionHeader(section: section),
                      const SizedBox(height: AppSpacing.sm + 2),
                      for (final item in section.items) ...[
                        NotificationCard(
                          item: item,
                          onTap: () => _printAction('Open · ${item.title}'),
                          onAction: () =>
                              _printAction('${item.actionLabel} · ${item.title}'),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                      const SizedBox(height: AppSpacing.sm),
                    ],
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

  void _printAction(String action) => debugPrint('Tapped: $action');
}
