import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

abstract class UpgraderService {
  Future<void> initialize();

  void ensureListening({required GlobalKey<NavigatorState> navigatorKey});
}

class AppUpgraderService implements UpgraderService {
  final bool showDebugUpgradeDialog;
  late final Upgrader _upgrader;
  bool _isInitialized = false;
  bool _isListening = false;
  bool _isDialogVisible = false;
  GlobalKey<NavigatorState>? _navigatorKey;
  Timer? _navigatorProbeTimer;

  AppUpgraderService({this.showDebugUpgradeDialog = false});

  @override
  Future<void> initialize() async {
    _upgrader = Upgrader(
      debugDisplayAlways: showDebugUpgradeDialog && kDebugMode,
    );
    await _upgrader.initialize();
    _isInitialized = true;
  }

  @override
  void ensureListening({required GlobalKey<NavigatorState> navigatorKey}) {
    if (!_isInitialized) return;

    _navigatorKey = navigatorKey;
    _startNavigatorProbeIfNeeded();

    if (_isListening) return;
    _isListening = true;

    _upgrader.stateStream.listen((_) {
      _tryShowForcedUpgradeDialog();
    });

    _tryShowForcedUpgradeDialog();
  }

  void _startNavigatorProbeIfNeeded() {
    final context = _navigatorKey?.currentContext;
    if (context != null || _navigatorProbeTimer != null) return;

    _navigatorProbeTimer = Timer.periodic(
      const Duration(milliseconds: 150),
      (timer) {
        if (_navigatorKey?.currentContext != null) {
          timer.cancel();
          _navigatorProbeTimer = null;
          _tryShowForcedUpgradeDialog();
        }
      },
    );
  }

  Future<void> _tryShowForcedUpgradeDialog() async {
    if (_isDialogVisible) return;
    final context = _navigatorKey?.currentContext;
    if (context == null || !context.mounted) return;
    if (!_upgrader.shouldDisplayUpgrade()) return;

    _isDialogVisible = true;

    final messages = _upgrader.determineMessages(context);
    final title = messages.message(UpgraderMessage.title) ?? 'Update required';
    final message = _upgrader.body(messages);
    final releaseNotes = _upgrader.releaseNotes;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message),
                  if (releaseNotes != null && releaseNotes.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      releaseNotes,
                      style: Theme.of(dialogContext).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              FilledButton(
                onPressed: _upgrader.sendUserToAppStore,
                child:
                    Text(messages.message(UpgraderMessage.buttonTitleUpdate)!),
              ),
            ],
          ),
        );
      },
    );

    _isDialogVisible = false;
  }
}
