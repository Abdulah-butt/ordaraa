import 'package:flutter/material.dart';
import 'core/routes/app_router.dart';
import 'main_app.dart';
import 'service_locator/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocator.initialize();
  AppRouter.initialize();
  runApp(const MainApp());
}
