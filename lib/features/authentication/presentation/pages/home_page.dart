import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/routing/auth_session.dart';
import '../../../../core/routing/role_home.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/backgrounds/app_gradient_background.dart';

/// AUTH home shell — authenticated users are sent to their role landing
/// screen once the session role is known.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription<AuthSessionStatus>? _subscription;
  Timer? _timeout;

  @override
  void initState() {
    super.initState();
    final session = getIt<AuthSessionProvider>();
    _tryNavigate(session);

    _subscription = session.statusStream.listen((_) {
      if (!mounted) return;
      _tryNavigate(session);
    });

    // If role never resolves (network), escape the spinner.
    _timeout = Timer(const Duration(seconds: 8), () {
      if (!mounted) return;
      final role = getIt<AuthSessionProvider>().currentRole;
      if (role == UserRole.unknown) {
        context.go(RoleHome.forRole(UserRole.unknown));
      }
    });
  }

  void _tryNavigate(AuthSessionProvider session) {
    if (session.currentStatus != AuthSessionStatus.authenticated) {
      return;
    }
    final role = session.currentRole;
    if (role == UserRole.unknown) {
      return;
    }
    _timeout?.cancel();
    context.go(RoleHome.forRole(role));
  }

  @override
  void dispose() {
    unawaited(_subscription?.cancel() ?? Future<void>.value());
    _timeout?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
    );
  }
}
