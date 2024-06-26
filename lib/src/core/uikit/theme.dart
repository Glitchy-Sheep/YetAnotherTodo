import 'package:flutter/material.dart';

import 'app_text_style.dart';
import 'colors.dart';

abstract class AppThemeData {
  static final lightTheme = ThemeData(
    useMaterial3: false,

    // Basic color scheme
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: ColorPalette.lightColorBlue,
      onPrimary: ColorPalette.lightColorWhite,
      secondary: ColorPalette.lightColorGreen,
      onSecondary: ColorPalette.lightColorWhite,
      error: ColorPalette.lightColorRed,
      onError: ColorPalette.lightColorWhite,
      surface: ColorPalette.ligthBackPrimary,
      onSurface: ColorPalette.ligthBackPrimary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: ColorPalette.ligthBackPrimary,
    ),

    // Typography
    textTheme: const TextTheme(
      titleLarge: AppTextStyle.largeTitle,
      titleMedium: AppTextStyle.mediumTitle,
      bodyMedium: AppTextStyle.bodyText,
      bodySmall: AppTextStyle.subheadText,
      bodyLarge: AppTextStyle.buttonText,
    ),

    // Input decoration
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      shape: CircleBorder(),
      sizeConstraints: BoxConstraints(
        minHeight: 56,
        minWidth: 56,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return ColorPalette.lightColorGreen;
          }
          return null;
        },
      ),
      checkColor: const WidgetStatePropertyAll(ColorPalette.lightColorWhite),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: AppTextStyle.buttonText,
    ),
    iconButtonTheme: const IconButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(
          EdgeInsets.all(16),
        ),
      ),
    ),
    textButtonTheme: const TextButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ColorPalette.lightColorBlue;
        } else {
          return ColorPalette.lightBackElevated;
        }
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ColorPalette.lightColorBlue.withOpacity(0.30);
        } else {
          return ColorPalette.lightSupportOverlay;
        }
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.transparent;
        } else {
          return ColorPalette.lightLabelTertiary;
        }
      }),
    ),

    // List tile
    listTileTheme: const ListTileThemeData(
      horizontalTitleGap: 4.0,
    ),
    dividerColor: ColorPalette.lightSupportSeparator,
    dividerTheme: const DividerThemeData(
      thickness: 1,
    ),

    // DatePicker (calendar)
    datePickerTheme: const DatePickerThemeData(
      headerBackgroundColor: ColorPalette.lightColorBlue,
      headerForegroundColor: ColorPalette.lightColorWhite,
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: false,

    // Basic color scheme
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: ColorPalette.darkColorBlue,
      onPrimary: ColorPalette.darkColorWhite,
      secondary: ColorPalette.darkColorGreen,
      onSecondary: ColorPalette.darkColorWhite,
      error: ColorPalette.darkColorRed,
      onError: ColorPalette.darkColorWhite,
      surface: ColorPalette.ligthBackPrimary,
      onSurface: ColorPalette.darkBackPrimary,
    ),

    // Typography
    textTheme: const TextTheme(
      titleLarge: AppTextStyle.largeTitle,
      titleMedium: AppTextStyle.mediumTitle,
      bodyMedium: AppTextStyle.bodyText,
      bodySmall: AppTextStyle.subheadText,
      bodyLarge: AppTextStyle.buttonText,
    ),

    // Input decoration
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      shape: CircleBorder(),
      sizeConstraints: BoxConstraints(
        minHeight: 56,
        minWidth: 56,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return ColorPalette.darkColorGreen;
          }
          return null;
        },
      ),
      checkColor: const WidgetStatePropertyAll(ColorPalette.lightColorWhite),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: AppTextStyle.buttonText,
    ),
    iconButtonTheme: const IconButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(
          EdgeInsets.all(16),
        ),
      ),
    ),
    textButtonTheme: const TextButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ColorPalette.darkColorBlue;
        } else {
          return ColorPalette.darkBackElevated;
        }
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ColorPalette.darkColorBlue.withOpacity(0.30);
        } else {
          return ColorPalette.darkSupportOverlay;
        }
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.transparent;
        } else {
          return ColorPalette.darkLabelTertiary;
        }
      }),
    ),

    // List tile
    listTileTheme: const ListTileThemeData(
      horizontalTitleGap: 4.0,
    ),
    dividerColor: ColorPalette.darkSupportSeparator,
    dividerTheme: const DividerThemeData(
      thickness: 1,
    ),

    // DatePicker (calendar)
    datePickerTheme: const DatePickerThemeData(
      headerBackgroundColor: ColorPalette.darkColorBlue,
      headerForegroundColor: ColorPalette.darkColorWhite,
    ),
  );
}
