import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'auth_session.dart';

/// Notifies [GoRouter] whenever the auth session changes so redirects re-run.
@lazySingleton
class AuthRouterRefresh extends ChangeNotifier {
  late final StreamSubscription<AuthSessionStatus> _subscription;

  AuthRouterRefresh(AuthSessionProvider authSessionProvider) {
    _subscription = authSessionProvider.statusStream.listen((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
