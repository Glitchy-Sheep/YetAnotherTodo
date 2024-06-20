//ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

/// App Text Style contains all
/// typography styles used in the app
enum AppTextStyle {
  largeTitle(TextStyle(
    fontSize: 32.0,
    height: 32 / 38,
    fontWeight: FontWeight.bold,
    fontFamily: "Roboto",
  )),

  mediumTitle(TextStyle(
    fontSize: 20.0,
    height: 20 / 32,
    fontFamily: "Roboto",
  )),

  buttonText(TextStyle(
    fontSize: 14.0,
    height: 14 / 24,
    fontFamily: "Roboto",
  )),

  bodyText(TextStyle(
    fontSize: 16.0,
    height: 16 / 20,
    fontFamily: "Roboto",
  )),

  subheadText(TextStyle(
    fontSize: 14.0,
    height: 14 / 20,
    fontFamily: "Roboto",
  ));

  final TextStyle value;

  const AppTextStyle(this.value);
}
