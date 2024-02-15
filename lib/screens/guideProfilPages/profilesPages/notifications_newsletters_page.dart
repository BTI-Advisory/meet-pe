import 'package:flutter/material.dart';

import '../../../resources/resources.dart';
import '../../../utils/responsive_size.dart';
import '../../../widgets/themed/ep_app_bar.dart';

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
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppResources.colorGray30),
                  ),
                  const SizedBox(height: 30),
                  activeNotification('Email', isEmailResAvailable, (bool value) {
                    setState(() {
                      isEmailResAvailable = value;
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
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppResources.colorGray30),
                  ),
                  const SizedBox(height: 70),
                  Text(
                    'Notifications  Meetpe',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                        fontSize: 20, color: AppResources.colorDark),
                  ),
                  const SizedBox(height: 17),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppResources.colorGray30),
                  ),
                  const SizedBox(height: 30),
                  activeNotification('Email', isEmailAvailable, (bool value) {
                    setState(() {
                      isEmailAvailable = value;
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
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppResources.colorGray30),
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
