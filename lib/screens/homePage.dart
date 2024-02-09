import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/app_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          )
        ],
      ),
    );
  }
}
