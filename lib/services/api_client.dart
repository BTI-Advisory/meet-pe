import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meet_pe/models/contact_data.dart';
import 'package:meet_pe/models/email_exist.dart';
import 'package:meet_pe/models/user_token_response.dart';
import 'package:meet_pe/services/app_service.dart';
import 'package:meet_pe/utils/_utils.dart';
import 'package:meet_pe/utils/exceptions/displayable_exception.dart';
import 'package:meet_pe/utils/exceptions/ep_http_response_exception.dart';
import 'package:meet_pe/utils/exceptions/unauthorized_exception.dart';
import 'package:fetcher/src/exceptions/connectivity_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/register_response.dart';

const _httpMethodGet = 'GET';
const _httpMethodPost = 'POST';
const _httpMethodPatch = 'PATCH';
const _httpMethodPut = 'PUT';
const _httpMethodDelete = 'DELETE';

class ApiClient {
  //#region Vars
  /// API url
  static const _authorityProd = '164.92.244.14';
  static const _authorityDev = '164.92.244.14';

  static String get _authority =>
      AppService.instance.developerMode ? _authorityDev : _authorityProd;

  static const _apiKeyProd = 'D5SnrgElCOndA8ruDJL21vdX1EQPZGxsSQ2k5fMosxrfWUZjzw92SuyKriazEgIS';
  static const _apiKeyDev = 'D5SnrgElCOndA8ruDJL21vdX1EQPZGxsSQ2k5fMosxrfWUZjzw92SuyKriazEgIS';

  static String get _apiKey =>
      AppService.instance.developerMode ? _apiKeyDev : _apiKeyProd;

  /// Request timeout duration
  static const _timeOutDuration = Duration(seconds: 40);

  /// Json mime type
  static const contentTypeJsonMimeType = 'application/json';
  static const contentTypeJson = '$contentTypeJsonMimeType; charset=utf-8';

  /// Whether to log headers also or not.
  static const _logHeaders = false;

  ApiClient();

  final _client = http.Client();

  //#endregion

  //#region Auth
  /// Long term token needed to get an accessToken.
  String? _refreshToken;

  set refreshToken(String? value) => _refreshToken = value;

  bool get hasRefreshToken => !isStringNullOrEmpty(_refreshToken);
  ValueChanged<String>? onRefreshTokenChanged;

  /// Very short life token needed to use authenticated API request.
  String? _accessToken;

  /// Log user in, and return user id
  Future<void> login(String email, String password) async {
    // Build request content
    final data = {
      'email': email,
      //TODO: the password must be decrypt to the backend
      //'password': base64.encode(utf8.encode(password)),
      'password': password,
      // Basic encoding to avoid clear texts in server's logs
    };

    // Send request
    final response = await () async {
      try {
        return await _send<JsonObject>(_httpMethodPost, 'api/login',
            bodyJson: data);
      } catch (e) {
        // Catch wrong user quality error
        if (e is EpHttpResponseException && e.statusCode == 400) {
          throw const DisplayableException(
              'Votre profil ne vous permet pas d’utiliser l’application MeetPe');
        }
        rethrow;
      }
    }();

    // Process tokens
    _processAuthTokens(response!);
  }

  /// A reference to the current _refreshAccessToken running task
  Future<void>? _refreshAccessTokenTask;

  /// Get a new accessToken
  /// The refreshToken is valid for only one usage
  Future<void> _refreshAccessToken() async {
    // If a task is already running, just wait and return
    if (_refreshAccessTokenTask != null) {
      debugPrint('API waiting for new refresh token');
      await _refreshAccessTokenTask;
      return;
    }

    // Create task
    _refreshAccessTokenTask = () async {
      // Build request content
      final data = {
        'refresh_token': _refreshToken,
      };

      // Send request
      final response = await _send<JsonObject>(
          _httpMethodPost, 'mobile/refreshToken',
          bodyJson: data, enableAutoRetryOnUnauthorized: false);

      // Process tokens
      _processAuthTokens(response!);
    }();

    // Await task
    try {
      await _refreshAccessTokenTask;
    } finally {
      _refreshAccessTokenTask = null;
    }
  }

  void _processAuthTokens(JsonObject tokensJson) {
    // Decode response
    //final tokens = AuthTokens.fromJson(tokensJson);
    final tokens = UserTokenResponse.fromJson(tokensJson);

    //Todo: Remove the comment when the refresh token is ready
    // -- Refresh token --
    // Save token in memory
    /*_refreshToken = tokens.refreshToken;

    // Notify
    onRefreshTokenChanged?.call(_refreshToken!);*/

    // -- Access token --
    // Save token in memory
    _accessToken = tokens.accessToken;

  }

  /// Mark a Check email exist
  Future<bool> askEmailExist(String email) async {
    bool isVerified = false;
    // Build request content
    final data = {
      'email': email,
    };

    // Send request
    final response = await () async {
      try {
        return await _send<JsonObject>(_httpMethodPost, 'api/verify-email',
            bodyJson: data);
      } catch (e) {
        // Catch wrong user quality error
        if (e is EpHttpResponseException && e.statusCode == 400) {
          throw const DisplayableException(
              'Votre profil ne vous permet pas d’utiliser l’application MeetPe');
        }
        rethrow;
      }
    }();

    if (EmailExist.fromJson(response!).exist == 'exists') {
      isVerified = true;
    } else {
      isVerified = false;
    }

    return isVerified;
  }

  /// Register user in, and return user token
  Future<void> register(String email, String password) async {
    // Build request content
    final data = {
      'email': email,
      //TODO: the password must be decrypt to the backend
      //'password': base64.encode(utf8.encode(password)),
      'password': password,
      // Basic encoding to avoid clear texts in server's logs
    };

    // Send request
    final response = await () async {
      try {
        return await _send<JsonObject>(_httpMethodPost, 'api/register',
            bodyJson: data);
      } catch (e) {
        // Catch wrong user quality error
        if (e is EpHttpResponseException && e.statusCode == 400) {
          throw const DisplayableException(
              'Votre profil ne vous permet pas d’utiliser l’application MeetPe');
        }
        rethrow;
      }
    }();

    // Process tokens
    _processRegisterTokens(response!);
  }

  void _processRegisterTokens(JsonObject tokensJson) {
    // Decode response
    //final tokens = AuthTokens.fromJson(tokensJson);
    final tokens = RegisterResponse.fromJson(tokensJson);

    //Todo: Remove the comment when the refresh token is ready
    // -- Refresh token --
    // Save token in memory
    /*_refreshToken = tokens.refreshToken;

    // Notify
    onRefreshTokenChanged?.call(_refreshToken!);*/

    // -- Access token --
    // Save token in memory
    _accessToken = tokens.accessToken;

  }

  /// Mark a message as read
  Future<void> askResetPassword(String email) async {
    // Build request content
    final data = {
      'email': email,
    };

    // Send request
    await _send<Null>(_httpMethodPut, 'mobile/resetPassword', bodyJson: data);
  }

  void clearTokens() {
    refreshToken = null;
    _accessToken = null;
  }

  //#endregion

  //#region Requests
  //#region User
  /// Update device data
  Future<void> setDeviceData({
    required String pushToken,
    required String deviceBrand,
    required String deviceModel,
    required String deviceOsVersion,
    String? appVersion,
  }) async {
    // Build request content
    final data = {
      'push_token': pushToken,
      'construteur': deviceBrand,
      'modele_smartphone': deviceModel,
      'os_smartphone': deviceOsVersion,
      if (appVersion != null) 'version_meet_pe': appVersion,
    };

    // Send request
    await _send<Null>(_httpMethodPut, 'mobile/userMeetPe', bodyJson: data);
  }

  /// Get user card data
  Future<ContactData> getUserCardData() async {
    // Send request
    final response =
        await _send<JsonObject>(_httpMethodGet, 'mobile/authDevice');

    // Return data
    return ContactData.fromJson(response!['ficheEC']!);
  }

  /// Get user avatar
  /// Returns bytes of a jpeg file
  Future<Uint8List?> getUserAvatar(String userQrCode) async {
    // Build request content
    final data = {
      'qrcode': userQrCode,
    };

    // Send request
    final response = await _send<Uint8List>(
        _httpMethodPost, 'mobile/getPhotoByQrcode',
        bodyJson: data);

    // Return data
    return response;
  }

  /// Authenticate user on an external device using a scanned qrcode
  Future<void> externalAuthValidation(String sessionId) async {
    // Build request content
    final data = {
      'sessionId': sessionId,
    };

    // Send request
    await _send<Null>(_httpMethodPost, 'authentification/authByQrcode',
        bodyJson: data);
  }

  //#endregion

  //#region Contact
  /// Check whether given qrcode is a valid user card.
  /// If it's valid, corresponding user is added to current user's contacts.
  /// Return corresponding user card data.
  Future<ContactData> checkUserCard(String userQrCode) async {
    // Build request content
    final data = {
      'qrcode': userQrCode,
    };

    // Send request
    final response = await _send<JsonObject>(
        _httpMethodPost, 'mobile/controleCarte',
        bodyJson: data);

    // Return data
    return ContactData.fromJson(response!['ficheEC']!);
  }

  /*
  /// Get user contacts, with optional filters.
  /// Paginated. Use [pageId] to specify a page.
  Future<PagedData<ContactData>> getUserContacts({String? nameFilter, Iterable<String>? gradeFilter, String? pageId}) => _fetchContacts(
    globalDirectory: false,
    nameFilter: nameFilter,
    gradeFilter: gradeFilter,
    pageId: pageId,
  );

  /// Search contacts in global directory, with optional filters.
  /// Paginated. Use [pageId] to specify a page.
  Future<PagedData<ContactData>> searchContacts({String? name, Iterable<String>? gradeFilter, String? pageId}) => _fetchContacts(
    globalDirectory: true,
    nameFilter: name,
    gradeFilter: gradeFilter,
    pageId: pageId,
  );

  /// Fetch contacts, with optional filters.
  /// If [globalDirectory] is true, will return contacts from global directory.
  /// If it's false, will return contacts from user directly.
  /// Paginated. Use [pageId] to specify a page.
  Future<PagedData<ContactData>> _fetchContacts({required bool globalDirectory, String? nameFilter, Iterable<String>? gradeFilter, String? pageId}) async {
    // Build request content
    final data = {
      if (nameFilter != null) 'nom': nameFilter,
      if (gradeFilter != null && gradeFilter.isNotEmpty) 'qualite': gradeFilter.join(','),
      if (pageId != null) 'pageId': pageId,
    };

    // Send request
    final response = await _send<JsonObject>(_httpMethodGet, globalDirectory ? 'mobile/searchContacts' : 'mobile/contacts', queryParameters: data);
    if (response == null) return const PagedData();

    // Return data
    return PagedData.fromJson(response, (json) => ContactData.fromJson((json as JsonObject)['ficheEC']));
  }

  /// Delete contact from user directory
  Future<void> deleteContact(String userQrCode) async {
    // Build request content
    final data = {
      'qrcode': userQrCode,
    };

    // Send request
    await _send<JsonObject>(_httpMethodPost, 'mobile/deleteContactByQrcode', bodyJson: data);
  }
  //#endregion

  //#region Message
  /// Get messages
  /// Paginated. Use [pageId] to specify a page.
  Future<PagedMessages> getMessages({String? pageId}) async {
    // Build request content
    final data = {
      if (pageId != null) 'pageId': pageId,
    };

    // Send request
    final response = await _send<JsonObject>(_httpMethodGet, 'mobile/messages', queryParameters: data);
    if (response == null) return const PagedMessages();

    // Return data
    return PagedMessages.fromJson(response);
  }

  /// Mark a message as read
  Future<void> markMessageAsRead(String messageId) async {
    // Build request content
    final data = {
      'lu': 'true',
    };

    // Send request
    await _send<JsonObject>(_httpMethodPut, 'mobile/message/$messageId', queryParameters: data);
  }

  /// Mark a message as read
  Future<void> deleteMessage(String messageId) => _send<JsonObject>(_httpMethodDelete, 'mobile/message/$messageId');
  //#endregion

  //#region Event
  /// Get events, with optional filters.
  /// No pagination: all events are returned.
  Future<List<EventData>> getEvents({ Iterable<String>? regionFilter }) async {
    // Build request content
    final data = {
      if (regionFilter != null) 'region': regionFilter.join(','),
    };

    // Send request
    final response = await _send<JsonObject>(_httpMethodGet, 'mobile/evenements', queryParameters: data);
    if (response == null) return const [];

    // Return data
    return response['data']!.map<EventData>((json) => EventData.fromJson(json)).toList(growable: false);
  }
  //#endregion

  //#region Others
  Future<List<PartnerData>> getPartners() async {
    // Send request
    final response = await _send<JsonObject>(_httpMethodGet, 'mobile/partenaires');
    if (response == null) return const [];

    // Return data
    return response['data']!.map<PartnerData>((json) => PartnerData.fromJson(json)).toList(growable: false);
  }
  //#endregion
  //#endregion
  */

  //#region Generics
  Uri _buildUri(String path, [JsonObject? queryParameters]) =>
      Uri.http(_authority, path, queryParameters);

  /// Send a classic request
  Future<T?> _send<T>(
    String method,
    String path, {
    Map<String, String>? headers,
    JsonObject? bodyJson,
    String? stringBody,
    JsonObject? queryParameters,
    bool enableAutoRetryOnUnauthorized = true,
  }) async {
    // Create request
    final request = http.Request(method, _buildUri(path, queryParameters));

    // Set headers
    request.headers.addAll({
      HttpHeaders.acceptHeader: contentTypeJson,
      if (bodyJson != null) HttpHeaders.contentTypeHeader: contentTypeJson,
      //'auth_token': _apiKey,
      'api-key': _apiKey,
      //TODO: when implementing analytics
      //'analyticsConsent': AnalyticsService.isEnabled.toString(),
    });
    if (headers != null) request.headers.addAll(headers);

    // Set body
    if (bodyJson != null)
      request.body = json.encode(bodyJson);
    else if (stringBody != null) request.body = stringBody;

    // Send request
    return await _sendHandledRequest<T>(request,
        enableAutoRetryOnUnauthorized: enableAutoRetryOnUnauthorized);
  }

  /// Run verifications, then send a generic request (with basic error handling)
  ///
  /// If [enableAutoRetryOnUnauthorized] is true, it will auto retry if accessToken is expired (after getting a new one)
  ///
  /// Use [onUnauthorizedRetryCallback] that rebuild the [request] from scratch
  /// when [request] instance cannot be used more than once (once finalized)
  /// (when [http.BaseRequest.copyAsNew] isn't available for this sub-type).
  /// It's the case for [http.MultipartRequest], that use [http.MultipartFile] that cannot be reuse once finalized.
  /// For classic [http.Request], it may be copied to a new object with same values with [http.BaseRequest.copyAsNew], so the retry is simpler.
  /// [onUnauthorizedRetryCallback] must call [_sendHandledRequest] with [enableAutoRetryOnUnauthorized] at false.
  Future<T?> _sendHandledRequest<T>(http.BaseRequest request,
      {bool enableAutoRetryOnUnauthorized = true,
      AsyncValueGetter<T>? onUnauthorizedRetryCallback}) async {
    // Set auth header (need to be here so that token is up-to-date when re-trying request)
    request.headers.addAll({
      'access_token': _accessToken ?? 'none',
      // TEMP server fix, remove 'none' when not needed (currently if access_token is missing it returns a 421) ?
    });

    // Send request
    try {
      return await _sendRequest<T>(request);
    } catch (e) {
      // Timeout
      if (e is TimeoutException) {
        throw const ConnectivityException(ConnectivityExceptionType.timeout);
      }

      // Unauthorized
      else if (e is EpHttpResponseException && e.statusCode == 401) {
        // If allowed, try get new accessToken and retry
        if (enableAutoRetryOnUnauthorized) {
          // Clear access token
          _accessToken = null;

          // If user is logged in
          if (hasRefreshToken) {
            // Refresh token
            try {
              await _refreshAccessToken();
            } catch (e) {
              // If any error occurs during refresh, consider as an UnauthorizedException
              throw const UnauthorizedException();
            }

            // Retry request
            if (onUnauthorizedRetryCallback != null) {
              return onUnauthorizedRetryCallback();
            } else {
              return await _sendHandledRequest<T>(
                request.copyAsNew(),
                enableAutoRetryOnUnauthorized: false,
              );
            }
          }
        }

        // If not allowed to retry, juts throw
        else {
          throw const UnauthorizedException();
        }
      }

      // In all other cases, just rethrow
      rethrow;
    }
  }

  /// Send a generic request
  Future<T?> _sendRequest<T>(http.BaseRequest request) async {
    // Log
    _log(request: request);

    // Check internet
    await throwIfNoInternet();

    // All in one Future to handle timeout
    final response = await (() async {
      //Send request
      final streamedResponse = await _client.send(request);

      //Wait for the full response
      return await http.Response.fromStream(streamedResponse);
    }())
        .timeout(_timeOutDuration);

    // Process response
    return _processResponse<T>(response);
  }

  static T? _processResponse<T>(http.Response response) {
    // Wrap response in a ResponseHandler to facilitate treatment
    final responseHandler = _ResponseHandler(response);

    // Logging
    _log(responseHandler: responseHandler);

    // Process response - Success
    if (responseHandler.isSuccess) {
      // If raw bytes is asked
      if (T == Uint8List) {
        if (response.bodyBytes.isEmpty) return null;
        return response.bodyBytes as T;
      }

      // If raw string is asked
      if (T == String) {
        return responseHandler.bodyString as T;
      }

      // Json
      else if (T == JsonObject || T == JsonList) {
        return responseHandler.bodyJsonOrNull<T>();
      }

      // If body doesn't need to be processed
      else if (isTypeUndefined<T>()) {
        return null as T;
      }

      // Unhandled types
      else {
        throw UnimplementedError('$T is not a supported type');
      }
    }

    // Process response - Error
    else {
      JsonObject? processedResponse;
      if (responseHandler.isBodyJson) {
        processedResponse = responseHandler.bodyJsonOrNull();
      }

      throw EpHttpResponseException(response, responseJson: processedResponse);
    }
  }

  /// Log a request or a response
  /// Only provide either one, not both
  static void _log(
      {http.BaseRequest? request, _ResponseHandler? responseHandler}) {
    if (kReleaseMode || request == null && responseHandler == null) return;
    const includeBody = true;

    // Common properties
    request = request ?? responseHandler!.response.request;
    final method = request?.method;
    final url = request?.url.toString();

    // Type specific
    String typeSymbol = '';
    String statusCode = '';
    String body = '';
    String? headers;

    // It's a response
    if (responseHandler != null) {
      final r = responseHandler.response;
      typeSymbol = '<';
      statusCode = r.statusCode != 200 ? '(${r.statusCode}) ' : '';
      if (includeBody) {
        if (responseHandler.isBodyJson) {
          body = responseHandler.bodyString;
        } else {
          final sizeInKo = ((r.contentLength ?? 0) / 1024).round();
          if (sizeInKo <= 1) {
            body = responseHandler.bodyString;
          } else {
            body = '$sizeInKo ko';
          }
        }
      }
      if (_logHeaders) {
        headers = r.headers.toString();
      }
    }

    // It's a request
    else if (request != null) {
      typeSymbol = '?';
      if (includeBody) {
        body = request is http.Request ? request.body : '';

        // Crop string if it's a GraphQL request body
        body = body.replaceAllMapped(
            RegExp(r'("query .+?\()(.+")(,.+?variables":)', dotAll: true),
            (match) => '${match.group(1)}...)${match.group(3)}');
      }
      if (_logHeaders) {
        headers = request.headers.toString();
      }
    }

    // Build log string
    debugPrint('API ($typeSymbol) $statusCode[$method $url] $body');
    if (headers != null) {
      debugPrint('API (${typeSymbol}H) $headers');
    }
  }

  static Future<void> throwIfNoInternet() async {
    if (!(await isConnectedToInternet())) {
      debugPrint('API (✕) NO INTERNET');
      throw const ConnectivityException(ConnectivityExceptionType.noInternet);
    }
  }

  static Future<bool> isConnectedToInternet() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  static bool isHttpSuccessCode(int httpStatusCode) =>
      httpStatusCode >= 200 && httpStatusCode < 300;
//#endregion
}

class _ResponseHandler {
  _ResponseHandler(this.response)
      : isSuccess = ApiClient.isHttpSuccessCode(response.statusCode),
        isBodyJson = ContentType.parse(
                    response.headers[HttpHeaders.contentTypeHeader] ?? '')
                .mimeType ==
            ApiClient.contentTypeJsonMimeType;

  final http.Response response;

  final bool isSuccess;
  final bool isBodyJson;

  String? _bodyString;

  String get bodyString => _bodyString ??= response.body;

  /// Decode body as JSON and cast as [T].
  /// May throw if unexpected format.
  T bodyJson<T>() {
    // Decode json
    final bodyJson = json.decode(bodyString);

    // cast
    return bodyJson as T;
  }

  /// Same as [bodyJson], but will return null if operation fails.
  T? bodyJsonOrNull<T>() {
    try {
      return bodyJson<T?>();
    } catch (e) {
      debugPrint(
          'ResponseHandler.Error : Could not decode json : $e : $bodyString');
    }
    return null;
  }
}

extension ExtendedBaseRequest on http.BaseRequest {
  /// Copy a request as a new one
  /// A request cannot be send more than once
  /// See https://stackoverflow.com/questions/51096991/dart-http-bad-state-cant-finalize-a-finalized-request-when-retrying-a-http
  http.BaseRequest copyAsNew() {
    final request = this;
    http.BaseRequest requestCopy;

    if (request is http.Request) {
      requestCopy = http.Request(request.method, request.url)
        ..encoding = request.encoding
        ..bodyBytes = request.bodyBytes;
    } else if (request is http.MultipartRequest) {
      throw Exception(
          'copying MultipartRequest requests is not supported because MultipartFile object cannot be reused once finalized nor copied once created');
    } else if (request is http.StreamedRequest) {
      throw Exception('copying streamed requests is not supported');
    } else {
      throw Exception('request type is unknown, cannot copy');
    }

    requestCopy
      ..persistentConnection = request.persistentConnection
      ..followRedirects = request.followRedirects
      ..maxRedirects = request.maxRedirects
      ..headers.addAll(request.headers);

    return requestCopy;
  }
}
