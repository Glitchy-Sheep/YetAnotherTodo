import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yet_another_todo/core/utils/logger.dart';

void main() {
  PlatformDispatcher.instance.onError = (error, stackTrace) {
    logger.e("$error \n $stackTrace \n");
    return true;
  };

  FlutterError.onError = (FlutterErrorDetails details) {
    logger.e("${details.exception} \n ${details.stack} \n");
  };

  runZonedGuarded(() {
    runApp(const MyApp());
  }, (error, stackTrace) {
    logger.e("$error \n $stackTrace \n");
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    logger.i("App started");

    return MaterialApp(
      title: 'YetAnotherTodo App - The beginning',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Placeholder(),
    );
  }
}
