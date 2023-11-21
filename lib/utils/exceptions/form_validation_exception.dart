import 'displayable_exception.dart';

class FormValidationException extends DisplayableException {
  const FormValidationException(String message) : super(message);

  @override
  String toString() => message;
}
