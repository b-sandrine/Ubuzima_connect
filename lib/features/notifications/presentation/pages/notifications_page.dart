import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/utils/coming_soon.dart';
import '../../../../shared/widgets/backgrounds/app_gradient_background.dart';
import '../../../../shared/widgets/error/error_view.dart';
import '../../../../shared/widgets/loading/loading_indicator.dart';
import '../../../../shared/widgets/navigation/app_top_bar.dart';
import '../../../community_health_workers/data/repositories/chw_caseload_repository.dart';
import '../../../community_health_workers/presentation/widgets/chw_bottom_nav.dart';
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
enum NotificationsAudience { doctor, patient, chw }

/// The shared Notifications / Alerts screen for doctor, patient, and CHW
/// roles: one app bar, one sectioned list, one card design.
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

  NotificationsRepository get _repository {
    if (widget.repository != null) return widget.repository!;
    return switch (widget.audience) {
      NotificationsAudience.doctor => const MockDoctorNotificationsRepository(),
      NotificationsAudience.patient => getIt<PatientNotificationsRepositoryImpl>(),
      NotificationsAudience.chw => getIt<ChwCaseloadRepository>(),
    };
  }

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
    switch (widget.audience) {
      case NotificationsAudience.chw:
        ChwBottomNav.handleTap(context, index);
      case NotificationsAudience.doctor:
        switch (index) {
          case 0:
            context.go(AppRoutes.doctorDashboard);
          case 1:
            context.go(AppRoutes.patientSearch);
          case 2:
            showComingSoon(context, 'AI Insights');
          case 3:
            break;
          case 4:
            context.go(AppRoutes.doctorSettings);
          default:
            setState(() => _navIndex = index);
        }
      case NotificationsAudience.patient:
        switch (index) {
          case 0:
            context.go(AppRoutes.patientDashboard);
          case 1:
            context.go(AppRoutes.patientRecords);
          case 2:
            context.go(AppRoutes.patientAiInsights);
          case 3:
            break;
          case 4:
            context.go(AppRoutes.patientSettings);
          default:
            setState(() => _navIndex = index);
        }
    }
  }

  void _openItem(String itemId, String title) {
    if (widget.audience == NotificationsAudience.chw) {
      final patientId = _patientIdFromNotification(itemId);
      if (patientId != null) {
        context.push(AppRoutes.chwHealthRecordFor(patientId));
        return;
      }
    }
    debugPrint('Open · $title');
  }

  String? _patientIdFromNotification(String id) {
    for (final prefix in ['risk-', 'flag-']) {
      if (id.startsWith(prefix)) return id.substring(prefix.length);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
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
                          onTap: () => _openItem(item.id, item.title),
                          onAction: () => _openItem(item.id, item.title),
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
      bottomNavigationBar: switch (widget.audience) {
        NotificationsAudience.chw => const ChwBottomNav(currentIndex: 3),
        NotificationsAudience.doctor => DoctorBottomNavigationBar(
          currentIndex: _navIndex,
          onTap: _onNavTap,
        ),
        NotificationsAudience.patient => PatientBottomNavigationBar(
          currentIndex: _navIndex,
          onTap: _onNavTap,
        ),
      },
    );
  }
}
