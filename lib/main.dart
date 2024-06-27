import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
    () {
      dotenv.load(fileName: 'config.env');
      logger.i('ENV FILE LOADED');

      // App entry point
      runApp(const YetAnotherTodoApp());
    },
    (error, stackTrace) {
      logger.e('$error \n $stackTrace \n');
    },
  );
}
