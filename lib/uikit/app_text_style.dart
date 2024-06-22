import 'package:flutter/material.dart';
import 'package:yet_another_todo/uikit/colors.dart';

/// App Text Style contains all
/// typography styles used in the app

abstract class AppTextStyle {
  static const largeTitle = TextStyle(
    fontSize: 32.0,
    height: 32 / 38,
    fontWeight: FontWeight.w500,
    fontFamily: "Roboto",
    color: ColorPalette.lightLabelPrimary,
  );

  static const mediumTitle = TextStyle(
    fontSize: 20.0,
    height: 20 / 32,
    fontWeight: FontWeight.w500,
    fontFamily: "Roboto",
    color: ColorPalette.lightLabelPrimary,
  );

  static const buttonText = TextStyle(
    fontSize: 14.0,
    height: 14 / 24,
    fontWeight: FontWeight.w500,
    fontFamily: "Roboto",
    color: ColorPalette.lightLabelPrimary,
  );

  static const bodyText = TextStyle(
    fontSize: 16.0,
    height: 16 / 20,
    fontWeight: FontWeight.w400,
    fontFamily: "Roboto",
    color: ColorPalette.lightLabelPrimary,
  );

  static const subheadText = TextStyle(
    fontSize: 14.0,
    height: 14 / 20,
    fontFamily: "Roboto",
    fontWeight: FontWeight.w400,
    color: ColorPalette.lightLabelTertiary,
  );
}
