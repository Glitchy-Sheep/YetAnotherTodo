import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../core/uikit/theme.dart';
import '../todo/presentation/screens/todo_view.dart';

/// The entry point of the app
class YetAnotherTodoApp extends StatelessWidget {
  const YetAnotherTodoApp({super.key});

  // All the DI will be done in the [YetAnotherTodoApp] class
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
