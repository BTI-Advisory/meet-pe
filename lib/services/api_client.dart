import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meet_pe/models/absence_list_response.dart';
import 'package:meet_pe/models/archived_reservation_response.dart';
import 'package:meet_pe/models/contact_data.dart';
import 'package:meet_pe/models/email_exist.dart';
import 'package:meet_pe/models/experience_data_response.dart';
import 'package:meet_pe/models/guide_reservation_response.dart';
import 'package:meet_pe/models/is_full_availability_response.dart';
import 'package:meet_pe/models/make_expr_p1_response.dart';
import 'package:meet_pe/models/notification_settings_response.dart';
import 'package:meet_pe/models/reservation_request_response.dart';
import 'package:meet_pe/models/step_list_response.dart';
import 'package:meet_pe/models/user_token_response.dart';
import 'package:meet_pe/services/app_service.dart';
import 'package:meet_pe/services/secure_storage_service.dart';
import 'package:meet_pe/services/storage_service.dart';
import 'package:meet_pe/utils/_utils.dart';
import 'package:meet_pe/utils/exceptions/displayable_exception.dart';
import 'package:meet_pe/utils/exceptions/ep_http_response_exception.dart';
import 'package:meet_pe/utils/exceptions/unauthorized_exception.dart';
import 'package:fetcher/src/exceptions/connectivity_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../models/availability_list_response.dart';
import '../models/code_validation_response.dart';
import '../models/experience_model.dart';
import '../models/favoris_data_response.dart';
import '../models/modify_experience_data_model.dart';
import '../models/register_response.dart';
import '../models/matching_api_request_builder.dart';
import '../models/reservation_list_response.dart';
import '../models/reservation_request.dart';
import '../models/update_forgot_password_response.dart';
import '../models/user_response.dart';
import '../models/user_social_response.dart';
import '../models/verify_code.dart';
import '../models/verify_code_forgot_password_response.dart';
import '../screens/authentification/loginPage.dart';

const _httpMethodGet = 'GET';
const _httpMethodPost = 'POST';
const _httpMethodPatch = 'PATCH';
const _httpMethodPut = 'PUT';
const _httpMethodDelete = 'DELETE';

class ApiClient {
  //#region Vars
  /// API url
  //static const _authorityProd = 'ec2-13-38-218-140.eu-west-3.compute.amazonaws.com';
  //static const _authorityDev = 'ec2-13-38-218-140.eu-west-3.compute.amazonaws.com';
  static const _authorityProd = 'dashboard.meetpe.fr';
  static const _authorityDev = 'dashboard.meetpe.fr';

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

  /// Very short life token needed to use authenticated API request for forgot password.
  String? _forgotPasswordToken;

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

  /// Log user in, and return user id
  Future<void> loginSocial(String name, String email, String token) async {
    // Build request content
    final data = {
      'name': name,
      'email': email,
      'token': token,
    };

    // Send request
    final response = await () async {
      try {
        return await _send<JsonObject>(_httpMethodPost, 'api/AuthSocialMedia',
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
    _processAuthTokensSocial(response!);
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
    SecureStorageService.saveAccessToken(_accessToken!);

    SecureStorageService.saveRole(tokens.roles.length.toString());
    SecureStorageService.saveIsVerified(tokens.user.isVerifiedAccount.toString());
  }

  void _processAuthTokensSocial(JsonObject tokensJson) {
    // Decode response
    final tokens = UserSocialResponse.fromJson(tokensJson);

    // -- Access token --
    // Save token in memory
    _accessToken = tokens.token;
    SecureStorageService.saveAccessToken(_accessToken!);

    SecureStorageService.saveRole(tokens.roles.length.toString());

    SecureStorageService.saveAction(tokens.action);

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
    SecureStorageService.saveAccessToken(_accessToken!);
    SecureStorageService.saveIsVerified(tokens.user.isVerifiedAccount.toString());

  }

  /// Get User Info
  Future<UserResponse> getUserInfo() async {

    // Send request
    final response = await () async {
      try {
        return await _send<JsonObject>(_httpMethodGet, 'api/user');
      } catch (e) {
        // Catch wrong user quality error
        if (e is EpHttpResponseException && e.statusCode == 400) {
          throw const DisplayableException(
              'Votre profil ne vous permet pas d’utiliser l’application MeetPe');
        }
        if (e is EpHttpResponseException && e.statusCode == 401) {
          AppService.instance.logOut();
          //throw const DisplayableException(
              //'Votre profil ne vous permet pas d’utiliser l’application MeetPe');
        }
        rethrow;
      }
    }();

    // Return data
    return UserResponse.fromJson(response!);
  }

  /// Mark a Check code
  Future<bool> verifyCode(String otpCode) async {
    bool isVerified = false;
    // Build request content
    final data = {
      'otp_code': otpCode,
    };

    // Send request
    final response = await () async {
      try {
        return await _send<JsonObject>(_httpMethodPost, 'api/verify-code',
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

    if (VerifyCode.fromJson(response!).verified == 'Verified') {
      isVerified = true;
    } else {
      isVerified = false;
    }

    return isVerified;
  }

  /// Mark a resend code
  Future<bool> resendCode(String email) async {
    bool isVerified = false;
    final data = {
      'email': email,
    };

    // Send request
    final response = await () async {
      try {
        return await _send<JsonObject>(_httpMethodPost, 'api/resend-code-auth', bodyJson: data);
      } catch (e) {
        // Catch wrong user quality error
        if (e is EpHttpResponseException && e.statusCode == 400) {
          throw const DisplayableException(
              'Votre profil ne vous permet pas d’utiliser l’application MeetPe');
        }
        rethrow;
      }
    }();

    if (VerifyCode.fromJson(response!).verified == 'code has been sended successfully') {
      isVerified = true;
    } else {
      isVerified = false;
    }

    return isVerified;
  }

  /// Mark a Set role
  Future<bool> setRole(String role) async {
    bool isSet = false;
    // Build request content
    final data = {
      'as': role,
    };

    // Send request
    final response = await () async {
      try {
        return await _send<JsonObject>(_httpMethodPost, 'api/set-role',
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

    if (VerifyCode.fromJson(response!).verified == 'roles has been setted successfully') {
      isSet = true;
    } else {
      isSet = false;
    }

    return isSet;
  }

  /// Mark a send code validation
  Future<CodeValidationResponse> sendCodeValidation(String email) async {
    // Build request content
    final data = {
      'email': email,
    };

    // Send request
    final response = await () async {
      try {
        return await _send<JsonObject>(_httpMethodPost, 'api/send-code-validation',
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

    _forgotPasswordToken = CodeValidationResponse.fromJson(response!).token;
    SecureStorageService.saveForgotPasswordToken(_forgotPasswordToken!);
    return CodeValidationResponse.fromJson(response!);
  }

  /// Get ForgotPassword Token
  Future<bool> getForgotPasswordValidateCode(String otpCode) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'api-key': '$_apiKey', // Include your authorization header
      'Authorization': 'Bearer ${await SecureStorageService.readForgotPasswordToken()}' ?? 'none',
    };

    // Build request content
    final Map<String, dynamic> data = {
      'otp_code': otpCode,
    };

    final response = await http.post(_buildUri('api/validate-code-validation'), headers: headers, body: json.encode(data));

    if (response.statusCode == 200) {
      if(VerifyCodeForgotPasswordResponse.fromJson(json.decode(response.body)).msg == 'Verified') {
        return true;
      } else {
        return false;
      }
    } else {
      throw Exception('Failed to get code verification');
    }
  }

  /// Mark a resend code
  Future<bool> resendCodeForgotPassword(String email) async {
    final Map<String, String> headers = {};
    headers.addAll({
      HttpHeaders.acceptHeader: contentTypeJson,
      'api-key': _apiKey,
      'Authorization': 'Bearer ${await SecureStorageService.readForgotPasswordToken()}' ?? 'none',
    });

    final data = {
      'email': email,
    };

    // Send request
    final response = await () async {
      try {
        return await _send<JsonObject>(_httpMethodPost, 'api/resend-code-auth', bodyJson: data);
      } catch (e) {
        // Catch wrong user quality error
        if (e is EpHttpResponseException && e.statusCode == 400) {
          throw const DisplayableException(
              'Votre profil ne vous permet pas d’utiliser l’application MeetPe');
        }
        rethrow;
      }
    }();

    if (VerifyCode.fromJson(response!).verified == 'code has been sended successfully') {
      return true;
    } else {
      return false;
    }
  }

  /// Update ForgotPassword
  Future<void> updateForgotPassword(String password, String newPassword) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'api-key': '$_apiKey', // Include your authorization header
      'Authorization': 'Bearer ${await SecureStorageService.readForgotPasswordToken()}' ?? 'none',
    };

    // Build request content
    final Map<String, dynamic> data = {
      'current_password': password,
      'new_password': newPassword,
    };

    final response = await http.post(_buildUri('api/change-password'), headers: headers, body: json.encode(data));

    if (response.statusCode == 200) {
      final dynamic jsonResponse = json.decode(response.body);
      return jsonResponse.map((json) => UpdateForgotPasswordResponse.fromJson(json));
    } else {
      throw Exception('Failed to update password');
    }
  }

  /// Get list of item in every step
  Future<List<StepListResponse>> fetchChoices(String url) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'api-key': '$_apiKey', // Include your authorization header
      'Authorization': 'Bearer ${await SecureStorageService.readAccessToken()}' ?? 'none',
    };

    //Todo: replace with _send function
    final response = await http.get(_buildUri('api/getTableData/$url'), headers: headers);


    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((json) => StepListResponse.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load choices');
    }
  }

  /// Mark a Send list of choice Guide
  Future<bool> setTravelersProfile(String name, String phone, String? imageFilePath) async {
    bool isVerified = false;
    final Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'api-key': '$_apiKey',
      'Authorization': 'Bearer ${await SecureStorageService.readAccessToken()}' ?? 'none',
    };

    // Create a multi-part request
    final request = http.MultipartRequest('POST', _buildUri('api/set-voyageur-Profil'));

    // Add headers if provided
    if (headers != null) {
      request.headers.addAll(headers);
    }

    // Add JSON data
    request.fields['name'] = name;
    request.fields['phone_number'] = phone;

    // Check if the imageFilePath is provided and not empty
    if (imageFilePath != null && imageFilePath.isNotEmpty) {
      // Create a File object from the provided file path
      final imageFile = File(imageFilePath);

      if (imageFile.existsSync()) {
        request.files.add(http.MultipartFile.fromBytes('picture', File(imageFile!.path).readAsBytesSync(), filename: imageFile.path.split('/').last,)
        );
      } else {
        print("Image file not found at the given path.");
      }
    }

    // Send the request
    final streamedResponse = await request.send();

    // Get response
    final response = await http.Response.fromStream(streamedResponse);

    // Handle response
    if (response.statusCode == 200) {
      // Parse JSON response
      isVerified = true;
      return isVerified;
    } else {
      isVerified = false;
      return isVerified;
    }
  }

  /// Mark a Send list of choice voyageur
  Future<bool> sendListVoyageur(Map<String, dynamic> listChoice) async {
    bool isVerified = false;

    // Send request
    final response = await () async {
      try {
        return await _send<JsonObject>(_httpMethodPost, 'api/make-profile-voyageur',
            bodyJson: listChoice);
      } catch (e) {
        // Catch wrong user quality error
        if (e is EpHttpResponseException && e.statusCode == 400) {
          throw const DisplayableException(
              'Votre profil ne vous permet pas d’utiliser l’application MeetPe');
        }
        rethrow;
      }
    }();

    if (VerifyCode.fromJson(response!).verified == "Voyageur et ces choix sont sauvegard\u00e9s avec succ\u00e8s") {
      isVerified = true;
    } else {
      isVerified = false;
    }

    return isVerified;
  }

  /// Mark a Send list of choice Guide
  Future<bool> sendListGuide(Map<String, dynamic> listChoice, String? imageFilePath) async {
    bool isVerified = false;
    final Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'api-key': '$_apiKey',
      'Authorization': 'Bearer ${await SecureStorageService.readAccessToken()}' ?? 'none',
    };

    // Create a multi-part request
    final request = http.MultipartRequest('POST', _buildUri('api/make-profile-guide'));

    // Add headers if provided
    if (headers != null) {
      request.headers.addAll(headers);
    }

    // Add JSON data
    Map<String, String> outputData = transformDataGuide(listChoice);
    request.fields.addAll(outputData);

    // Check if the imageFilePath is provided and not empty
    if (imageFilePath != null && imageFilePath.isNotEmpty) {
      // Create a File object from the provided file path
      final imageFile = File(imageFilePath);

      if (imageFile.existsSync()) {
        request.files.add(
            http.MultipartFile.fromBytes(
              'image',
              imageFile.readAsBytesSync(),
              filename: imageFile.path.split('/').last,
            )
        );
      } else {
        print("Image file not found at the given path.");
      }
    }

    // Send the request
    final streamedResponse = await request.send();

    // Get response
    final response = await http.Response.fromStream(streamedResponse);

    // Handle response
    if (response.statusCode == 201) {
      // Parse JSON response
      isVerified = true;
      return isVerified;
    } else {
      isVerified = false;
      return isVerified;
      //throw Exception('Failed to send List Guide guide: ${response.reasonPhrase}');
    }
  }

  /// Mark a set favorite experience
  Future<void> setFavoriteExperience(int experienceId, String action, BuildContext context) async {
    final data = {
      'experience_id': experienceId,
      "action": action
    };

    // Send request
    final response = await () async {
      try {
        return await _send<JsonObject>(_httpMethodPost, 'api/set-favorite-experience', bodyJson: data);
      } catch (e) {
        // Catch wrong user quality error
        if (e is EpHttpResponseException && e.statusCode == 400) {
          throw const DisplayableException(
              'Votre profil ne vous permet pas d’utiliser l’application MeetPe');
        }
        if (e is EpHttpResponseException && e.statusCode == 409) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("L'expérience est déjà dans les favoris"),
              duration: Duration(seconds: 2),
            ),
          );
          //return;
        }
        rethrow;
      }
    }();
  }

  /// Mark a get list favorite experience
  /*Future<List<FavorisDataResponse>> getFavoriteExperience() async {
    // Send request
    final response = await () async {
      try {
        return await _send<List<dynamic>>(_httpMethodGet, 'api/get-favorite-experience-list');
      } catch (e) {
        // Catch wrong user quality error
        if (e is EpHttpResponseException && e.statusCode == 400) {
          throw const DisplayableException(
              'Votre profil ne vous permet pas d’utiliser l’application MeetPe');
        }
        rethrow;
      }
    }();
    return response!.map((json) => FavorisDataResponse.fromJson(json as Map<String, dynamic>)).toList();
  }*/
  Future<List<FavorisDataResponse>> getFavoriteExperience() async {
    final Map<String, String> headers = {
      'Accept': 'application/json',
      'api-key': '$_apiKey',
      'Authorization': 'Bearer ${await SecureStorageService.readAccessToken()}' ?? 'none',
    };

    final response = await http.get(_buildUri('api/get-favorite-experience-list'), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => FavorisDataResponse.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load experiences');
    }
  }

  /// Mark a get matching list
  Future<List<ExperienceModel>> fetchExperiences(FiltersRequest filters) async {
    final Map<String, String> headers = {
      'Accept': 'application/json',
      'api-key': '$_apiKey',
      'Authorization': 'Bearer ${await SecureStorageService.readAccessToken()}' ?? 'none',
    };

    final response = await http.post(_buildUri('api/Matching'), headers: headers, body: filters.toJson());

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => ExperienceModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load experiences');
    }
  }

  /// Send reservation for experience.
  Future<ReservationRequestResponse> makeReservation(ReservationRequest reservationRequest) async {
    // Send request
    final response = await _send<JsonObject>(_httpMethodPost, 'api/make-reservation', bodyJson: reservationRequest.toJson());

    // Return data
    return ReservationRequestResponse.fromJson(response!);
  }

  /// Get reservation list.
  Future<List<ReservationListResponse>> getReservation() async {
    final Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'api-key': '$_apiKey',
      'Authorization': 'Bearer ${await SecureStorageService.readAccessToken()}' ?? 'none',
    };

    final response = await http.get(_buildUri('api/get-voyageur-reservation'), headers: headers);

    if (response.statusCode == 200) {
      return parseReservationList(response.body);
    } else {
      throw Exception('Failed to load reservation list');
    }
  }

  /// Mark a Create experience Guide
  Future<MakeExprP1Response> createExperienceGuide(Map<String, dynamic> listChoice) async {
    final Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'api-key': '$_apiKey',
      'Authorization': 'Bearer ${await SecureStorageService.readAccessToken()}' ?? 'none',
    };

    // Create a multi-part request
    final request = http.MultipartRequest('POST', _buildUri('api/make-experience-global'));

    // Add headers if provided
    if (headers != null) {
      request.headers.addAll(headers);
    }

    // Add JSON data
    Map<String, String> outputData = transformDataExperience(listChoice);
    request.fields.addAll(outputData);

    // Add image file if provided
    if (listChoice['image_principale'] != null) {
      // Create a File object from the provided file path
      final imageFile = File(listChoice['image_principale']);

      request.files.add(http.MultipartFile.fromBytes('image_principale', File(imageFile!.path).readAsBytesSync(),filename: imageFile!.path));
    }

    // Add image files
    List<String> imagePaths = List<String>.from(listChoice['images']);
    for (int i = 0; i < imagePaths.length; i++) {
      final imageFile = File(imagePaths[i]);
      request.files.add(http.MultipartFile.fromBytes('image_$i', await imageFile.readAsBytes(), filename: imageFile.path));
    }

    // Send the request
    final streamedResponse = await request.send();

    // Get response
    final response = await http.Response.fromStream(streamedResponse);
    print('Final ${response.statusCode}');
    print('Final ${response.body}');

    // Handle response
    if (response.statusCode == 200) {
      // Parse JSON response
      return MakeExprP1Response.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create experience guide: ${response.reasonPhrase}');
    }
  }

  /// Mark a convert a list in guide profile
  Map<String, String> transformDataExperience(Map<String, dynamic> initialData) {
    List<int> categories = List<int>.from(initialData['categorie']);
    String categoriesString = categories.join(', ');
    List<int> languages = List<int>.from(initialData['experience_languages']);
    String languagesString = languages.join(', ');
    List<int> avecCa = List<int>.from(initialData['et_avec_ça']);
    String avecCaString = avecCa.join(', ');

    List<int> dernierMinuteReservation = List<int>.from(initialData['dernier_minute_reservation']);
    String dernierMinuteReservationString = dernierMinuteReservation.join(', ');

    String? guidePersonnesPeuvesParticiperString = _convertListToString(initialData['guide_personnes_peuves_participer']);

    String? horairesJson = initialData['horaires'] != null
        ? jsonEncode(initialData['horaires'])
        : null;

    return {
      'categorie': categoriesString,
      'nom': initialData['nom'].replaceAll(' ', ' '),
      'description': initialData['description'].replaceAll(' ', ' '),
      'experience_languages': languagesString,
      'duree': initialData['duree'].toString(),
      'et_avec_ça': avecCaString,
      'guide_personnes_peuves_participer': guidePersonnesPeuvesParticiperString ?? '',
      'prix_par_voyageur': initialData['prix_par_voyageur'].toString(),
      'nombre_des_voyageur': initialData['nombre_des_voyageur'].toString(),
      'ville': initialData['ville'].toString(),
      'addresse': initialData['addresse'].toString(),
      'code_postale': initialData['code_postale'].toString(),
      'country': initialData['country'].toString(),
      'support_group_prive': initialData['support_group_prive'].toString(),
      'discount_kids_between_2_and_12': initialData['discount_kids_between_2_and_12'].toString(),
      'price_group_prive': initialData['price_group_prive'].toString(),
      'max_group_size': initialData['max_group_size'].toString(),
      'dernier_minute_reservation': dernierMinuteReservationString,
      if (horairesJson != null) 'horaires': horairesJson,
    };
  }

  /// Mark a convert a list in guide profile
  Map<String, String> transformDataGuide(Map<String, dynamic> initialData) {
    List<int> categories = List<int>.from(initialData['guide_truc_de_toi_fr']);
    String categoriesString = categories.join(', ');

    List<int> personalite = List<int>.from(initialData['personalite_fr']);
    String personaliteString = personalite.join(', ');

    return {
      'guide_truc_de_toi_fr': categoriesString,
      'a_propos_de_toi_fr': initialData['a_propos_de_toi_fr'].toString(),
      'personalite_fr': personaliteString,
      'phone_number': initialData['phone_number'].toString(),
      'name': initialData['name'].toString(),
      'siren_number': initialData['siren_number'].toString(),
      'name_of_company': initialData['name_of_company'].toString(),
    };
  }

  String? _convertListToString(dynamic data) {
    if (data is List<int> && data.isNotEmpty) {
      return data.join(', ');
    }
    return null;
  }

  /// Mark a set notification settings
  Future<NotificationSettingsResponse> sendNotificationSettings(Map<String, bool> listNotification) async {

    // Send request
    final response = await () async {
      try {
        return await _send<JsonObject>(_httpMethodPost, 'api/set-notification-settings',
            bodyJson: listNotification);
      } catch (e) {
        // Catch wrong user quality error
        if (e is EpHttpResponseException && e.statusCode == 400) {
          throw const DisplayableException(
              'Votre profil ne vous permet pas d’utiliser l’application MeetPe');
        }
        rethrow;
      }
    }();

    return NotificationSettingsResponse.fromJson(response!);
  }

  /// Get notification settings
  Future<NotificationSettingsResponse> getNotificationSettings() async {
    // Send request
    final response =
    await _send<JsonObject>(_httpMethodGet, 'api/get-user-notification-settings');

    // Return data
    return NotificationSettingsResponse.fromJson(response!);
  }

  /// Get is full available
  Future<IsFullAvailabilityResponse> getFullAvailable() async {
    // Send request
    final response =
    await _send<JsonObject>(_httpMethodGet, 'api/get-is-full-availability');

    // Return data
    return IsFullAvailabilityResponse.fromJson(response!);
  }

  /// Post is full available
  Future<void> sendFullAvailable(bool fullAvailable) async {
    final data = {
      'is_full_available': fullAvailable
    };

    // Send request
    final response = await () async {
      try {
        return await _send<JsonObject>(_httpMethodPost, 'api/set-is-full-availability',
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

    // Return data
    IsFullAvailabilityResponse.fromJson(response!);
  }

  /// Update Name
  Future<bool> updateName(String firstName, String lastName) async {
    final data = {
      'nom': lastName,
      'prenom': firstName
    };

    // Send request
    final response = await () async {
      try {
        return await _send<JsonObject>(_httpMethodPost, 'api/update-user-name',
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
    if (VerifyCode.fromJson(response!).verified == 'user information has been updated') {
      return true;
    } else {
      return false;
    }
  }

  /// Update phone number
  Future<bool> updatePhone(String phoneNumber) async {
    final data = {
      'phone_number': phoneNumber
    };

    // Send request
    final response = await () async {
      try {
        return await _send<JsonObject>(_httpMethodPost, 'api/update-phone-number',
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
    if (VerifyCode.fromJson(response!).verified == 'user information has been updated') {
      return true;
    } else {
      return false;
    }
  }

  /// Update password
  Future<bool> updatePassword(String oldPassword, String newPassword) async {
    final data = {
      'current_password': oldPassword,
      'new_password': newPassword
    };

    // Send request
    final response = await () async {
      try {
        return await _send<JsonObject>(_httpMethodPost, 'api/update-password',
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
    if (VerifyCode.fromJson(response!).verified == 'user information has been updated') {
      return true;
    } else {
      return false;
    }
  }

  /// Update bank info
  Future<bool> updateBankInfo(String iban, String bic, String name) async {
    final data = {
      'IBAN': iban,
      'BIC': bic,
      'nom_du_titulaire': name
    };

    // Send request
    final response = await () async {
      try {
        return await _send<JsonObject>(_httpMethodPost, 'api/update-bank-info',
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
    if (VerifyCode.fromJson(response!).verified == 'user information has been updated') {
      return true;
    } else {
      return false;
    }
  }

  /// Update address info
  Future<bool> updateAddressInfo(String rue, String ville, String zip) async {
    final data = {
      'rue': rue,
      'ville': ville,
      'code_postal': zip
    };

    // Send request
    final response = await () async {
      try {
        return await _send<JsonObject>(_httpMethodPost, 'api/update-addresse-info',
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
    if (VerifyCode.fromJson(response!).verified == 'user information has been updated') {
      return true;
    } else {
      return false;
    }
  }

  /// Mark a Upload ID Card
  Future<bool> sendIdCard(String cardIDRecto, String cardIDVerso) async {
    bool isVerified = false;
    final Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'api-key': '$_apiKey',
      'Authorization': 'Bearer ${await SecureStorageService.readAccessToken()}' ?? 'none',
    };

    // Create a multi-part request
    final request = http.MultipartRequest('POST', _buildUri('api/update-piece-identite'));

    // Add headers if provided
    if (headers != null) {
      request.headers.addAll(headers);
    }

    // Create File objects from the provided file paths
    final imageFileRecto = File(cardIDRecto);
    final imageFileVerso = File(cardIDVerso);

    // Ensure the files exist
    if (!imageFileRecto.existsSync()) {
      throw Exception('The recto file does not exist at the provided path');
    }
    if (!imageFileVerso.existsSync()) {
      throw Exception('The verso file does not exist at the provided path');
    }

    // Add image files to the request
    request.files.add(http.MultipartFile.fromBytes('piece_identite', File(imageFileRecto!.path).readAsBytesSync(),filename: imageFileRecto!.path));
    request.files.add(http.MultipartFile.fromBytes('piece_d_identite_verso', File(imageFileVerso!.path).readAsBytesSync(),filename: imageFileVerso!.path));

    // Send the request
    final streamedResponse = await request.send();

    // Get response
    final response = await http.Response.fromStream(streamedResponse);

    // Handle response
    if (response.statusCode == 200) {
      // Parse JSON response
      isVerified = true;
    } else {
      throw Exception('Failed to send identity card: ${response.reasonPhrase}');
    }
    return isVerified;
  }

  /// Mark a Upload KBIS
  Future<bool> sendKbisFile(String filePath) async {
    bool isVerified = false;
    final Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'api-key': '$_apiKey',
      'Authorization': 'Bearer ${await SecureStorageService.readAccessToken()}' ?? 'none',
    };

    // Create a multi-part request
    final request = http.MultipartRequest('POST', _buildUri('api/update-KBIS-file'));

    // Add headers if provided
    if (headers != null) {
      request.headers.addAll(headers);
    }

    // Add image file if provided
    if (filePath != null) {
      // Create a File object from the provided file path
      final imageFile = File(filePath);

      request.files.add(http.MultipartFile.fromBytes('KBIS_file', File(imageFile!.path).readAsBytesSync(),filename: imageFile!.path));
    }

    // Send the request
    final streamedResponse = await request.send();

    // Get response
    final response = await http.Response.fromStream(streamedResponse);

    // Handle response
    if (response.statusCode == 200) {
      // Parse JSON response
      isVerified = true;
      return isVerified;
    } else {
      throw Exception('Failed to send KBIS file: ${response.reasonPhrase}');
    }
  }

  /// Mark a Upload other file
  Future<bool> sendOtherDocument(String fileTitle, String filePath) async {
    bool isVerified = false;
    final Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'api-key': '$_apiKey',
      'Authorization': 'Bearer ${await SecureStorageService.readAccessToken()}' ?? 'none',
    };

    // Create a multi-part request
    final request = http.MultipartRequest('POST', _buildUri('api/add-other-document'));

    // Add headers if provided
    if (headers != null) {
      request.headers.addAll(headers);
    }

    // Add file title if provided
    if (fileTitle != null) {
      request.fields['document_title'] = fileTitle;
    }

    // Add image file if provided
    if (filePath != null) {
      // Create a File object from the provided file path
      final imageFile = File(filePath);

      request.files.add(http.MultipartFile.fromBytes('other_doc', File(imageFile!.path).readAsBytesSync(),filename: imageFile!.path));
    }

    // Send the request
    final streamedResponse = await request.send();

    // Get response
    final response = await http.Response.fromStream(streamedResponse);

    // Handle response
    if (response.statusCode == 200) {
      // Parse JSON response
      isVerified = true;
      return isVerified;
    } else {
      throw Exception('Failed to send other document: ${response.reasonPhrase}');
    }
  }

  /// Mark send feed back
  Future<void> sendFeedBack(String motif, String desc) async {
    final data = {
      'motif': motif,
      'desc': desc
    };

    // Send request
    final response = await () async {
      try {
        return await _send<JsonObject>(_httpMethodPost, 'api/create-contact-api',
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

    // Return data
    IsFullAvailabilityResponse.fromJson(response!);
  }

  /// Mark a convert a list
  Map<String, String> transformDataDocument(Map<String, dynamic> initialData) {

    return {
      'document_title': initialData['document_title'].toString()
    };
  }

  /// Mark a update photo
  Future<bool> updatePhoto(String filePath) async {
    bool isVerified = false;
    final Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'api-key': '$_apiKey',
      'Authorization': 'Bearer ${await SecureStorageService.readAccessToken()}' ?? 'none',
    };

    // Create a multi-part request
    final request = http.MultipartRequest('POST', _buildUri('api/update-profile-photo'));

    // Add headers if provided
    if (headers != null) {
      request.headers.addAll(headers);
    }

    // Add image file if provided
    if (filePath != null) {
      // Create a File object from the provided file path
      final imageFile = File(filePath);

      request.files.add(http.MultipartFile.fromBytes('profile_path', File(imageFile!.path).readAsBytesSync(),filename: imageFile!.path));
    }

    // Send the request
    final streamedResponse = await request.send();

    // Get response
    final response = await http.Response.fromStream(streamedResponse);

    // Handle response
    if (response.statusCode == 200) {
      // Parse JSON response
      isVerified = true;
      return isVerified;
    } else {
      throw Exception('Failed to update photo file: ${response.reasonPhrase}');
    }
  }

  /// Get list absence
  Future<List<AbsenceListResponse>> getAbsenceList() async {
    final Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'api-key': '$_apiKey',
      'Authorization': 'Bearer ${await SecureStorageService.readAccessToken()}' ?? 'none',
    };

    final response = await http.get(_buildUri('api/get-schedule-absence'), headers: headers);

    if (response.statusCode == 200) {
      return parseScheduleEntries(response.body);
    } else {
      throw Exception('Failed to load absence list');
    }
  }

  /// Get list availability
  Future<List<AvailabilityListResponse>> getAvailabilityList() async {
    final Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'api-key': '$_apiKey',
      'Authorization': 'Bearer ${await SecureStorageService.readAccessToken()}' ?? 'none',
    };

    final response = await http.get(_buildUri('api/get-schedule-availability'), headers: headers);

    if (response.statusCode == 200) {
      return parseAvailabilityItem(response.body);
    } else {
      throw Exception('Failed to load availability list');
    }
  }

  /// Mark a set schedule absence
  Future<bool> sendScheduleAbsence(Map<String, dynamic> absenceData) async {
    bool isCreated = false;

    // Send request
    final response = await () async {
      try {
        return await _send<JsonObject>(_httpMethodPost, 'api/set-schedule-absence',
            bodyJson: absenceData);
      } catch (e) {
        // Catch wrong user quality error
        if (e is EpHttpResponseException && e.statusCode == 400) {
          throw const DisplayableException(
              'Votre profil ne vous permet pas d’utiliser l’application MeetPe');
        }
        rethrow;
      }
    }();

    if (VerifyCode.fromJson(response!).verified == 'absence has been saved successfully') {
      isCreated = true;
    } else {
      isCreated = false;
    }

    return isCreated;
  }

  /// Mark a set update schedule absence
  Future<bool> updateScheduleAbsence(Map<String, dynamic> absenceData) async {
    bool isCreated = false;

    // Send request
    final response = await () async {
      try {
        return await _send<JsonObject>(_httpMethodPost, 'api/update-schedule-absence',
            bodyJson: absenceData);
      } catch (e) {
        // Catch wrong user quality error
        if (e is EpHttpResponseException && e.statusCode == 400) {
          throw const DisplayableException(
              'Votre profil ne vous permet pas d’utiliser l’application MeetPe');
        }
        rethrow;
      }
    }();

    if (VerifyCode.fromJson(response!).verified == 'absence has been updated successfully') {
      isCreated = true;
    } else {
      isCreated = false;
    }

    return isCreated;
  }

  /// Mark a set update schedule absence
  Future<bool> deleteScheduleAbsence(int id) async {
    bool isCreated = false;

    // Build request content
    final data = {
      'id': id,
    };

    // Send request
    final response = await () async {
      try {
        return await _send<JsonObject>(_httpMethodPost, 'api/delete-schedule-absence',
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

    if (VerifyCode.fromJson(response!).verified == 'absence has been deleted successfully') {
      isCreated = true;
    } else {
      isCreated = false;
    }

    return isCreated;
  }

  /// Mark a get archived reservation
  Future<List<ArchivedReservationResponse>> getArchivedReservation() async {
    final Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'api-key': '$_apiKey',
      'Authorization': 'Bearer ${await SecureStorageService.readAccessToken()}' ?? 'none',
    };

    final response = await http.get(_buildUri('api/get-archived-reservation'), headers: headers);

    if (response.statusCode == 200) {
      return parseArchivedReservation(response.body);
    } else {
      throw Exception('Failed to load reservation list');
    }
  }

  /// Update reservation status
  Future<bool> updateReservationStatus(int reservationId, String status) async {
    final data = {
      'reservation_id': reservationId,
      'status': status,
    };

    // Send request
    final response = await () async {
      try {
        return await _send<JsonObject>(_httpMethodPost, 'api/update-reservation-status',
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

    // Return data
    VerifyCode.fromJson(response!);
    if (VerifyCode.fromJson(response!).verified == 'operation done') {
      return true;
    } else {
      return false;
    }
  }

  /// Get list guide reservation
  Future<List<GuideReservationResponse>> getGuideReservationList() async {
    final Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'api-key': '$_apiKey',
      'Authorization': 'Bearer ${await SecureStorageService.readAccessToken()}' ?? 'none',
    };

    final response = await http.get(_buildUri('api/get-guide-reservation'), headers: headers);

    if (response.statusCode == 200) {
      return parseGuideReservationItem(response.body);
    } else {
      throw Exception('Failed to load reservation list');
    }
  }

  ///Todo replace
  /*Future<List<GuideReservationResponse>> getGuideReservationList() async {
    // Send request
    final response = await _send<JsonObject>(_httpMethodGet, 'api/get-guide-reservation');
    if (response == null) return const [];

    // Return data
    return response['data']!.map<GuideReservationResponse>((json) => GuideReservationResponse.fromJson(json)).toList(growable: false);
  }*/

  Future<List<ExperienceDataResponse>> getGuideExperiencesList() async {
    final Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'api-key': '$_apiKey',
      'Authorization': 'Bearer ${await SecureStorageService.readAccessToken() ?? 'none'}',
    };

    // Make the GET request
    final response = await http.get(_buildUri('api/get-guide-experiences'), headers: headers);

    // Check response status code
    if (response.statusCode == 200) {
      // Decode the response body to a Map
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // Extract the 'data' field and parse it into a list of ExperienceDataResponse
      if (jsonResponse.containsKey('data') && jsonResponse['data'] is List) {
        final List<dynamic> dataList = jsonResponse['data'];
        return dataList
            .map((item) => ExperienceDataResponse.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Invalid response format: missing "data" field');
      }
    } else {
      throw Exception('Failed to load experiences list. Status code: ${response.statusCode}');
    }
  }

  /// Mark a get of experience detail
  Future<ExperienceDataResponse> getExperienceDetail(int experienceID) async {
    final data = {
      'experience_id': experienceID
    };

    // Send request
    final response = await () async {
      try {
        return await _send<JsonObject>(_httpMethodPost, 'api/get-experience',
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

    return ExperienceDataResponse.fromJson(response!);
  }

  /// Mark a update experience online
  Future<void> updateExperienceOnline(int experienceID, bool isOnline) async {
    final data = {
      'experience_id': experienceID,
      'is_online': isOnline
    };

    // Send request
    final response = await () async {
      try {
        return await _send<JsonObject>(_httpMethodPost, 'api/update-experience-is-online',
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
  }

  /// Mark a update experience
  Future<void> updateDataExperience(int experienceId, ModifyExperienceDataModel data) async {
    final Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'api-key': '$_apiKey',
      'Authorization': 'Bearer ${await SecureStorageService.readAccessToken()}' ?? 'none',
    };

    // Create a multi-part request
    final request = http.MultipartRequest('POST', _buildUri('api/update-experience/$experienceId'));

    // Add headers if provided
    if (headers != null) {
      request.headers.addAll(headers);
    }

    // Add JSON data
    // Add non-null fields
    if (data.description != null) request.fields['description'] = data.description!;
    if (data.experienceLanguages != null) request.fields['experience_languages'] = data.experienceLanguages!;

    // Serialize horaires as a JSON string
    if (data.horaires != null) {
      request.fields['horaires'] = jsonEncode(data.horaires!.map((h) {
        return {
          'heure_debut': h.heureDebut,
          'heure_fin': h.heureFin,
          'dates': h.dates.map((d) {
            return {
              'date_debut': d.dateDebut,
              'date_fin': d.dateFin,
            };
          }).toList(),
        };
      }).toList());
    }

    if (data.prixParVoyageur != null) request.fields['prix_par_voyageur'] = data.prixParVoyageur.toString();
    if (data.priceGroupPrive != null) request.fields['price_group_prive'] = data.priceGroupPrive.toString();
    if (data.maxNumberOfPersons != null) request.fields['max_group_size'] = data.maxNumberOfPersons.toString();
    if (data.discountKidsBetween2And12 != null) request.fields['discount_kids_between_2_and_12'] = data.discountKidsBetween2And12.toString();

    // Helper function to add image if path is valid
    Future<void> addImage(String field, String? imagePath) async {
      if (imagePath != null && imagePath.isNotEmpty) {
        final imageFile = File(imagePath);
        if (await imageFile.exists()) {
          request.files.add(await http.MultipartFile.fromPath(field, imagePath));
        } else {
          print('File not found at path: $imagePath');
        }
      }
    }

    // Add images
    await addImage('image_principale', data.imagePrincipale);
    await addImage('image_0', data.image1);
    await addImage('image_1', data.image2);
    await addImage('image_2', data.image3);
    await addImage('image_3', data.image4);
    await addImage('image_4', data.image5);

    // Send the request
    final streamedResponse = await request.send();

    // Get response
    final response = await http.Response.fromStream(streamedResponse);

    // Handle response
    if (response.statusCode == 200) {
      // Parse JSON response
      //return true;
      print('Upload successful!');
    } else {
      throw Exception('Failed to send update experience: ${response.reasonPhrase}');
    }
  }

  /// Mark a update experience description
  Future<void> updateExperienceDescription(int experienceID, String description) async {
    final data = {
      'experience_id': experienceID,
      'description': description
    };

    // Send request
    final response = await () async {
      try {
        return await _send<JsonObject>(_httpMethodPost, 'api/update-experience-description',
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
  }

  /// Mark a update experience price
  Future<void> updateExperiencePrice(int experienceID, int price) async {
    final data = {
      'experience_id': experienceID,
      'prix_par_voyageur': price
    };

    // Send request
    final response = await () async {
      try {
        return await _send<JsonObject>(_httpMethodPost, 'api/update-experience-price-per-person',
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
  }

  /// Mark a update experience image
  Future<bool> updateExperienceImage(int experienceID, String imageFilePath) async {
    bool isVerified = false;
    final Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'api-key': '$_apiKey',
      'Authorization': 'Bearer ${await SecureStorageService.readAccessToken()}' ?? 'none',
    };

    final data = {
      'experience_id': experienceID.toString(),
    };

    // Create a multi-part request
    final request = http.MultipartRequest('POST', _buildUri('api/update-experience-image-principale'));

    // Add headers if provided
    if (headers != null) {
      request.headers.addAll(headers);
    }

    // Add JSON data
    request.fields.addAll(data);

    // Add audio file if provided
    if (imageFilePath != null) {
      // Create a File object from the provided file path
      final imageFile = File(imageFilePath);

      request.files.add(http.MultipartFile.fromBytes('image_principale', File(imageFile!.path).readAsBytesSync(),filename: imageFile!.path));
    }

    // Send the request
    final streamedResponse = await request.send();

    // Get response
    final response = await http.Response.fromStream(streamedResponse);

    // Handle response
    if (response.statusCode == 200) {
      // Parse JSON response
      isVerified = true;
      return isVerified;
    } else {
      throw Exception('Failed to send update image: ${response.reasonPhrase}');
    }
  }

  /// Mark a delete experience
  Future<void> deleteExperience(int experienceID) async {
    final data = {
      'experience_id': experienceID,
    };

    // Send request
    final response = await () async {
      try {
        return await _send<JsonObject>(_httpMethodDelete, 'api/delete-experience',
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
  }

  /// Update delete user
  Future<void> deleteUser() async {

    // Send request
    final response = await () async {
      try {
        return await _send<JsonObject>(_httpMethodPost, 'api/delete-user');
      } catch (e) {
        // Catch wrong user quality error
        if (e is EpHttpResponseException && e.statusCode == 400) {
          throw const DisplayableException(
              'Votre profil ne vous permet pas d’utiliser l’application MeetPe');
        }
        rethrow;
      }
    }();

    // Return data
    final result = VerifyCode.fromJson(response!);
    if(result.verified == 'Successfully logged out') {
      // Delete auth tokens
      clearTokens();

      // Delete local data
      unawaited(SecureStorageService.deleteRefreshToken());
      ///Todo Remove when refresh token is ready
      unawaited(SecureStorageService.deleteAccessToken());
      unawaited(SecureStorageService.deleteUsername());
      unawaited(SecureStorageService.deletePassword());
      unawaited(SecureStorageService.deleteRole());
      unawaited(SecureStorageService.deleteAction());
      unawaited(SecureStorageService.deleteIsVerified());
      unawaited(SecureStorageService.deleteForgotPasswordToken());
      unawaited(SecureStorageService.deleteCompleted());
      unawaited(SecureStorageService.deleteIsFirstLaunch());

      // Delete user data
      unawaited(StorageService.deleteAll(butAnalyticsEnabled: true));

      // Go back to connexion page
      navigateTo(App.navigatorContext, (_) => const LoginPage(), clearHistory: true);
    }
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
      'fcm': pushToken,
      'deviceBrand': deviceBrand,
      'deviceModel': deviceModel,
      'deviceOsVersion': deviceOsVersion,
      if (appVersion != null) 'appVersion': appVersion,
    };

    // Send request
    ///Todo Add this API
    await _send<Null>(_httpMethodPost, 'api/update-fcm', bodyJson: data);
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
      Uri.https(_authority, path, queryParameters);

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
      //Todo Remove this when refresh token is ready
      //'Authorization': 'Bearer $_accessToken' ?? 'none',
      'Authorization': 'Bearer ${await SecureStorageService.readAccessToken()}' ?? 'none',
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
        ///Todo Remove this when backend add refresh token
        AppService.instance.logOut;
        // If allowed, try get new accessToken and retry
        if (enableAutoRetryOnUnauthorized) {
          // Clear access token
          _accessToken = null;

          // If user is logged in
          if (hasRefreshToken) {
            // Refresh token
            try {
              ///Todo Remove comment when backend add refresh token
              //await _refreshAccessToken();
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
