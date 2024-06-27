import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AppScope extends InheritedWidget {
  final Dio dio;

  const AppScope({
    required super.child,
    required this.dio,
    super.key,
  });

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
