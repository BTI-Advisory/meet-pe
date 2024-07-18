import 'package:flutter/material.dart';
import 'package:meet_pe/utils/_utils.dart';
import 'package:meet_pe/widgets/_widgets.dart';

import '../../../resources/resources.dart';
import '../../../services/app_service.dart';

class NotificationsNewslettersPage extends StatefulWidget {
  const NotificationsNewslettersPage({super.key});

  @override
  State<NotificationsNewslettersPage> createState() => _NotificationsNewslettersPageState();
}

class _NotificationsNewslettersPageState extends State<NotificationsNewslettersPage> {
  bool isEmailResAvailable = false;
  bool isAppNotificationResAvailable = false;
  bool isSMSResAvailable = false;
  bool isCallMobileResAvailable = false;
  bool isEmailAvailable = false;
  bool isAppNotificationAvailable = false;
  bool isSMSAvailable = false;
  bool isCallMobileAvailable = false;

  @override
  void initState() {
    super.initState();
    _fetchNotificationSettings();
  }

  Future<void> _fetchNotificationSettings() async {
    try {
      final notifications = await AppService.api.getNotificationSettings();
      setState(() {
        isEmailResAvailable = notifications.reservationEmail;
        isAppNotificationResAvailable = notifications.reservationApp;
        isSMSResAvailable = notifications.reservationSms;
        isCallMobileResAvailable = notifications.reservationAppelTelephone;
        isEmailAvailable = notifications.notificationMeetpeEmail;
        isAppNotificationAvailable = notifications.notificationMeetpeApp;
        isSMSAvailable = notifications.notificationMeetpeSms;
        isCallMobileAvailable = notifications.notificationMeetpeAppelTelephone;
      });
    } catch (e) {
      // Handle error
      print('Error fetching notification settings: $e');
    }
  }

  void sendNotificationSettings() async{
    // Prepare the notification settings data
    Map<String, bool> notificationSettings = {
      "reservation_email": isEmailResAvailable,
      "reservation_app": isAppNotificationResAvailable,
      "reservation_sms": isSMSResAvailable,
      "reservation_appel_telephone": isCallMobileResAvailable,
      "notification_meetpe_email": isEmailAvailable,
      "notification_meetpe_app": isAppNotificationAvailable,
      "notification_meetpe_sms": isSMSAvailable,
      "notification_meetpe_appel_telephone": isCallMobileAvailable
    };

    // Call the API method to send notification settings
    await AppService.api.sendNotificationSettings(notificationSettings);
    showMessage(context, 'Nous avons pris en compte tes modifications');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EpAppBar(
        title: 'Notifications & Newsletters',
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
                    'Notifications des réservations',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                        fontSize: 20, color: AppResources.colorDark),
                  ),
                  const SizedBox(height: 17),
                  Text(
                    'Reçois des notifications lorsqu’un voyageur réserve, annule ou modifie une expérience.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppResources.colorGray30),
                  ),
                  const SizedBox(height: 30),
                  activeNotification('Email', isEmailResAvailable, (bool value) {
                    setState(() {
                      //isEmailResAvailable = value;
                    });
                  }),
                  activeNotification('App notifications', isAppNotificationResAvailable, (bool value) {
                    setState(() {
                      isAppNotificationResAvailable = value;
                    });
                  }),
                  activeNotification('SMS', isSMSResAvailable, (bool value) {
                    setState(() {
                      isSMSResAvailable = value;
                    });
                  }),
                  activeNotification('Appel téléphonique', isCallMobileResAvailable, (bool value) {
                    setState(() {
                      isCallMobileResAvailable = value;
                    });
                  }),
                  const SizedBox(height: 23),
                  Text(
                    'Notifications  Meet People',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                        fontSize: 20, color: AppResources.colorDark),
                  ),
                  const SizedBox(height: 17),
                  Text(
                    'Reçois des nouveautés sur l’actualité de Meet People, toutes les dernières expériences et des conseils de voyage.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppResources.colorGray30),
                  ),
                  const SizedBox(height: 30),
                  activeNotification('Email', isEmailAvailable, (bool value) {
                    setState(() {
                      //isEmailAvailable = value;
                    });
                  }),
                  activeNotification('App notifications', isAppNotificationAvailable, (bool value) {
                    setState(() {
                      isAppNotificationAvailable = value;
                    });
                  }),
                  activeNotification('SMS', isSMSAvailable, (bool value) {
                    setState(() {
                      isSMSAvailable = value;
                    });
                  }),
                  activeNotification('Appel téléphonique', isCallMobileAvailable, (bool value) {
                    setState(() {
                      isCallMobileAvailable = value;
                    });
                  }),
                  const SizedBox(height: 23),
                  Container(
                    width: ResponsiveSize.calculateWidth(319, context),
                    height: ResponsiveSize.calculateHeight(44, context),
                    child: TextButton(
                      style: ButtonStyle(
                        padding:
                        MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(
                                horizontal: ResponsiveSize.calculateWidth(24, context), vertical: ResponsiveSize.calculateHeight(12, context))),
                        backgroundColor: MaterialStateProperty.all(
                            Colors.transparent),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: AppResources.colorDark),
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                      child: Text(
                        'ENREGISTRER',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: AppResources.colorDark),
                      ),
                      onPressed: () {
                        sendNotificationSettings();
                      },
                    ),
                  ),
                  const SizedBox(height: 23)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget activeNotification(String name, bool active, Function(bool) onChanged) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFF797979)),
            ),
            Switch.adaptive(
              value: active,
              activeColor: AppResources.colorVitamine,
              onChanged: onChanged,
            )
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
