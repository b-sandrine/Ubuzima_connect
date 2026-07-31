import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import 'presentation/pages/ai_insights_page.dart';
import 'presentation/pages/patient_medical_timeline_page.dart';
import 'presentation/pages/patient_dashboard_screen.dart';
import 'presentation/pages/patient_records_page.dart';

/// Route definitions owned by the patients feature (PAT-02b), appended into
/// the single `GoRouter` in `core/routing/app_router.dart`.
abstract final class PatientsRoutes {
  static List<RouteBase> get routes => [
        GoRoute(
          path: AppRoutes.patientDashboard,
          builder: (context, state) => const PatientDashboardScreen(),
        ),
        GoRoute(
          path: AppRoutes.patientRecords,
          builder: (context, state) => const PatientRecordsPage(),
        ),
        GoRoute(
          path: AppRoutes.patientAiInsights,
          builder: (context, state) => const AiInsightsPage(),
        ),
        GoRoute(
          path: AppRoutes.patientMedicalTimeline,
          builder: (context, state) => const PatientMedicalTimelinePage(),
        ),
      ];
}
