import 'package:flutter/material.dart';

abstract class AppDecorations {
  static const taskInputContainer = BoxDecoration(
    borderRadius: BorderRadius.all(
      Radius.circular(8),
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0x0f000000),
        blurRadius: 2,
      ),
      BoxShadow(
        color: Color(0x1f000000),
        blurRadius: 2,
        offset: Offset(0, 2),
      ),
    ],
  );
}
