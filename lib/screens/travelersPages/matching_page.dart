import 'package:flutter/material.dart';

import '../../services/app_service.dart';

class MatchingPage extends StatefulWidget {
  const MatchingPage({super.key});

  @override
  State<MatchingPage> createState() => _MatchingPageState();
}

class _MatchingPageState extends State<MatchingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Hello'),
          TextButton(
            onPressed: AppService.instance.logOut,
            child: Text('Logout'),
          ),
          TextButton(
            onPressed: () async {
              await AppService.api.deleteUser();
              AppService.instance.logOut;
            },
            child: Text('Delete'),
          )
        ],
      ),
    );
  }
}