import 'package:flutter/material.dart';

class MessagesGuidePage extends StatefulWidget {
  const MessagesGuidePage({super.key});

  @override
  State<MessagesGuidePage> createState() => _MessagesGuidePageState();
}

class _MessagesGuidePageState extends State<MessagesGuidePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Hello messages'),
        ],
      ),
    );
  }
}
