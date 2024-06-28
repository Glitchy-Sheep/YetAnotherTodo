import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:yet_another_todo/feature/todo/presentation/screens/todo_view.dart';

/// The entry point of the app
class YetAnotherTodoApp extends StatelessWidget {
  const YetAnotherTodoApp({super.key});

  // All the DI will be done in the [YetAnotherTodoApp] class
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
      ),
      // Override the default localization delegate
      // so the app is consistent with its language.
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('ru'),
      ],
      home: const TodoViewScreen(),
    );
  }
}
