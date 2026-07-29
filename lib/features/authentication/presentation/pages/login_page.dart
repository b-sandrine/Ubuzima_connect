import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../shared/widgets/backgrounds/app_gradient_background.dart';
import '../../domain/entities/user_role.dart';
import '../../domain/usecases/get_selected_role.dart';
import '../bloc/login_bloc.dart';
import 'chw_login_view.dart';
import 'role_login_view.dart';

/// AUTH-02 — role-aware sign-in via Firebase Auth.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginBloc>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  UserRole? _selectedRole;
  var _roleLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    final result = await getIt<GetSelectedRole>()();
    if (!mounted) return;

    result.fold(
      (_) => setState(() {
        _selectedRole = null;
        _roleLoaded = true;
      }),
      (role) => setState(() {
        _selectedRole = role;
        _roleLoaded = true;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_roleLoaded) {
      return const Scaffold(
        backgroundColor: Colors.transparent,
        body: AppGradientBackground(
          child: SafeArea(
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      );
    }

    final role = _selectedRole ?? UserRole.patient;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          child: role == UserRole.communityHealthWorker
              ? const ChwLoginView()
              : RoleLoginView(role: role),
        ),
      ),
    );
  }
}
