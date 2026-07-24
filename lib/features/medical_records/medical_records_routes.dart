import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import 'presentation/pages/patient_timeline_page.dart';

/// Route definitions owned by the medical records feature (DOC-04), appended
/// into the single `GoRouter` in `core/routing/app_router.dart`.
abstract final class MedicalRecordsRoutes {
  static List<RouteBase> get routes => [
    GoRoute(
      path: AppRoutes.patientTimeline,
      builder: (context, state) => const PatientTimelinePage(),
    ),
  ];
}
