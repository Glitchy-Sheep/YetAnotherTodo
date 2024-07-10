import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/api/dio_configuration.dart';
import '../../core/api/interceptors/auth_interceptor.dart';
import '../../core/database/database_impl.dart';
import '../../core/router/router.dart';
import '../../core/uikit/theme.dart';
import 'di/app_scope.dart';
import 'preferences.dart';

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

  // All the DI will be done in the [YetAnotherTodoApp] class
  @override
  Widget build(BuildContext context) {
    return AppScope(
      dio: AppDioConfigurator.create(
        interceptors: [
          AuthDioInterceptor(
            token: dotenv.env['API_TOKEN']!,
          ),
        ],
        url: dotenv.env['API_BASE_URL']!,
      ),
      db: db,
      child: AppPreferencesScope(
        preferences: sharedPrefs,
        child: MaterialApp.router(
          routerConfig: _appRouter.config(),
          debugShowCheckedModeBanner: false,
          theme: AppThemeData.lightTheme,
          darkTheme: AppThemeData.darkTheme,
          // Override the default localization delegate
          // so the app is consistent with its language.
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            AppLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
  }
}
