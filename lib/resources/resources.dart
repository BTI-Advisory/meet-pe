import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meet_pe/utils/extensions.dart';

class AppResources {
  // Color
  static const colorVitamine = Color(0xFFFF4C00);
  static const colorOrangeLight = Color(0xFFFEA855);
  static const colorBeige = Color(0xFFF1E7DA);
  static const colorBeigeLight = Color(0xFFF8F3EC);
  static const colorWhite = Color(0xFFFFFFFF);
  static const colorDark = Color(0xFF1D1D1D);
  static const colorDeactivate = Color(0xFFBBBBBB);
  static const colorImputStroke = Color(0xFFE2E2E2);

  static const colorGray100 = Color(0xFF161413);
  static const colorGray90 = Color(0xFF2D2C2B);
  static const colorGray75 = Color(0xFF504F4E);
  static const colorGray60 = Color(0xFF737271);
  static const colorGray45 = Color(0xFF969595);
  static const colorGray30 = Color(0xFFB9B9B8);
  static const colorGray15 = Color(0xFFDCDCDC);
  static const colorGray5 = Color(0xFFF3F3F3);

  static const colorGray = Color(0xFF989898);


  // Padding
  static const paddingTitle = EdgeInsets.symmetric(horizontal: 35);
  static const paddingPageLarge =
  EdgeInsets.symmetric(horizontal: 35, vertical: 20);
  static const paddingPageLargeHorizontal =
  EdgeInsets.symmetric(horizontal: 35);
  static const paddingPage = EdgeInsets.all(15);
  static final marginCard = EdgeInsets.symmetric(
      horizontal: AppResources.paddingPage.left,
      vertical: AppResources.paddingPage.top / 2);
  static const paddingContent = EdgeInsets.all(10);

  // Spacer
  static const spacerTiny = SizedBox(width: 5, height: 5);
  static const spacerSmall = SizedBox(width: 10, height: 10);
  static const spacerMedium = SizedBox(width: 15, height: 15);
  static const spacerLarge = SizedBox(width: 20, height: 20);
  static const spacerExtraLarge = SizedBox(width: 30, height: 30);
  static const spacerHuge = SizedBox(width: 45, height: 45);

  // Border Radius
  static const borderRadiusTiny = BorderRadius.all(Radius.circular(5));
  static const borderRadiusSmall = BorderRadius.all(Radius.circular(10));
  static const borderRadiusMedium = BorderRadius.all(Radius.circular(15));
  static const borderRadiusMax = BorderRadius.all(Radius.circular(500));

  // Shape
  static const shapeRoundedRectangleTiny =
  RoundedRectangleBorder(borderRadius: AppResources.borderRadiusTiny);
  static const shapeRoundedRectangleSmall =
  RoundedRectangleBorder(borderRadius: AppResources.borderRadiusSmall);
  static const shapeRoundedRectangleMedium =
  RoundedRectangleBorder(borderRadius: AppResources.borderRadiusMedium);
  static const shapeRoundedTopLarge = RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)));

  // Duration
  static const durationAnimationMedium = Duration(milliseconds: 250);
  static const durationAnimationShort = Duration(milliseconds: 100);

  // Formatter
  static final formatterDate = DateFormat('d MMMM yyyy');
  static final formatterDateTime = DateFormat('d MMMM yyyy à HH:mm');
  static final _formatterMonthShort = DateFormat('MMM');
  static final formatterTime = DateFormat('HH:mm');

  // Validator
  static String? validatorNotEmpty(String? value) =>
      value?.isNotEmpty != true ? textFormMandatory : null;
  static String? validatorPassword(String? value) =>
      value == null || value.length < 6 ? 'Ⓧ 6 caractères minimum' : null;
  static final _validatorEmailRegex = RegExp(
      r'^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,})$',
      caseSensitive: false);
  static String? validatorEmail(String? value, [bool acceptEmpty = false]) =>
      (!acceptEmpty || value?.isNotEmpty == true) &&
          !_validatorEmailRegex.hasMatch(value!)
          ? 'Ⓧ Format incorrect'
          : null;
  static String? validatorSiren(String? value) =>
      value == null || value.length != 9 ? 'Ⓧ 9 caractères obligatoire' : null;

  // String
  static const textFormMandatory = 'Ⓧ Obligatoire';
  static const textNoResult = 'Aucun résultat';
}

extension ExtendedDateTime on DateTime {
  String toMonthShort() => AppResources._formatterMonthShort
      .format(this)
      .replaceAll('.', '')
      .capitalized;
}
