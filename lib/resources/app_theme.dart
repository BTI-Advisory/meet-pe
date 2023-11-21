import 'package:flutter/material.dart';
import 'resources.dart';

/// Build App Theme.
///
/// It's NOT a simple variable to allow hot reload to work properly.
/// Should not affect performance much.
ThemeData buildAppTheme({bool darkMode = false}) {
  final backgroundColor = darkMode ? AppResources.colorBlack : AppResources.colorWhite;
  final foregroundColor = darkMode ? AppResources.colorWhite : AppResources.colorBlack;
  final primaryColor = darkMode ? AppResources.colorRed : AppResources.colorRed;

  final textTheme = const TextTheme(
    titleLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
    ),
    titleMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w400,
    ),
    titleSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    bodyLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
    bodyMedium: TextStyle(    // Default Text widget style
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
  ).apply(
    fontFamily: 'Rammetto One',
    bodyColor: foregroundColor,
    displayColor: foregroundColor,
  );

  const inputDecorationBorder = OutlineInputBorder(
    borderRadius: AppResources.borderRadiusMax,
  );

  return ThemeData(
    colorScheme: darkMode
        ? ColorScheme.dark(primary: primaryColor)
        : ColorScheme.light(primary: primaryColor),
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    textTheme: textTheme,
    iconTheme: IconThemeData(
      color: foregroundColor,
    ),
    canvasColor: backgroundColor,
    inputDecorationTheme: InputDecorationTheme(
      border: inputDecorationBorder,
      focusedBorder: inputDecorationBorder.copyWith(
        borderSide: BorderSide(
          color: primaryColor,
          width: 2,
        ),
      ),
      filled: true,
      fillColor: backgroundColor,
      isDense: true,    // Allow icons to be correctly sized
      errorStyle: textTheme.bodyMedium?.copyWith(color: AppResources.colorWhite),
      hintStyle: textTheme.bodyMedium?.copyWith(color: AppResources.colorDeactivate),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(primaryColor),
        foregroundColor: MaterialStateProperty.all(AppResources.colorWhite),
        overlayColor: MaterialStateProperty.all(AppResources.colorWhite.withOpacity(0.2)),
        shape: MaterialStateProperty.all(const StadiumBorder()),
        side: MaterialStateProperty.all(const BorderSide(
          color: AppResources.colorWhite,
          width: 3,
        )),
        minimumSize: MaterialStateProperty.all(const Size(80, 40)),
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 25)),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: AppResources.colorWhite,
    ),
    cardTheme: CardTheme(
      color: darkMode ? AppResources.colorBlack : AppResources.colorBlack,
      margin: EdgeInsets.zero,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: AppResources.shapeRoundedRectangleSmall,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(primaryColor),
      side: const BorderSide(
        color: AppResources.colorDeactivate,
        width: 1,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: backgroundColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: foregroundColor,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      shape: AppResources.shapeRoundedTopLarge,
      clipBehavior: Clip.antiAlias,
      backgroundColor: darkMode ? AppResources.colorWhite : AppResources.colorWhite,
    ),
  );
}
