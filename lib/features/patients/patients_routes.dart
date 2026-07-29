import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import 'presentation/pages/patient_medical_timeline_page.dart';

/// Route definitions owned by the patients feature (PAT-02b), appended into
/// the single `GoRouter` in `core/routing/app_router.dart`.
abstract final class PatientsRoutes {
  static List<RouteBase> get routes => [
    GoRoute(
      path: AppRoutes.patientMedicalTimeline,
      builder: (context, state) => const PatientMedicalTimelinePage(),
    ),
  ];
}
