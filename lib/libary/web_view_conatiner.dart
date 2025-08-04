import 'dart:async';
import 'dart:io';

import 'package:eeslsamparkapp/util/app_config.dart';
import 'package:flutter/material.dart';
 import 'package:eeslsamparkapp/util/app_config.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  String url = "";
  String heading = "";

  WebViewContainer(this.url, this.heading);

  @override
  _WebViewContainerState createState() => _WebViewContainerState(url, heading);
}

class _WebViewContainerState extends State<WebViewContainer> {
  String url1;
  String heading;

  _WebViewContainerState(this.url1, this.heading);

  final GlobalKey webViewKey = GlobalKey();

    WebViewController _controller = WebViewController();

  @override
  void initState() {
    super.initState();



    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(AppConfig.NEWS_URL)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url1));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text(heading),
      centerTitle: true, 
      
      ),


      body: WebViewWidget(controller: _controller),
    );
  
  }
}
