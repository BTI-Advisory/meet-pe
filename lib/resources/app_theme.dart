import 'package:flutter/material.dart';
import 'resources.dart';

/// Build App Theme.
///
/// It's NOT a simple variable to allow hot reload to work properly.
/// Should not affect performance much.
ThemeData buildAppTheme({bool darkMode = false}) {
  final backgroundColor = darkMode ? AppResources.colorDark : AppResources.colorWhite;
  final foregroundColor = darkMode ? AppResources.colorWhite : AppResources.colorDark;
  final primaryColor = darkMode ? AppResources.colorVitamine : AppResources.colorVitamine;

  final textTheme = const TextTheme(
    displayMedium: TextStyle(
      fontSize: 52,
      fontWeight: FontWeight.w400,
      fontFamily: 'Rammetto One',
    ),
    headlineLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      fontFamily: 'Rammetto One',
    ),
    headlineMedium: TextStyle(
      color: AppResources.colorDark,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
    ),
    bodyLarge: TextStyle(
      color: AppResources.colorGray45,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    bodyMedium: TextStyle(
      color: AppResources.colorGray60,
      fontSize: 14,
      fontWeight: FontWeight.w300,
    ),
    bodySmall: TextStyle(
      color: AppResources.colorGray30,
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
  ).apply(
    fontFamily: 'Outfit',
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
      color: darkMode ? AppResources.colorDark : AppResources.colorDark,
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
