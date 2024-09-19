import 'package:shared_preferences/shared_preferences.dart';
import '../../core/tools/logger.dart';

class AppSettingsRepository {
  final SharedPreferences _preferences;

  AppSettingsRepository({
    required SharedPreferences sharedPreferences,
  }) : _preferences = sharedPreferences;

  // Settings keys for shared preferences
  static const _keyIsCompletedTasksVissible = 'isCompletedTasksVissible';

  bool get isCompletedTasksVissible =>
      _preferences.getBool(_keyIsCompletedTasksVissible) ?? true;

  void setCompletedTasksVissible({required bool newValue}) {
    _preferences.setBool(_keyIsCompletedTasksVissible, newValue);
  }

  void toggleCompletedTasksVissible() {
    setCompletedTasksVissible(newValue: !isCompletedTasksVissible);
    logger.i('Visibility changed to $isCompletedTasksVissible');
  }
}
