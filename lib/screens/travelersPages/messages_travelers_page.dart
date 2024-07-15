import 'package:flutter/material.dart';

class MessagesTravelersPage extends StatefulWidget {
  const MessagesTravelersPage({super.key});

  @override
  State<MessagesTravelersPage> createState() => _MessagesTravelersPageState();
}

class _MessagesTravelersPageState extends State<MessagesTravelersPage> {
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
