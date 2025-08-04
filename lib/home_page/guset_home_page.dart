
import 'dart:io';
import 'dart:ui';

import 'package:eeslsamparkapp/complaint_status/complain_status.dart';
import 'package:eeslsamparkapp/libary/bouncing_button.dart';
import 'package:eeslsamparkapp/libary/web_view_conatiner.dart';
import 'package:eeslsamparkapp/lodge_complaint/lodge_complaint.dart';
import 'package:eeslsamparkapp/registration/login_screen.dart';
import 'package:eeslsamparkapp/side_menu/change_pin.dart';
import 'package:eeslsamparkapp/side_menu/user_profile.dart';
import 'package:eeslsamparkapp/util/app_config.dart';
import 'package:eeslsamparkapp/util/contact_us.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuestMainHomePage extends StatefulWidget {
  @override
  _GuestMainHomePageState createState() => _GuestMainHomePageState();
}

class _GuestMainHomePageState extends State<GuestMainHomePage> {

  DateTime currentBackPressTime;

  @override
  void initState() {
    super.initState();
    AppConfig.checkInternetConnectivity().then((intenet) {
      if (intenet != null && intenet) {

      } else {
        AppConfig.showAlertDialog(context);
      }
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: SafeArea(
            child: WillPopScope(
              child:Container(
               color: Color(AppConfig.LIGHT_GRAY_COLOR[0]),
                 child: ListView(
                   children: <Widget>[

                    SizedBox(height: 20.0),

                    Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: () {
                              openAlertBox();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Image.asset('assets/image/menu_iocn.png', height: 20),
                            ),
                          )),

                      Container(
                          child:Image.asset('assets/image/eesl_logo.png', height: 50)),

                      SizedBox(height: 5.0),

                      Text("SAMPARK", textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18.0, color: Color(AppConfig.BLUE_COLOR[1]),
                              fontFamily: AppConfig.FONT_TYPE_BOLD)),

                      SizedBox(height: 20.0),

                     /* Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text("DASHBOARDS",style: TextStyle(fontSize: 16.0,
                              color: Color(AppConfig.BLUE_COLOR[1]),fontFamily: AppConfig.FONT_TYPE_BOLD))),

                      SizedBox(height: 10.0),

                      Row(
                        children: [

                          Expanded(
                              flex: 2,
                              child: Bouncing(
                                onPress: () {

                                  AppConfig.checkInternetConnectivity().then((intenet) {
                                    if (intenet != null && intenet) {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => WebViewContainer(AppConfig.SLNP_URL,"SLNP")));
                                    } else {
                                      AppConfig.showAlertDialog(context);
                                    }
                                  });

                                },
                                child: Container(

                                  child: Column(
                                    children: [
                                      Container(
                                        height: 60,
                                        margin: EdgeInsets.only(left: 10, right: 5),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [new BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 10.0,
                                            ),],
                                            borderRadius: BorderRadius.circular(10)),
                                        child:  Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Image(image: AssetImage('assets/image/slnp_iocn.png'),height: 20,),
                                        ),
                                      ),

                                      SizedBox(height: 10),

                                      Text("SLNP",textAlign: TextAlign.center ,style: TextStyle(fontSize: 14.0,
                                          color: Color(AppConfig.BLUE_COLOR[1]),fontFamily: AppConfig.FONT_TYPE_BOLD)),


                                    ],
                                  ),
                                ),
                              )),

                          Expanded(
                              flex: 2,
                              child: Bouncing(
                                onPress: () {

                                  AppConfig.checkInternetConnectivity().then((intenet) {
                                    if (intenet != null && intenet) {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => WebViewContainer(AppConfig.UJALA_URL,"UJALA")));
                                    } else {
                                      AppConfig.showAlertDialog(context);
                                    }
                                  });


                                },
                                child: Container(

                                  child: Column(
                                    children: [
                                      Container(
                                        height: 60,
                                        margin: EdgeInsets.only(left: 5, right: 5),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [new BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 10.0,
                                            ),],
                                            borderRadius: BorderRadius.circular(10)),
                                        child:  Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Image(image: AssetImage('assets/image/uala_icon.png'),height: 20,),
                                        ),
                                      ),

                                      SizedBox(height: 10),

                                      Text("UJALA",textAlign: TextAlign.center ,style: TextStyle(fontSize: 14.0,
                                          color: Color(AppConfig.BLUE_COLOR[1]),fontFamily: AppConfig.FONT_TYPE_BOLD)),


                                    ],
                                  ),
                                ),
                              )


                          ),

                          Expanded(
                              flex: 2,
                              child: Bouncing(
                                onPress: () {

                                  AppConfig.checkInternetConnectivity().then((intenet) {
                                    if (intenet != null && intenet) {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => WebViewContainer(AppConfig.AJAY_URL,"AJAY")));
                                    } else {
                                      AppConfig.showAlertDialog(context);
                                    }
                                  });


                                },
                                child: Container(

                                  child: Column(
                                    children: [
                                      Container(
                                        height: 60,
                                        margin: EdgeInsets.only(left: 5, right: 5),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [new BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 10.0,
                                            ),],
                                            borderRadius: BorderRadius.circular(10)),
                                        child:  Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Image(image: AssetImage('assets/image/ajay_icon.png'),height: 15,),
                                        ),
                                      ),

                                      SizedBox(height: 10),

                                      Text("AJAY",textAlign: TextAlign.center ,style: TextStyle(fontSize: 14.0,
                                          color: Color(AppConfig.BLUE_COLOR[1]),fontFamily: AppConfig.FONT_TYPE_BOLD)),


                                    ],
                                  ),
                                ),
                              )


                          ),

                          Expanded(
                              flex: 2,
                              child: Bouncing(
                                onPress: () {

                                  AppConfig.checkInternetConnectivity().then((intenet) {
                                    if (intenet != null && intenet) {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => WebViewContainer(AppConfig.BEEP_URL,"BEEP")));
                                    } else {
                                      AppConfig.showAlertDialog(context);
                                    }
                                  });


                                },
                                child: Container(

                                  child: Column(
                                    children: [
                                      Container(
                                        height: 60,
                                        margin: EdgeInsets.only(left: 5, right: 5),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [new BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 10.0,
                                            ),],
                                            borderRadius: BorderRadius.circular(10)),
                                        child:  Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Image(image: AssetImage('assets/image/beep_icon.png'),height: 20,),
                                        ),
                                      ),

                                      SizedBox(height: 10),

                                      Text("BEEP",textAlign: TextAlign.center ,style: TextStyle(fontSize: 14.0,
                                          color: Color(AppConfig.BLUE_COLOR[1]),fontFamily: AppConfig.FONT_TYPE_BOLD)),


                                    ],
                                  ),
                                ),
                              )


                          ),

                          Expanded(
                              flex: 2,
                              child: Bouncing(
                                onPress: () {
                                  AppConfig.checkInternetConnectivity().then((intenet) {
                                    if (intenet != null && intenet) {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => WebViewContainer(AppConfig.SEAC_URL,"SEAC")));
                                    } else {
                                      AppConfig.showAlertDialog(context);
                                    }
                                  });

                                },
                                child: Container(

                                  child: Column(
                                    children: [
                                      Container(
                                        height: 60,
                                        margin: EdgeInsets.only(left: 5, right: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [new BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 10.0,
                                            ),],
                                            borderRadius: BorderRadius.circular(10)),
                                        child:  Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Image(image: AssetImage('assets/image/seac_icon.png'),height: 20,),
                                        ),
                                      ),

                                      SizedBox(height: 10),

                                      Text("SEAC",textAlign: TextAlign.center ,style: TextStyle(fontSize: 14.0,
                                          color: Color(AppConfig.BLUE_COLOR[1]),fontFamily: AppConfig.FONT_TYPE_BOLD)),


                                    ],
                                  ),
                                ),
                              )


                          ),

                        ],
                      ),

                      SizedBox(height: 20.0),*/

                      Row(
                        children: [

                          Expanded(
                              flex: 5,
                              child: Bouncing(
                                onPress : () {
                                  openAlertBox();
                                },
                                child: Container(
                                  height: 140,
                                  margin: EdgeInsets.only(left: 10, right: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [new BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10.0,
                                      ),],
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    children: [

                                      SizedBox(height: 25),

                                      Image(image: AssetImage('assets/image/register_complaint_icon.png'),height: 60,),

                                      SizedBox(height: 15),

                                      Padding(
                                        padding: const EdgeInsets.only(left:8.0,right: 8.0),
                                        child: Text("Lodge Complaint",textAlign: TextAlign.center ,
                                            style: TextStyle(fontSize: 16.0,
                                                color: Color(AppConfig.BLUE_COLOR[1]),fontFamily: AppConfig.FONT_TYPE_BOLD)),
                                      ),


                                    ],
                                  ),
                                ),
                              )),

                          Expanded(
                              flex: 5,
                              child: Bouncing(
                                onPress: () {
                                  openAlertBox();
                                },
                                child: Container(
                                  height: 140,
                                  margin: EdgeInsets.only(left: 5, right: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [new BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10.0,
                                      ),],
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    children: [

                                      SizedBox(height: 25),

                                      Image(image: AssetImage('assets/image/complint_status_icon.png'),height: 60,),

                                      SizedBox(height: 15),

                                      Padding(
                                        padding: const EdgeInsets.only(left:8.0,right: 8.0),
                                        child: Text("Complaint Status",textAlign: TextAlign.center ,style: TextStyle(fontSize: 16.0,
                                            color: Color(AppConfig.BLUE_COLOR[1]),fontFamily: AppConfig.FONT_TYPE_BOLD))),


                                    ],
                                  ),
                                ),
                              )),

                        ],
                      ),

                      SizedBox(height: 10.0),

                      Row(
                        children: [

                          Expanded(
                              flex: 5,
                              child:Bouncing(
                                onPress: () {

                                  AppConfig.checkInternetConnectivity().then((intenet) {
                                    if (intenet != null && intenet) {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => WebViewContainer(AppConfig.NEWS_URL,"NEWS")));
                                    } else {
                                      AppConfig.showAlertDialog(context);
                                    }
                                  });
                                },
                                child: Container(
                                  height: 130,
                                  margin: EdgeInsets.only(left: 10, right: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [new BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10.0,
                                      ),],
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    children: [

                                      SizedBox(height: 25),

                                      Image(image: AssetImage('assets/image/news_icon.png'),height: 60,),

                                      SizedBox(height: 10),

                                      Text("News",textAlign: TextAlign.center ,style: TextStyle(fontSize: 16.0,
                                          color: Color(AppConfig.BLUE_COLOR[1]),fontFamily: AppConfig.FONT_TYPE_BOLD)),


                                    ],
                                  ),
                                ),
                              )),

                          Expanded(
                              flex: 5,
                              child: Bouncing(
                                onPress : () {
                                  AppConfig.checkInternetConnectivity().then((intenet) {
                                    if (intenet != null && intenet) {
                                      if(Platform.isIOS) {
                                        AppConfig.launchURL(AppConfig.APP_STORE_URL);
                                      } else {
                                        AppConfig.launchURL(AppConfig.PLAY_STORE_URL);
                                      }
                                    } else {
                                      AppConfig.showAlertDialog(context);
                                    }
                                  });
                                },
                                child: Container(
                                  height: 130,
                                  margin: EdgeInsets.only(left: 5, right: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10.0,
                                      ),],
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    children: [

                                      SizedBox(height: 25),

                                      Image(image: AssetImage('assets/image/feedback_icon.png'),height: 60,),

                                      SizedBox(height: 10),

                                      Text("Feedback",textAlign: TextAlign.center ,style: TextStyle(fontSize: 16.0,
                                          color: Color(AppConfig.BLUE_COLOR[1]),fontFamily: AppConfig.FONT_TYPE_BOLD)),
                                    ],
                                  ),
                                ),
                              )),

                        ],
                      ),

                      SizedBox(height: 10.0),

                      Row(
                        children: [

                          Expanded(
                              flex: 5,
                              child:  Bouncing(
                                onPress: () {
                                  AppConfig.checkInternetConnectivity().then((intenet) {
                                    if (intenet != null && intenet) {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => WebViewContainer(AppConfig.FAQ_URL,"FAQ's")));
                                    } else {
                                      AppConfig.showAlertDialog(context);
                                    }
                                  });

                                },
                                child: Container(
                                  height: 130,
                                  margin: EdgeInsets.only(left: 10, right: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [new BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10.0,
                                      ),],
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    children: [

                                      SizedBox(height: 25),

                                      Image(image: AssetImage('assets/image/faq_icon.png'),height: 60,),

                                      SizedBox(height: 10),

                                      Text("FAQ's",textAlign: TextAlign.center ,style: TextStyle(fontSize: 16.0,
                                          color: Color(AppConfig.BLUE_COLOR[1]),fontFamily: AppConfig.FONT_TYPE_BOLD)),


                                    ],
                                  ),
                                ),
                              )),

                          Expanded(
                              flex: 5,
                              child: Bouncing(
                                onPress: () {
                                  AppConfig.checkInternetConnectivity().then((intenet) {
                                    if (intenet != null && intenet) {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ContactUs()));
                                    } else {
                                      AppConfig.showAlertDialog(context);
                                    }
                                  });

                                },
                                child: Container(
                                  height: 130,
                                  margin: EdgeInsets.only(left: 5, right: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [new BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10.0,
                                      ),],
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    children: [

                                      SizedBox(height: 25),

                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Image(image: AssetImage('assets/image/contact_us_icon.png'),height: 60,),
                                      ),

                                      SizedBox(height: 10),

                                      Text("Contact Us",textAlign: TextAlign.center ,style: TextStyle(fontSize: 16.0,
                                          color: Color(AppConfig.BLUE_COLOR[1]),fontFamily: AppConfig.FONT_TYPE_BOLD)),


                                    ],
                                  ),
                                ),
                              )),

                        ],
                      ),

                      SizedBox(height: 30.0),

                      Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Image.asset('assets/image/make_in_india.png', height: 40),
                            ),

                            Text('MAKE IN INDIA ',style: TextStyle(fontSize: 14.0,fontFamily: AppConfig.FONT_TYPE_BOLD)),

                          ],
                        ),
                      ),

                      SizedBox(height: 20.0),

                      SizedBox(height: 20.0),

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

  openAlertBox() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("Please Login First to access this feature",textAlign:TextAlign.center,
                        style: TextStyle(fontSize: 18.0, color: Colors.black))),

                  Row(
                    children: [

                      Expanded(
                        flex: 5,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                            decoration: BoxDecoration(color: Color(AppConfig.BLUE_COLOR[0])),
                            child: Text("OKAY!", style: TextStyle(color: Colors.white), textAlign: TextAlign.center)))),

                      VerticalDivider(width: 1,color: Colors.white),

                      Expanded(
                        flex: 5,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
                          },
                          child: Container(
                            padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                            decoration: BoxDecoration(color: Color(AppConfig.BLUE_COLOR[0]),),
                            child: Text(
                              "LOGIN",
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),


                ],
              ),
            ),
          );
        });
  }
}
