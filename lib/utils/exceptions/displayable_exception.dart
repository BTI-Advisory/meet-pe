import 'package:fetcher/src/exceptions/unreported_exception.dart';

/// An exception that may be directly displayed to the user
class DisplayableException with UnreportedException {
  final String message;

  const DisplayableException(this.message);

  @override
  String toString() => message;
}
