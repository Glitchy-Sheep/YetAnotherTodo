import 'package:flutter/material.dart';

import 'colors.dart';

abstract class AppDecorations {
  static const taskInputContainer = BoxDecoration(
    color: ColorPalette.lightBackElevated,
    borderRadius: BorderRadius.all(
      Radius.circular(8),
    ),
    boxShadow: [
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.06),
        blurRadius: 2,
      ),
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.12),
        blurRadius: 2,
        offset: Offset(0, 2),
      ),
    ],
  );
}
