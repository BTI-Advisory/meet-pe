import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:meet_pe/utils/utils.dart';

extension ExtendedString on String {
  String plural(num count) => this + (count >= 2 ? 's' : '');

  /// Return the string with first character converted to capital (uppercase) letter
  String get capitalized {
    if (isEmpty) return '';
    if (length == 1) return toUpperCase();
    return this[0].toUpperCase() + substring(1);
  }

  /// Returns the substring of this string that extends from [startIndex], inclusive, with a length of [length].
  /// If [length] if negative, length will be relative to the total length
  String substringSafe({int? startIndex, int? length}) {
    if (startIndex == null && length == null) return '';

    startIndex ??= 0;

    if (length == null) {
      length = this.length;
    } else {
      length = length.clamp(0, this.length);
    }

    if (startIndex < 0) startIndex = 0;
    if (length < 0) length = this.length + length;

    if (startIndex >= length) return '';

    return substring(startIndex, length);
  }

  int get lines => isEmpty ? 0 : '\n'.allMatches(this).length + 1;
}

extension ExtendedIterable<T> on Iterable<T> {
  /// The first element satisfying test, or null if there are none.
  /// Copied from Flutter.collection package
  /// https://api.flutter.dev/flutter/package-collection_collection/IterableExtension/firstWhereOrNull.html
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  /// Returns the first element, or null if empty.
  T? get firstOrNull {
    if (isEmpty) return null;
    return first;
  }

  /// Get element at [index], and return null if not in range.
  T? elementAtOrNull(int? index) {
    if (index == null || index < 0 || index >= length) return null;
    return elementAt(index);
  }

  /// Returns a new lazy [Iterable] with all elements that are NOT null
  Iterable<T> whereNotNull() => where((element) => element != null);

  Iterable<E> mapIndexed<E>(E Function(int index, T item) f) sync* {
    var index = 0;
    for (final item in this) {
      yield f(index, item);
      index++;
    }
  }
}

extension ExtendedList<T> on List<T> {
  /// Insert [widget] between each member of this list.
  /// Does nothing if [item] is null.
  void insertBetween(T? item, {bool includeEnds = false}) {
    if (item == null) return;
    if (includeEnds) {
      if (isNotEmpty) {
        for (var i = length; i >= 0; i--) insert(i, item);
      }
    } else {
      if (length > 1) {
        for (var i = length - 1; i > 0; i--) insert(i, item);
      }
    }
  }

  /// Return true if this list's content is equals to [other]'s.
  bool isEqualTo(List<T>? other) {
    const comparator = ListEquality();
    return comparator.equals(this, other);
  }
}

extension ExtendedSet<T> on Set<T> {
  /// Return true if this set's content is equals to [other]'s.
  bool isEqualTo(Set<T>? other) {
    const comparator = SetEquality();
    return comparator.equals(this, other);
  }
}

extension ExtendedObjectIterable<T extends Object?> on Iterable<T> {
  /// Converts each element to a String and concatenates the strings, ignoring null and empty values.
  String joinNotEmpty(String separator) => map((e) => e?.toString())
      .where((string) => !isStringNullOrEmpty(string))
      .join(separator);

  /// Returns a string separated by a newline character for each non-null element
  String toLines() => joinNotEmpty('\n');

  /// Return true if there is strictly one non-null element
  bool singleNotNull() => where((e) => e != null).length == 1;
}

extension ExtendedBuildContext on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  bool get canPop => ModalRoute.of(this)?.canPop == true;

  /// Clear current context focus.
  /// This is the cleanest, official way.
  void clearFocus() => FocusScope.of(this).unfocus();

  /// Clear current context focus (Second method)
  /// Use this method if [clearFocus] doesn't work.
  void clearFocus2() => FocusScope.of(this).requestFocus(FocusNode());

  void popToRoot() => Navigator.of(this).popUntil((route) => route.isFirst);

  /// Validate the enclosing [Form]
  void validateForm({VoidCallback? onSuccess}) {
    clearFocus();
    final form = Form.of(this);
    if (form == null) return;

    if (form.validate()) {
      form.save();
      onSuccess?.call();
    }
  }
}

extension ExtendedDateTime on DateTime {
  /// Returns true if [other] is in the same year as [this].
  ///
  /// Does not account for timezones.
  bool isAtSameYearAs(DateTime other) => year == other.year;

  /// Returns true if [other] is in the same month as [this].
  ///
  /// This means the exact month, including year.
  ///
  /// Does not account for timezones.
  bool isAtSameMonthAs(DateTime other) =>
      isAtSameYearAs(other) && month == other.month;

  /// Returns true if [other] is on the same day as [this].
  ///
  /// This means the exact day, including year and month.
  ///
  /// Does not account for timezones.
  bool isAtSameDayAs(DateTime other) =>
      isAtSameMonthAs(other) && day == other.day;

  /// Return a new DateTime, with time part at 0.
  DateTime get date => DateTime(year, month, day);

  /// Adds a number of days to the date.
  DateTime addDays(int days) => DateTime(year, month, day + days);

  bool isBeforeOrSame(DateTime other) => this == other || isBefore(other);

  bool isAfterOrSame(DateTime other) => this == other || isAfter(other);
}

extension ExtendedColor on Color {
  Color get foregroundTextColor =>
      computeLuminance() > 0.5 ? Colors.black : Colors.white;
}
