import 'package:flutter/material.dart';

import '../../resources/resources.dart';
import '../../services/app_service.dart';

class MessagesGuidePage extends StatefulWidget {
  const MessagesGuidePage({super.key});

  @override
  State<MessagesGuidePage> createState() => _MessagesGuidePageState();
}

class _MessagesGuidePageState extends State<MessagesGuidePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Hello messages'),
          TextButton(
            onPressed: () async {
              await AppService.api.deleteUser();
              AppService.instance.logOut;
            },
            child: Text(
                'Supprimer mon compte',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500, color: AppResources.colorGray30)
            ),
          ),
        ],
      ),
    );
  }
}
