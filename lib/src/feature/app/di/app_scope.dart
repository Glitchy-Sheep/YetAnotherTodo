import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../core/tools/logger.dart';

class AppScope extends InheritedWidget {
  final Dio dio;

  AppScope({
    required super.child,
    required this.dio,
    super.key,
  }) {
    dio.get('https://beta.mrdekk.ru/todo').then((value) {
      logger.i('Got data: ${value.data}');
    });
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static AppScope of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppScope>()!;
  }

  static AppScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppScope>();
  }
}
