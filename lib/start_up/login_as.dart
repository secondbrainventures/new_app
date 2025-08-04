
import 'dart:ui';
import 'package:eeslsamparkapp/coprate_customer/business_login.dart';
import 'package:eeslsamparkapp/registration/login_screen.dart';
import 'package:eeslsamparkapp/test.dart';
import 'package:eeslsamparkapp/util/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginAsPage extends StatefulWidget {
  @override
  _LoginAsPageState createState() => _LoginAsPageState();
}

class _LoginAsPageState extends State<LoginAsPage> {

  DateTime currentBackPressTime;
  SharedPreferences _sharedPreferences;

  String user_name = "";
  String user_email = "";

  @override
  void initState() {
    super.initState();
    getLoginDetails();

    AppConfig.checkInternetConnectivity().then((intenet) {
      if (intenet != null && intenet) {

      } else {
        AppConfig.showAlertDialog(context);
      }
    });

    AppConfig.getUserLocation(context).then((currentPostion) {
      if (currentPostion != null) {
        // String lat = "${currentPostion.latitude}";
        // String long = "${currentPostion.longitude}";s
      }
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: SafeArea(
           child: WillPopScope(
              child:Container(
                 width: double.infinity,
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: <Widget>[

                      SizedBox(height: 20.0),

                      Container(
                          child:Image.asset('assets/image/eesl_logo.png', height: 50)),

                      SizedBox(height: 5.0),

                      Text("SAMPARK", textAlign: TextAlign.center, style: TextStyle(fontSize: 18.0,
                          color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD)),

                     Expanded(
                        flex: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            InkWell(
                              onTap :() {
                                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
                              },
                              child: Image(image: AssetImage('assets/image/businessman.png'),height: 130,),
                            ),

                            SizedBox(height: 20),

                            Text("Consumer",textAlign: TextAlign.center ,style: TextStyle(fontSize: 18.0,
                                color: Color(AppConfig.BLUE_COLOR[1]),fontFamily: AppConfig.FONT_TYPE_BOLD)),

                            Text("For Public Street Lights Complaint",textAlign: TextAlign.center ,style: TextStyle(fontSize: 14.0,
                                color: Color(AppConfig.BLUE_COLOR[1]),fontFamily: AppConfig.FONT_TYPE_BOLD)),
                          ],
                        ),
                      ),

                      Expanded(
                        flex: 5,
                        child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  InkWell(
                                      onTap :() {
                                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => BusinessLogin()));
                                      },
                                      child: Image(image: AssetImage('assets/image/briefcase.png'),height: 130,)),

                                  SizedBox(height: 20),

                                  Text("Corporate Customer",textAlign: TextAlign.center ,style: TextStyle(fontSize: 18.0,
                                      color: Color(AppConfig.BLUE_COLOR[1]),fontFamily: AppConfig.FONT_TYPE_BOLD)),
                                ],
                              ),


                      ),

                      Expanded(
                        flex: 2,
                        child: Container(),
                      ),

                    ],
                  ),
                ),onWillPop: onWillPop
            )));
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "press back again to exit");
      return Future.value(false);
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
  }

  getLoginDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      user_email = _sharedPreferences.getString(AppConfig.EMAIL_ID);
      user_name = _sharedPreferences.getString(AppConfig.NAME);
    });
  }
}
