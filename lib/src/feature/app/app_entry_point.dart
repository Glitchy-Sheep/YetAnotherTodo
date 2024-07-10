import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/api/dio_configuration.dart';
import '../../core/api/interceptors/auth_interceptor.dart';
import '../../core/database/database_impl.dart';
import '../../core/router/router.dart';
import '../../core/uikit/uikit.dart';
import 'app_settings.dart';
import 'di/app_scope.dart';

/// The entry point of the app
class YetAnotherTodoApp extends StatelessWidget {
  final SharedPreferences sharedPrefs;
  final AppDatabaseImpl db;
  final AppRouter _appRouter;

  YetAnotherTodoApp({
    required this.db,
    required this.sharedPrefs,
    super.key,
  }) : _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return AppScope(
      // ------ Main App Scope Init ------
      db: db,
      dio: AppDioConfigurator.create(
        interceptors: [
          AuthDioInterceptor(
            token: dotenv.env['API_TOKEN']!,
          ),
        ],
        url: dotenv.env['API_BASE_URL']!,
      ),
      appSettingsRepository: AppSettingsRepository(
        sharedPreferences: sharedPrefs,
      ),
      // ---------------------------------
      child: MaterialApp.router(
        routerConfig: _appRouter.config(),
        debugShowCheckedModeBanner: false,
        theme: AppThemeData.lightTheme,
        darkTheme: AppThemeData.darkTheme,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          AppLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}
