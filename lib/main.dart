import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runZonedGuarded(() {
    runApp(const MyApp());
  }, (error, stackTrace) {});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YetAnotherTodo App - The beginning',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Placeholder(),
    );
  }
}
