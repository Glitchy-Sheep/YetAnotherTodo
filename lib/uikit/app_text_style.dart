import 'package:flutter/material.dart';
import 'package:yet_another_todo/uikit/colors.dart';

/// App Text Style contains all
/// typography styles used in the app

abstract class AppTextStyle {
  static const largeTitle = TextStyle(
    fontSize: 32.0,
    height: 38 / 32,
    fontWeight: FontWeight.w500,
    fontFamily: "Roboto",
    color: ColorPalette.lightLabelPrimary,
  );

  static const mediumTitle = TextStyle(
    fontSize: 20.0,
    height: 32 / 20,
    fontWeight: FontWeight.w500,
    fontFamily: "Roboto",
    color: ColorPalette.lightLabelPrimary,
  );

  static const buttonText = TextStyle(
    fontSize: 14.0,
    height: 24 / 14,
    fontWeight: FontWeight.w500,
    fontFamily: "Roboto",
    color: ColorPalette.lightLabelPrimary,
  );

  static const bodyText = TextStyle(
    fontSize: 16.0,
    height: 20 / 16,
    fontWeight: FontWeight.w400,
    fontFamily: "Roboto",
    color: ColorPalette.lightLabelPrimary,
  );

  static const subheadText = TextStyle(
    fontSize: 14.0,
    height: 20 / 14,
    fontFamily: "Roboto",
    fontWeight: FontWeight.w400,
    color: ColorPalette.lightLabelTertiary,
  );
}
