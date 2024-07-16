import 'package:flutter/material.dart';

import 'colors.dart';

/// Storage for all the icons used in the app
abstract class AppIcons {
  static const Icon arrowDown = Icon(
    Icons.arrow_downward,
  );

  static const Icon important = Icon(
    Icons.priority_high,
  );

  static const Icon delete = Icon(
    Icons.delete,
    size: 24,
  );

  static const Icon closeBlack = Icon(
    Icons.close,
  );

  static const Icon closeWhite = Icon(
    Icons.close,
    color: ColorPalette.lightColorWhite,
  );

  static const visibleIcon = Icon(
    Icons.visibility,
    size: 24,
  );

  static const hiddenIcon = Icon(
    Icons.visibility_off,
    size: 24,
  );

  static const Icon add = Icon(
    Icons.add,
  );

  static const Icon check = Icon(
    Icons.check,
    color: ColorPalette.lightColorWhite,
  );

  static const Icon taskInfo = Icon(
    Icons.info_outline,
    size: 24,
  );
}
