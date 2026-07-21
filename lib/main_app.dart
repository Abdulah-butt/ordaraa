import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'core/navigation/app_navigator.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/constants.dart';
import 'presentation/widgets/internet_connection_overlay.dart';
import 'presentation/widgets/something_went_wrong.dart';
import 'service_locator/service_locator.dart';
import 'services/connectivity/connectivity_service.dart';
import 'services/upgrader/upgrader_service.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final upgraderService = getIt<UpgraderService>();
    final connectivityService = getIt<ConnectivityService>();
    upgraderService.ensureListening(navigatorKey: AppNavigator.navigatorKey);

    return MaterialApp.router(
      routerConfig: AppRouter.router,
      localizationsDelegates: [
        ...GlobalMaterialLocalizations.delegates,
        ...PhoneFieldLocalization.delegates,
      ],
      supportedLocales: const [Locale('en')],
      builder: (BuildContext context, Widget? child) {
        ErrorWidget.builder = (errorDetails) => const SomethingWentWrong();
        final appView = MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.noScaling),
          child: child ?? const SizedBox.shrink(),
        );
        return StreamBuilder<bool>(
          stream: connectivityService.internetConnectionStream,
          initialData: connectivityService.isOnline,
          builder: (context, snapshot) {
            final isOnline = snapshot.data ?? true;
            return Stack(
              fit: StackFit.expand,
              children: [
                appView,
                if (!isOnline) const InternetConnectionOverlay(),
              ],
            );
          },
        );
      },
      title: kAppName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
    );
  }
}
