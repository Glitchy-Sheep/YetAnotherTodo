import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'src/core/database/database_impl.dart';
import 'src/core/tools/logger.dart';
import 'src/feature/app/app_entry_point.dart';

const _loggerPrefix = '[MAIN]';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  PlatformDispatcher.instance.onError = (error, stackTrace) {
    logger.e('$error \n $stackTrace \n');
    return true;
  };

  FlutterError.onError = (details) {
    logger.e('${details.exception} \n ${details.stack} \n');
  };

  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await dotenv.load(
        fileName: 'config.env',
        mergeWith: Platform.environment,
      );
      logger.i('$_loggerPrefix: .env config file loaded');

      final sharedPrefs = await SharedPreferences.getInstance();
      logger.i('$_loggerPrefix: Shared preferences initialized');

      final db = AppDatabaseImpl();
      logger
        ..i('$_loggerPrefix: Database initialized')
        ..i('Your local revision: ${await db.revisionDao.getRevision()}');

      // App entry point
      runApp(YetAnotherTodoApp(
        sharedPrefs: sharedPrefs,
        db: db,
      ));
    },
    (error, stackTrace) {
      logger.e(
        error,
        stackTrace: stackTrace,
      );
    },
  );
}
