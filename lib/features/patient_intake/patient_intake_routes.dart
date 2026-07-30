import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import 'presentation/pages/new_patient_intake_page.dart';

/// Route definitions owned by the patient intake feature, appended into the
/// single `GoRouter` in `core/routing/app_router.dart`.
abstract final class PatientIntakeRoutes {
  static List<RouteBase> get routes => [
    GoRoute(
      path: AppRoutes.newPatientIntake,
      builder: (context, state) => const NewPatientIntakePage(),
    ),
  ];
}
