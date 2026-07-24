import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import 'presentation/pages/patient_medications_page.dart';

/// Route definitions owned by the prescriptions feature (PAT-03), appended
/// into the single `GoRouter` in `core/routing/app_router.dart`.
abstract final class PrescriptionsRoutes {
  static List<RouteBase> get routes => [
    GoRoute(
      path: AppRoutes.patientMedications,
      builder: (context, state) => const PatientMedicationsPage(),
    ),
  ];
}
