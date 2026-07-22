import 'package:injectable/injectable.dart';

import '../network/network_info.dart';

/// UI-facing connectivity state (e.g. for a global "you're offline" banner),
/// distinct from [NetworkInfo] which repositories use to make a one-off
/// local-vs-remote decision per call. This service caches the last known
/// value so a newly-built widget can read it synchronously instead of
/// waiting on the first stream event.
@lazySingleton
class ConnectivityService {
  final NetworkInfo _networkInfo;

  bool _lastKnownStatus = true;

  ConnectivityService(this._networkInfo) {
    _networkInfo.onConnectivityChanged.listen((isConnected) {
      _lastKnownStatus = isConnected;
    });
  }

  bool get isOnline => _lastKnownStatus;

  Stream<bool> get onStatusChanged => _networkInfo.onConnectivityChanged;
}
