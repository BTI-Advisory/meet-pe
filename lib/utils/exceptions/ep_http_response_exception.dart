import 'package:http/http.dart' as http;
import 'package:meet_pe/utils/extensions.dart';
import '../utils.dart';
import 'displayable_exception.dart';

class EpHttpResponseException extends DisplayableException {
  EpHttpResponseException(this.response, {JsonObject? responseJson})
      : details = [
    '${response.statusCode} Error',
    response.request?.url,
  ].toLines(),
        super(responseJson?['message'] ?? 'Erreur serveur');

  /// Request response
  final http.Response response;

  /// Technical details
  final String? details;

  int get statusCode => response.statusCode;
}
