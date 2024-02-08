import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:meet_pe/resources/app_theme.dart';
import 'package:meet_pe/screens/launch_screen.dart';
import 'package:meet_pe/screens/onBoardingPages/guide/loadingGuidePage.dart';
import 'package:meet_pe/services/app_service.dart';
import 'package:meet_pe/services/storage_service.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  // Init Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Override default debugPrint
  debugPrint = (message, {wrapWidth}) {
    // Disable logging in release mode
    if (!kReleaseMode) debugPrintThrottled(message, wrapWidth: wrapWidth);

    // Send to Crashlytics journal
    //TODO: when implementing FirebaseCrashlytics
    //if (message != null) FirebaseCrashlytics.instance.log(message);
  };

  // init Firebase
  //TODO: when implementing FirebaseCrashlytics
  /*await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (!kReleaseMode)
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);

  // Pass all Flutter's uncaught errors to Crashlytics.
  FlutterError.onError = (flutterErrorDetails) {
    if (shouldReportException(flutterErrorDetails.exception)) {
      FirebaseCrashlytics.instance.recordFlutterError(flutterErrorDetails);
    }
  };*/

  // Set default intl package locale
  Intl.defaultLocale = App.defaultLocale.toString();

  // Set default TimeAgo package locale
  timeago.setLocaleMessages(
      'en', timeago.FrShortMessages()); // Set default timeAgo local to fr

  // Init local storage
  await StorageService.init();

  // Init app service
  await AppService.instance.init();

  // Init Analytics
  //await AnalyticsService.init();

  // Start App
  //runApp(const MyApp());
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: buildAppTheme(),
      darkTheme: buildAppTheme(darkMode: true),
      home: LaunchScreen(),
    );
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // Default locale
  static const defaultLocale = Locale('fr');

  /// Global key for the App's main navigator
  static final GlobalKey<NavigatorState> _navigatorKey =
  GlobalKey<NavigatorState>();

  /// The [BuildContext] of the main navigator.
  /// We may use this on showMessage, showError, openDialog, etc.
  static BuildContext get navigatorContext => _navigatorKey.currentContext!;

  @override
  Widget build(context) {
    // TODO: implement build
    throw UnimplementedError();
  }

// Todo: Implementing when Auth feature is done
/// Build the default launch page widget
/*static Widget buildLaunchPage() =>
      AppService.instance.hasLocalUser ? const MainPage() : const LoginPage();

  @override
  Widget build(BuildContext context) {
    // Set orientations. Must be in the build method.
    SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.portraitUp,
    ]);

    // Build App
    return DefaultFetcherConfig(
      config: FetcherConfig(
        showError: showError,
        reportError: AppService.instance.handleError,
      ),
      child: MaterialApp(
        title: 'Meet-Pe',
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: const [defaultLocale],
        theme: buildAppTheme(),
        darkTheme: buildAppTheme(darkMode: true),
        navigatorKey: _navigatorKey,
        home: AnalyticsService.isEnabled == null
            ? const AnalyticsConsentPage()
            : buildLaunchPage(),
        builder: (context, child) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Content
              child!,

              // Api Environment Banner
              ValueStreamBuilder<bool>(
                stream: AppService.instance.developerModeStream,
                builder: (context, snapshot) {
                  if (snapshot.data != true) return const SizedBox();

                  return const Banner(
                    message: 'DEV',
                    location: BannerLocation.topStart,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }*/
}
