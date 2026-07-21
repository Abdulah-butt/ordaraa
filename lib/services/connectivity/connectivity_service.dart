import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

abstract class ConnectivityService {
  Future<void> initialize();
  Stream<bool> get internetConnectionStream;
  bool get isOnline;
}

class AppConnectivityService implements ConnectivityService {
  final Connectivity _connectivity;
  final StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _isOnline = true;

  AppConnectivityService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  @override
  bool get isOnline => _isOnline;

  @override
  Stream<bool> get internetConnectionStream => _connectionController.stream;

  @override
  Future<void> initialize() async {
    final initialResults = await _connectivity.checkConnectivity();
    _emitConnectionStatus(_hasAnyConnection(initialResults));

    _subscription?.cancel();
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      _emitConnectionStatus(_hasAnyConnection(results));
    });
  }

  bool _hasAnyConnection(List<ConnectivityResult> results) {
    return !results.contains(ConnectivityResult.none);
  }

  void _emitConnectionStatus(bool isOnline) {
    if (_isOnline == isOnline) return;
    _isOnline = isOnline;
    _connectionController.add(isOnline);
  }
}
