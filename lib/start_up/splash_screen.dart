import 'dart:async';

import 'package:eeslsamparkapp/coprate_customer/business_login.dart';
import 'package:eeslsamparkapp/coprate_customer/business_pin_screen.dart';
import 'package:eeslsamparkapp/registration/login_pin_screen.dart';
import 'package:eeslsamparkapp/registration/login_screen.dart';
import 'package:eeslsamparkapp/start_up/login_as.dart';
import 'package:eeslsamparkapp/util/app_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  SharedPreferences _sharedPreferences;

  @override
  void initState() {
    super.initState();
    getLoginDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:Colors.white,
        body: Stack(
          children: <Widget>[
            Center(
              child: Container(
                color: Colors.white,
                 child:Image(image: AssetImage('assets/image/splash_screen.png')))),
          ],
        )
    );
  }

  getLoginDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    if(_sharedPreferences.getBool(AppConfig.KEY_IS_LOGGEDIN) == null) {
      _sharedPreferences.setBool(AppConfig.KEY_IS_LOGGEDIN, false);
    }

   bool flag = _sharedPreferences.getBool(AppConfig.KEY_IS_LOGGEDIN);
   Timer(Duration(seconds: 2), () => _navigateTo(flag));
  }

  _navigateTo(bool flag) {

    if(flag) {

      print(flag);
      print(_sharedPreferences.getString(AppConfig.USER_TYPE));

      if(_sharedPreferences.getString(AppConfig.USER_TYPE) == "B2B-USER") {

        print(_sharedPreferences.getString(AppConfig.USER_TYPE));
        if(flag) {
          String mobile_no = _sharedPreferences.getString(AppConfig.MOBILE_NUMBER);
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => BusinessLoginWithPinScreen(mobile_no)));
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => BusinessLogin()));
        }

      } else if(_sharedPreferences.getString(AppConfig.USER_TYPE) == "B2C-USER") {

        print(_sharedPreferences.getString(AppConfig.USER_TYPE));
        if(flag) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginWithPinScreen()));
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
        }

      } else {
        print("NO-USER");
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginAsPage()));
      }

    } else {
      print("Direct-USER");
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginAsPage()));
    }



    /*if(flag) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginWithPinScreen()));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
    }*/
  }

}