import 'app_routes.dart';
import 'auth_session.dart';

/// Resolves the post-auth landing route for a given [UserRole].
abstract final class RoleHome {
  static String forRole(UserRole role) => switch (role) {
        UserRole.communityHealthWorker => AppRoutes.chwDashboard,
        UserRole.patient => AppRoutes.patientMedications,
        UserRole.doctor => AppRoutes.referralManagement,
        // Never return `/home` here — HomePage redirects through this helper,
        // so `unknown → home` would trap the user on an endless spinner.
        UserRole.unknown => AppRoutes.roleSelection,
      };
}
