import 'package:flutter/material.dart';

/// App Text Style contains all
/// typography styles used in the app

abstract class AppTextStyle {
  static const largeTitle = TextStyle(
    fontSize: 32,
    height: 38 / 32,
    fontWeight: FontWeight.w500,
    fontFamily: 'Roboto',
  );

  static const mediumTitle = TextStyle(
    fontSize: 20,
    height: 32 / 20,
    fontWeight: FontWeight.w500,
    fontFamily: 'Roboto',
  );

  static const buttonText = TextStyle(
    fontSize: 14,
    height: 24 / 14,
    fontWeight: FontWeight.w500,
    fontFamily: 'Roboto',
  );

  static const bodyText = TextStyle(
    fontSize: 16,
    height: 20 / 16,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
  );

  static const subheadText = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
  );
}
