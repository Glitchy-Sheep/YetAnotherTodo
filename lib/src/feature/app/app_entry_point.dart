import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../core/api/auth_interceptor.dart';
import '../../core/api/dio_configuration.dart';
import '../../core/uikit/theme.dart';
import '../todo/presentation/screens/todo_view.dart';
import 'di/app_scope.dart';

/// The entry point of the app
class YetAnotherTodoApp extends StatelessWidget {
  const YetAnotherTodoApp({super.key});

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
        url: 'https://beta.mrdekk.ru/todo',
      ),
      child: MaterialApp(
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
        home: const TodoViewScreen(),
      ),
    );
  }
}
