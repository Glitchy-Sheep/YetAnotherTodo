import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/core/tools/logger.dart';
import 'src/feature/app/app_entry_point.dart';

void main() {
  PlatformDispatcher.instance.onError = (error, stackTrace) {
    logger.e('$error \n $stackTrace \n');
    return true;
  };

  FlutterError.onError = (details) {
    logger.e('${details.exception} \n ${details.stack} \n');
  };

  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await dotenv.load(fileName: 'config.env');
      logger.i('ENV FILE LOADED');

      final sharedPrefs = await SharedPreferences.getInstance();

      // App entry point
      runApp(YetAnotherTodoApp(sharedPrefs: sharedPrefs));
    },
    (error, stackTrace) {
      logger.e('$error \n $stackTrace \n');
    },
  );
}
