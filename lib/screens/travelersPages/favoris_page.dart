import 'package:flutter/material.dart';

import '../../services/app_service.dart';

class FavorisPage extends StatefulWidget {
  const FavorisPage({super.key});

  @override
  State<FavorisPage> createState() => _FavorisPageState();
}

class _FavorisPageState extends State<FavorisPage> {
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