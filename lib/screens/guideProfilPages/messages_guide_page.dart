import 'package:flutter/material.dart';

class MessagesGuidePage extends StatefulWidget {
  const MessagesGuidePage({super.key});

  @override
  State<MessagesGuidePage> createState() => _MessagesGuidePageState();
}

class _MessagesGuidePageState extends State<MessagesGuidePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'images/coming-soon-wallpaper.jpg',
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
