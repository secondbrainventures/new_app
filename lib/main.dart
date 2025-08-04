import 'dart:io';
import 'package:eeslsamparkapp/home_page/news_screen.dart';
import 'package:eeslsamparkapp/lodge_complaint/lodge_complaint.dart';
import 'package:eeslsamparkapp/registration/create_pin.dart';
import 'package:eeslsamparkapp/registration/login_pin_screen.dart';
import 'package:eeslsamparkapp/registration/login_screen.dart';
import 'package:eeslsamparkapp/start_up/splash_screen.dart';
import 'package:eeslsamparkapp/util/app_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SharedPreferences.setMockInitialValues({});
  // if (Platform.isAndroid) {
  //   await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

  //   var swAvailable = await AndroidWebViewFeature.isFeatureSupported(
  //       AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
  //   var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(
  //       AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

  //   if (swAvailable && swInterceptAvailable) {
  //     AndroidServiceWorkerController serviceWorkerController =
  //         AndroidServiceWorkerController.instance();

  //     serviceWorkerController.serviceWorkerClient = AndroidServiceWorkerClient(
  //       shouldInterceptRequest: (request) async {
  //         print(request);
  //         return null;
  //       },
  //     );
  //   }
  // }

  AppConfig.secureScreen();
 // AppConfig.checkSafeDevice();
  runApp(EESLSamparkApp());
  
}

class EESLSamparkApp extends StatelessWidget {
  bool isSafeDevice = false;
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EESL App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen() ,

      
    );
  }
}


