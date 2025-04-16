import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  final String webUrl;
  const WebViewContainer({super.key, required this.webUrl});

  @override
  State<WebViewContainer> createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    // Initialize the WebViewController with JavaScript enabled
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      //..setDebuggingEnabled(true)  // Enable debugging
      ..loadRequest(Uri.parse(widget.webUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meet People'),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
