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
    color: ColorPalette.lightColorRed,
    size: 24,
  );

  static const Icon closeBlack = Icon(
    Icons.close,
    color: ColorPalette.lightLabelPrimary,
  );

  static const Icon closeWhite = Icon(
    Icons.close,
    color: ColorPalette.lightColorWhite,
  );

  static const eyeIcon = Icon(
    Icons.remove_red_eye,
    size: 24,
    color: ColorPalette.lightColorBlue,
  );

  static const Icon add = Icon(
    Icons.add,
    color: ColorPalette.lightColorWhite,
  );

  static const Icon check = Icon(
    Icons.check,
    color: ColorPalette.lightColorWhite,
  );

  static const Icon taskInfo = Icon(
    Icons.info_outline,
    color: ColorPalette.lightLabelTertiary,
  );
}
