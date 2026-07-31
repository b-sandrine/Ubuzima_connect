import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/connectivity_service.dart';

/// App-wide online/offline state for OFFLINE-01's banner.
///
/// Mirrors `LocaleCubit`'s placement: connectivity, like locale, is
/// cross-cutting (any screen might want to know it), so it lives in
/// `core/` rather than inside a feature, and is provided once above
/// `MaterialApp` in `app.dart`. It adds no logic beyond exposing
/// [ConnectivityService] as a stream of Bloc state — the actual
/// connectivity detection stays in that one service so it isn't
/// duplicated here.
@lazySingleton
class ConnectivityCubit extends Cubit<bool> {
  final ConnectivityService _service;
  late final StreamSubscription<bool> _subscription;

  ConnectivityCubit(this._service) : super(_service.isOnline) {
    _subscription = _service.onStatusChanged.listen(emit);
  }

  bool get isOnline => state;

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
