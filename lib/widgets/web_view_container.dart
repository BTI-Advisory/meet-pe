import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  final String webUrl;
  const WebViewContainer({super.key, required this.webUrl});

  @override
  State<WebViewContainer> createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {

  final controller = WebViewController();

  @override
  void initState() {
    super.initState();
    //initialize webview
    controller..setJavaScriptMode(JavaScriptMode.disabled)
      ..loadRequest(Uri.parse(widget.webUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meet People'),
      ),
      body: WebViewWidget(controller: controller,),
    );
  }
}
