import 'dart:async';

import 'package:meet_pe/main.dart';
import 'package:meet_pe/models/contact_data.dart';
import 'package:meet_pe/services/secure_storage_service.dart';
import 'package:meet_pe/utils/_utils.dart';
import 'package:meet_pe/utils/exceptions/unauthorized_exception.dart';
import 'package:fetcher/fetcher.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rxdart/rxdart.dart';

import '../screens/loginPage.dart';
import 'api_client.dart';
import 'device_info_service.dart';
import 'storage_service.dart';

class AppService {
  //#region Init
  AppService() {
    _apiClient.onRefreshTokenChanged = SecureStorageService.saveRefreshToken;
  }

  /// App Service instance singleton
  static final AppService instance = AppService();

  final _apiClient = ApiClient();
  static ApiClient get api => instance._apiClient;

  final developerModeStream = BehaviorSubject<bool>();
  bool get developerMode => developerModeStream.value!;

  bool get hasLocalUser => _apiClient.hasRefreshToken;

  Future<void> init() async {
    // Read api environment
    developerModeStream.add(StorageService.developerModeBox.value ?? !kReleaseMode);
    developerModeStream.skip(1).listen(StorageService.developerModeBox.save);

    // Read saved refresh token
    final refreshToken = await SecureStorageService.readRefreshToken();
    if (refreshToken != null) _apiClient.refreshToken = refreshToken;
  }

  // TODO: Remove the comment when implementing Crashlytics
  /*
  Future<bool> askNotificationPermission() async {
    final status = (await FirebaseMessaging.instance.requestPermission()).authorizationStatus;
    if (status == AuthorizationStatus.authorized) {
      return true;
    } else {
      showMessage(App.navigatorContext, 'Permission refusée: notifications désactivées.', isError: true);
      return false;
    }
  }

  /// Init Firebase Messaging, and return token
  Future<String> initFirebaseMessaging() async {
    // If permission allowed
    if (await askNotificationPermission()) {
      // If the app is open and running in the foreground.
      FirebaseMessaging.onMessageOpenedApp.listen(onNotificationReceived);

      // If the app is closed, but still running in the background or fully terminated
      FirebaseMessaging.onMessage.listen(onNotificationReceived);
    }

    // Get Firebase token
    final token = await FirebaseMessaging.instance.getToken();    // OPTI not used when init from MainBloc. + Don't fetch token if permission is denied
    return token!;
  }

  static void onNotificationReceived(RemoteMessage message) {
    // Log
    if (!kReleaseMode) {
      debugPrint('Notification received (title: ${message.notification?.title ?? '<Empty>'})');
    }

    // Process notification message
    if (message.notification != null) {
      showMessage(App.navigatorContext, [
        message.notification?.title,
        message.notification?.body,
      ].toLines());
    }
  }
  //#endregion
  */

  //#region App info
  BehaviorSubject<String>? _appVersion;
  BehaviorSubject<String> get appVersion {
    if (_appVersion == null) {
      _appVersion = BehaviorSubject<String>();
      _fetchAppVersion().then(appVersion.addNotNull);
    }
    return _appVersion!;
  }

  Future<String?> _fetchAppVersion() async {
    try {
      return 'v${(await PackageInfo.fromPlatform()).version}';
    } catch(e) {
      // Ignore errors;
      return null;
    }
  }
  //#endregion

  //#region Login
  Future<void> login(String email, String password) async {
    // Login
    await api.login(email, password);


    // TODO: Remove the comment when implementing Crashlytics and add API
    // Additional tasks
    await Future.wait([
      // TODO: Remove the comment when implementing Crashlytics and add API
      //_updateDeviceData(),
      //fetchUserData(),
    ]);
  }

  // TODO: Remove the comment when implementing Crashlytics
  /*Future<void> _updateDeviceData() async {
    try {
      // Init notifications
      final firebaseToken = await initFirebaseMessaging();    // OPTI don't send token if user refused permission

      // Get device info
      final deviceInfo = await DeviceInfoService.getDeviceInfo();

      // Send data
      await api.setDeviceData(
        pushToken: firebaseToken,
        deviceBrand: deviceInfo.brand,
        deviceModel: deviceInfo.model,
        deviceOsVersion: deviceInfo.osVersion,
        appVersion: appVersion.value,
      );
    } catch(e, s) {
      // Just report
      reportError(e, s);
    }
  }*/

  Future<void> fetchUserData() async {
    // Fetch data
    final userData = await AppService.api.getUserCardData();

    // Cache data
    await StorageService.userCardDataBox.saveValue(userData);
  }
  //#endregion

  //#region User info
  ContactData? get cachedUserData => StorageService.userCardDataBox.value;
  String? get cachedUserQrCode => cachedUserData?.qrCode;
  //#endregion

  //#region Other
  /// Handle errors
  void handleError(Object exception, StackTrace stack, {dynamic reason}) {
    // Report error
    // TODO: Remove the comment when implementing Crashlytics
    //reportError(exception, stack, reason: reason);    // Do not await

    // Handle Unauthorized Exception
    if (exception is UnauthorizedException) {
      logOut(warnUser: true);
    }
  }
  //#endregion

  //#region Logout
  void logOut({bool warnUser = false}) {
    // Delete auth tokens
    _apiClient.clearTokens();

    // Delete local data
    unawaited(SecureStorageService.deleteRefreshToken());
    ///Todo Remove when refresh token is ready
    unawaited(SecureStorageService.deleteAccessToken());

    // Delete user data
    unawaited(StorageService.deleteAll(butAnalyticsEnabled: true));

    // Warn user
    if (warnUser) showMessage(App.navigatorContext, 'Vous avez été déconnecté', isError: true);

    // Go back to connexion page
    navigateTo(App.navigatorContext, (_) => const LoginPage(), clearHistory: true);
  }
//#endregion
}
