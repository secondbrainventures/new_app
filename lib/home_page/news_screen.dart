
import 'dart:async';
import 'dart:io';

import 'package:eeslsamparkapp/util/app_config.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class NewsScreen extends StatefulWidget {


  const NewsScreen({ Key key }) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();

}

class _NewsScreenState extends State<NewsScreen> {

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
      ..loadRequest(Uri.parse(AppConfig.NEWS_URL));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text('News'),
      centerTitle: true,
      ),


      body: WebViewWidget(controller: _controller),




    );
  }
}
