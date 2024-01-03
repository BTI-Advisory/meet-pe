import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:fetcher/src/exceptions/connectivity_exception.dart';
import 'package:fetcher/src/exceptions/unreported_exception.dart';
import 'exceptions/displayable_exception.dart';
import 'exceptions/ep_http_response_exception.dart';
import 'exceptions/operation_canceled_exception.dart';
import 'exceptions/permission_exception.dart';
import 'exceptions/unauthorized_exception.dart';
import '_utils.dart';

typedef JsonObject = Map<String, dynamic>;
typedef JsonList = Iterable<dynamic>;
typedef OptionalValueChanged<T> = void Function([T value]);
typedef LabelBuilder<T> = String Function(T data);

/// Navigate to a new pages.
/// Push a new pages built with [builder] on the navigation stack.
///
/// if [returnAfterPageTransition] is true, the Future will return as soon as the pages transition (animation) is over.
/// This is useful when you need an animation to keep running while the push transition is running, but to stop after the transition is over
/// (so that the animation is stopped during pop transition).
/// If null, will be set to true if [T] is not set.
///
/// if [animate] is false, the transition animation will be skipped.
Future<T?> navigateTo<T>(BuildContext context, WidgetBuilder builder, {
  bool removePreviousRoutesButFirst = false,
  int? removePreviousRoutesAmount,
  bool clearHistory = false,
  bool? returnAfterPageTransition,
  bool animate = true,
}) async {
  // Check arguments
  if ([removePreviousRoutesButFirst, removePreviousRoutesAmount, clearHistory]
      .where((a) => (a is bool ? a == true : a != null))
      .length > 1) {
    throw ArgumentError('only one of removePreviousRoutesUntilNamed, removePreviousRoutesButFirst, removePreviousRoutesAmount and clearHistory parameters can be set');
  }

  // Build route
  final route = MaterialPageRoute<T>(
    builder: builder,
  );

  // Navigate
  Future<T?> navigationFuture;
  if (removePreviousRoutesButFirst != true && removePreviousRoutesAmount == null && clearHistory != true) {
    navigationFuture = Navigator.of(context).push(route);
  } else {
    int removedCount = 0;
    navigationFuture = Navigator.of(context).pushAndRemoveUntil(
      route,
          (r) =>  (removePreviousRoutesButFirst != true || r.isFirst) &&
          (removePreviousRoutesAmount == null || removedCount++ >= removePreviousRoutesAmount) &&
          clearHistory != true,
    );
  }

  // Await
  returnAfterPageTransition ??= isTypeUndefined<T>();
  if (returnAfterPageTransition) {
    return await navigationFuture.timeout(route.transitionDuration * 2, onTimeout: () => null);
  } else {
    return await navigationFuture;
  }
}

/// Opens a modal bottom sheet
Future<void> openBottomSheet<T>({required BuildContext context, required WidgetBuilder builder, ValueChanged<T>? onResult}) async {
  // Clear current focus
  // Useful on pages with a form field
  context.clearFocus();

  // Open Bottom sheet
  final result = await showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return SafeArea(
        child: builder(context),
      );
    },
  );

  // Handle result
  if (result != null) {
    onResult?.call(result);
  }
}

/// Display a basic overlay
void showOverlay(BuildContext context, { required Widget Function(VoidCallback dismissCallback) builder, bool? fullWidth }) {
  final buttonRenderBox = context.findRenderObject() as RenderBox;
  final buttonSize = buttonRenderBox.size;
  final buttonPosition = buttonRenderBox.localToGlobal(Offset.zero);

  late VoidCallback dismissCallback;

  final overlay = OverlayEntry(
    builder: (context) => Stack(
      children: <Widget>[
        Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: (_) => dismissCallback(),
        ),
        Positioned(
          top: buttonPosition.dy + buttonSize.height,
          left: fullWidth != true ? buttonPosition.dx : 0,
          width: fullWidth != true ? buttonSize.width : null,
          right: fullWidth != true ? null : 0,
          bottom: 0,
          child: Align(
            alignment: Alignment.topCenter,
            child: builder(dismissCallback),
          ),
        ),
      ],
    ),
  );

  dismissCallback = () => overlay.remove();

  Overlay.of(context)?.insert(overlay);
}

/// Display an error to the user
Future<void> showError(BuildContext context, Object error) async {
  // Cancellation
  if (error is OperationCanceledException) {
    if (!error.silent) {
      showMessage(context, 'Opération annulée', isError: true);
    }
  }

  // Permission
  else if (error is PermissionDeniedException) {
    showMessage(context, 'Permission requise', isError: true);
  }

  // Bad connectivity
  else if (error is ConnectivityException) {
    showMessage(context, 'Vérifiez votre connexion internet', isError: true);
  }

  // Unauthorized
  else if (error is UnauthorizedException) {
    // Ignore error : handled by AppService.logout
  }

  // Server error
  else if (error is EpHttpResponseException) {
    showMessage(context, error.message, details: kReleaseMode ? null : error.details, isError: true);
  }

  // Displayable exception
  else if (error is DisplayableException) {
    showMessage(context, error.toString(), isError: true);
  }

  // Other
  else {
    showMessage(context, 'Une erreur est survenue', isError: true);
  }
}

/// Report error to Crashlytics
/*Future<void> reportError(Object exception, StackTrace stack, {dynamic reason}) async {
  if (shouldReportException(exception)) {
    // Report to Crashlytics
    await FirebaseCrashlytics.instance.recordError(exception, stack, reason: reason);
  } else {
    // Just log
    debugPrint('Unreported error thrown: $exception');
  }
}*/

/// Indicate whether this exception should be reported
bool shouldReportException(Object? exception) =>
    exception != null &&
        exception is! UnreportedException &&
        exception is! SocketException &&
        exception is! TimeoutException &&
        exception is! EpHttpResponseException;

/// Return true if string is null or empty
bool isStringNullOrEmpty(String? s) => s == null || s.isEmpty;

/// Return true if iterable is null or empty
bool isIterableNullOrEmpty<T>(Iterable<T>? iterable) => iterable == null || iterable.isEmpty;

/// Returns true if T1 and T2 are identical types.
/// This will be false if one type is a derived type of the other.
bool typesEqual<T1, T2>() => T1 == T2;

/// Returns true if T is not set, Null, void or dynamic.
bool isTypeUndefined<T>() => typesEqual<T, Object?>() || typesEqual<T, Null>() || typesEqual<T, void>() || typesEqual<T, dynamic>();

/// Parses the specified URL string and delegates handling of it to the underlying platform.
/// May be used to open a web page in native browser, or to start a call, for instance.
/*Future<void> openURL(BuildContext showErrorContext, String url) async {
  try {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } catch (e) {
    showError(showErrorContext, e);
  }
}*/

String toStringConverter(dynamic value) => value.toString();

bool toBoolConverter(dynamic value) {
  if (value is bool) return value;
  if (value is String) {
    if (value == 'true') return true;
    if (value == 'false') return false;
  }
  throw FormatException('"$value" is not a valid boolean value');
}

bool? toNullableBoolConverter(dynamic value) {
  if (value == null) return null;
  return toBoolConverter(value);
}

int? toNullableIntConverter(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}

double? toNullableDoubleConverter(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is String) return double.tryParse(value);
  return null;
}

class DateTimeConverter implements JsonConverter<DateTime, String> {
  const DateTimeConverter();

  @override
  DateTime fromJson(String value) => DateTime.parse(value).toLocal();

  @override
  String toJson(DateTime value) => value.toUtc().toIso8601String();
}

class NullableDateTimeConverter implements JsonConverter<DateTime?, String?> {
  const NullableDateTimeConverter();

  @override
  DateTime? fromJson(String? value) => DateTime.tryParse(value ?? '')?.toLocal();

  @override
  String? toJson(DateTime? value) => value?.toUtc().toIso8601String();
}

List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
        (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
