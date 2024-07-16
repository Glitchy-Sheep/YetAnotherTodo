import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'colors.dart';

/// Storage for all the icons used in the app
abstract class AppIcons {
  static const arrowDown = Icon(
    Icons.arrow_downward,
  );

  static const important = Icon(
    Icons.priority_high,
  );

  static const delete = Icon(
    Icons.delete,
    size: 24,
  );

  static const closeBlack = Icon(
    Icons.close,
  );

  static const closeWhite = Icon(
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

  static const add = Icon(
    Icons.add,
  );

  static const check = Icon(
    Icons.check,
    color: ColorPalette.lightColorWhite,
  );

  static const taskInfo = Icon(
    Icons.info_outline,
    size: 24,
  );

  static final exclamationMarks = SvgPicture.asset(
    'assets/icons/exclamation_marks.svg',
    width: 16,
    height: 16,
  );

  static final arrowDownImportance = SvgPicture.asset(
    'assets/icons/arrow_down.svg',
    width: 16,
    height: 16,
  );
}
