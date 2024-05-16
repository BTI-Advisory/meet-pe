import 'package:flutter/material.dart';

import '../../../resources/resources.dart';
import '../../../utils/responsive_size.dart';
import '../../../widgets/_widgets.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:meet_pe/utils/_utils.dart';
import '../../../main.dart';
import '../../../utils/message.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  ///Todo: Delete this
  Future<bool> askNotificationPermission() async {
    final status = (await FirebaseMessaging.instance.requestPermission())
        .authorizationStatus;
    if (status == AuthorizationStatus.authorized) {
      return true;
    } else {
      showMessage(App.navigatorContext,
          'Permission refusée: notifications désactivées.',
          isError: true);
      return false;
    }
  }

  static void onNotificationReceived(RemoteMessage message) {
    // Log
    if (!kReleaseMode) {
      debugPrint(
          'Notification received (title: ${message.notification?.title ?? '<Empty>'})');
    }

    // Process notification message
    if (message.notification != null) {
      showMessage(
          App.navigatorContext,
          [
            message.notification?.title,
            message.notification?.body,
          ].toLines());
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
    final token = await FirebaseMessaging.instance
        .getToken(); // OPTI not used when init from MainBloc. + Don't fetch token if permission is denied
    return token!;
  }

  ///Todo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EpAppBar(
        title: 'FAQ & Assistance',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.calculateWidth(31, context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FAQ',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontSize: 20, color: AppResources.colorDark),
                  ),
                  const SizedBox(height: 17),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppResources.colorGray30),
                  ),
                  const SizedBox(height: 30),
                  blocHelp('FAQ Voyageurs'),
                  blocHelp('FAQ Guides'),
                  blocHelp('FAQ Photos'),
                  blocHelp('Customer Expériences'),
                  const SizedBox(height: 15),
                  Text(
                    'Assistance',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontSize: 20, color: AppResources.colorDark),
                  ),
                  const SizedBox(height: 17),
                  Text(
                    'Tu as une question concernant le fonctionnement de Meetpe ? Tu peux nous contacter via le formulaire suivant :',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppResources.colorGray30),
                  ),
                  const SizedBox(height: 30),
                  blocHelp('Nous contacter'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget blocHelp(String title) {
    return InkWell(
      onTap: () async {
        final firebaseToken = await initFirebaseMessaging();
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return Container(
              width: double.infinity,
              height: 452,
              color: AppResources.colorWhite,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 39),
                    Text(
                      'Token notif: test back',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      firebaseToken,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Color(0xff797979)),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Column(
        children: [
          const SizedBox(height: 19),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF797979)),
              ),
              Image.asset('images/chevron_right.png',
                  width: 27, height: 27, fit: BoxFit.fill),
            ],
          ),
          const SizedBox(height: 19),
          Container(
            width: 390,
            decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: AppResources.colorImputStroke,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
