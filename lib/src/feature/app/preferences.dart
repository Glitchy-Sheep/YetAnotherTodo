import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/tools/logger.dart';

class AppPreferencesScope extends InheritedWidget {
  final SharedPreferences _preferences;

  static const _keyIsCompletedTasksVissible = 'isCompletedTasksVissible';

  AppPreferencesScope({
    required SharedPreferences preferences,
    required super.child,
    super.key,
  }) : _preferences = preferences {
    logger.i('Shared preferences initialized');
  }

  bool get isCompletedTasksVissible =>
      _preferences.getBool(_keyIsCompletedTasksVissible) ?? true;

  void setCompletedTasksVissible({required bool newValue}) {
    _preferences.setBool(_keyIsCompletedTasksVissible, newValue);
  }

  void toggleCompletedTasksVissible() {
    setCompletedTasksVissible(newValue: !isCompletedTasksVissible);
    logger.i('Visibility changed to $isCompletedTasksVissible');
  }

  static AppPreferencesScope of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppPreferencesScope>()!;
  }

  @override
  bool updateShouldNotify(AppPreferencesScope oldWidget) {
    return _preferences != oldWidget._preferences;
  }
}

extension AppPreferencesScopeExtension on BuildContext {
  AppPreferencesScope get preferences => AppPreferencesScope.of(this);
}
