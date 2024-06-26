import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
      // App entry point
      runApp(const YetAnotherTodoApp());
    },
    (error, stackTrace) {
      logger.e('$error \n $stackTrace \n');
    },
  );
}
