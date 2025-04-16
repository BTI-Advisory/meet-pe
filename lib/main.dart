import 'package:fetcher/fetcher.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:meet_pe/providers/filter_provider.dart';
import 'package:meet_pe/resources/app_theme.dart';
import 'package:meet_pe/screens/authentification/launch_screen.dart';
import 'package:meet_pe/services/app_service.dart';
import 'package:meet_pe/services/secure_storage_service.dart';
import 'package:meet_pe/services/storage_service.dart';
import 'package:meet_pe/utils/utils.dart';
import 'package:meet_pe/widgets/value_stream_builder.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  // Init Flutter
  WidgetsFlutterBinding.ensureInitialized();
  await SecureStorageService.initialize();

  // Override default debugPrint
  debugPrint = (message, {wrapWidth}) {
    // Disable logging in release mode
    if (!kReleaseMode) debugPrintThrottled(message, wrapWidth: wrapWidth);

    // Send to Crashlytics journal
    if (message != null) FirebaseCrashlytics.instance.log(message);
  };

  // init Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Init notifications
  AppService.instance.initFirebaseMessaging();
  if (!kReleaseMode)
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);

  // Pass all Flutter's uncaught errors to Crashlytics.
  FlutterError.onError = (flutterErrorDetails) {
    if (shouldReportException(flutterErrorDetails.exception)) {
      FirebaseCrashlytics.instance.recordFlutterError(flutterErrorDetails);
    }
  };

  // Set default TimeAgo package locale
  timeago.setLocaleMessages(
      'en', timeago.FrShortMessages()); // Set default timeAgo local to fr

  // Init local storage
  await StorageService.init();

  // Init app service
  await AppService.instance.init();

  // Init Stripe
  // Détermine automatiquement l'environnement
  String envFile = kReleaseMode ? "assets/.env" : "assets/.env.test";
  //await dotenv.load(fileName: envFile);
  try {
    await dotenv.load(fileName: envFile);
    print('✅ dotenv loaded');
  } catch (e) {
    print('❌ dotenv load failed: $e');
  }
  print('🔑 STRIPE_PUBLISHABLE_KEY = ${dotenv.env['STRIPE_PUBLISHABLE_KEY']}');


  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';

  // Init Analytics
  //await AnalyticsService.init();

  // Start App
  //runApp(const MyApp());
  //initializeDateFormatting().then((_) => runApp(App()));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FilterProvider()),
      ],
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  /// Global key for the App's main navigator
  static final GlobalKey<NavigatorState> _navigatorKey =
  GlobalKey<NavigatorState>();

  /// The [BuildContext] of the main navigator.
  /// We may use this on showMessage, showError, openDialog, etc.
  static BuildContext get navigatorContext => _navigatorKey.currentContext!;

// Todo: Implementing when Auth feature is done
/// Build the default launch page widget
static Widget buildLaunchPage() =>
      AppService.instance.hasLocalUser ? const LaunchScreen() : const LaunchScreen();

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
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: L10n.all,
        theme: buildAppTheme(),
        darkTheme: buildAppTheme(darkMode: false),
        navigatorKey: _navigatorKey,
        home: buildLaunchPage(),
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
  }
}
