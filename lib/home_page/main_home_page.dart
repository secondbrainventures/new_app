
import 'dart:io';
import 'dart:ui';
import 'package:eeslsamparkapp/complaint_status/complain_status.dart';
import 'package:eeslsamparkapp/libary/bouncing_button.dart';
import 'package:eeslsamparkapp/libary/web_view_conatiner.dart';
import 'package:eeslsamparkapp/lodge_complaint/lodge_complaint.dart';
import 'package:eeslsamparkapp/registration/login_screen.dart';
import 'package:eeslsamparkapp/side_menu/change_pin.dart';
import 'package:eeslsamparkapp/side_menu/user_profile.dart';
import 'package:eeslsamparkapp/start_up/login_as.dart';
import 'package:eeslsamparkapp/util/app_config.dart';
import 'package:eeslsamparkapp/util/contact_us.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MainHomePage extends StatefulWidget {
  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {

  TextEditingController txt_mobile = new TextEditingController(text:'');
  String currentText = "";
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
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

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        key: _scaffoldKey,

        drawer: Drawer(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Container(height: 50),

              Center(
                  child: Container(
                      child:Image.asset('assets/image/eesl_logo.png', height: 50))),

              SizedBox(height: 5.0),

              Center(
                  child: Text("SAMPARK", textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18.0, color: Color(AppConfig.BLUE_COLOR[1]),
                          fontFamily: AppConfig.FONT_TYPE_BOLD))),

              SizedBox(height: 20.0),

              Divider(height: 1),

              SizedBox(height: 20.0),

              Container(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.only(left:20.0,top: 10,bottom: 10),
                      child: Text(user_name, textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18.0, color: Color(AppConfig.BLUE_COLOR[1]),
                              fontFamily: AppConfig.FONT_TYPE_BOLD)),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(user_email, textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14.0,fontFamily: AppConfig.FONT_TYPE_BOLD,
                              color: Color(AppConfig.BLUE_COLOR[1]))),
                    ),
                  ],
                ),),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => UserProfile()));
                  },
                  child: Row(
                    children: [

                      Expanded(
                          flex: 8,
                          child: Row(
                            children: [

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset('assets/image/person_icon.png', height: 25),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Account',style: TextStyle(fontSize: 15.0,fontFamily: AppConfig.FONT_TYPE_BOLD, color: Color(AppConfig.BLUE_COLOR[1]))),
                              ),
                            ],
                          )),

                      Expanded(
                        flex:1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.arrow_forward_ios_outlined,color: Color(AppConfig.BLUE_COLOR[1]),size: 20),
                        ),
                      ),


                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ChangePin()));
                  },
                  child: Row(
                    children: [

                      Expanded(
                          flex: 8,
                          child: Row(
                            children: [

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:Icon(Icons.lock,color: Color(AppConfig.BLUE_COLOR[1]),size: 25,),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Change Pin',style: TextStyle(fontSize: 15.0,fontFamily: AppConfig.FONT_TYPE_BOLD, color: Color(AppConfig.BLUE_COLOR[1]))),
                              ),
                            ],
                          )),

                      Expanded(
                        flex:1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.arrow_forward_ios_outlined,color: Color(AppConfig.BLUE_COLOR[1]),size: 20,),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    _sharedPreferences.setBool(AppConfig.KEY_IS_LOGGEDIN, false);
                    Navigator.pop(context);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginAsPage()));
                  },
                  child: Row(
                    children: [

                      Expanded(
                          flex:8,
                          child: Row(
                            children: [

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset('assets/image/logout.png', height: 25),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Log Out',style: TextStyle(fontSize: 15.0,fontFamily: AppConfig.FONT_TYPE_BOLD, color: Color(AppConfig.BLUE_COLOR[1]))),
                              ),

                            ],
                          )),

                      Expanded(
                        flex:1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.arrow_forward_ios_outlined,color: Color(AppConfig.BLUE_COLOR[1]),size: 20,),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0,right: 10),
                    child: Container(

                      decoration: BoxDecoration(
                        color: Color(AppConfig.BLUE_COLOR[1]),
                        shape: BoxShape.circle,),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_rounded,
                        ),
                        iconSize: 30,
                        color: Colors.white,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ),

              ),


            ],
          ),
        ),

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
                        onTap: (){
                          if (_scaffoldKey.currentState.isDrawerOpen == false) {
                            _scaffoldKey.currentState.openDrawer();
                          } else {
                            _scaffoldKey.currentState.openEndDrawer();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Image.asset('assets/image/menu_iocn.png', height: 20),
                        ),
                      )),

                  Container(
                      child:Image.asset('assets/image/eesl_logo.png', height: 50)),

                  SizedBox(height: 15.0),

                  Text("SAMPARK", textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18.0, color: Color(AppConfig.BLUE_COLOR[1]),
                          fontFamily: AppConfig.FONT_TYPE_BOLD)),

                  Visibility(
                    visible: false,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text("DASHBOARDS",style: TextStyle(fontSize: 16.0,
                            color: Color(AppConfig.BLUE_COLOR[1]),fontFamily: AppConfig.FONT_TYPE_BOLD))),
                  ),

                  SizedBox(height: 10.0),

                  Visibility(
                    visible: false,
                    child: Row(
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
                  ),

                  SizedBox(height: 20.0),

                  Row(
                    children: [

                      Expanded(
                          flex: 5,
                            child: Container(
                              height: 150,
                              margin: EdgeInsets.only(left: 10, right: 5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [new BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10.0,
                                  ),],
                                  borderRadius: BorderRadius.circular(10)),
                              child: InkWell(
                                onTap: () {
                                  AppConfig.checkInternetConnectivity().then((intenet) {
                                    if (intenet != null && intenet) {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => LodgeComplaint()));
                                    } else {
                                      AppConfig.showAlertDialog(context);
                                    }
                                  });
                                },
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

                            child: Container(
                              height: 150,
                              margin: EdgeInsets.only(left: 5, right: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [new BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10.0,
                                  ),],
                                  borderRadius: BorderRadius.circular(10)),
                              child: InkWell(
                                onTap: () {
                                  AppConfig.checkInternetConnectivity().then((intenet) {
                                    if (intenet != null && intenet) {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ComplainStatusList()));
                                    } else {
                                      AppConfig.showAlertDialog(context);
                                    }
                                  });
                                },
                                child: Column(
                                  children: [

                                    SizedBox(height: 25),

                                    Image(image: AssetImage('assets/image/complint_status_icon.png'),height: 60,),

                                    SizedBox(height: 15),

                                    Padding(
                                      padding: const EdgeInsets.only(left:8.0,right: 8.0),
                                      child: Text("Complaint Status",textAlign: TextAlign.center ,style: TextStyle(fontSize: 16.0,
                                          color: Color(AppConfig.BLUE_COLOR[1]),fontFamily: AppConfig.FONT_TYPE_BOLD)),
                                    ),


                                  ],
                                ),
                              ),
                            ),
                          ),

                    ],
                  ),

                  SizedBox(height: 10.0),

                  Row(
                    children: [

                      Expanded(
                          flex: 5,
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
                              child: InkWell(
                                onTap: () {
                                  AppConfig.checkInternetConnectivity().then((intenet) {
                                    if (intenet != null && intenet) {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => WebViewContainer(AppConfig.NEWS_URL,"NEWS")));
                                    } else {
                                      AppConfig.showAlertDialog(context);
                                    }
                                  });
                                },
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
                            ),
                      ),

                      Expanded(
                        flex: 5,
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
                          child: InkWell(
                            onTap: () async {

                              String url = "";
                              if(Platform.isIOS) {
                                url =  AppConfig.APP_STORE_URL;
                              } else {
                                // url = AppConfig.PLAY_STORE_URL;
                                url = "market://details?id=/details?id=com.eeslsampark.app";
                              }


                              if (await canLaunchUrl(Uri.parse(url))) {
                                await launchUrl(Uri.parse(url));
                              } else {
                                throw 'Could not launch $url';
                              }

                              print(AppConfig.PLAY_STORE_URL);

                            },
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
                        ),
                      ),

                    ],
                  ),

                  SizedBox(height: 10.0),

                  Row(
                    children: [

                      Expanded(
                          flex: 5,
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
                              child: InkWell(
                                onTap: () {
                                  AppConfig.checkInternetConnectivity().then((intenet) {
                                    if (intenet != null && intenet) {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => WebViewContainer(AppConfig.FAQ_URL,"FAQ's")));
                                    } else {
                                      AppConfig.showAlertDialog(context);
                                    }
                                  });
                                },
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
                            ),
                          ),

                      Expanded(
                          flex: 5,
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
                              child: InkWell(
                                onTap: () {
                                  AppConfig.checkInternetConnectivity().then((intenet) {
                                    if (intenet != null && intenet) {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ContactUs()));
                                    } else {
                                      AppConfig.showAlertDialog(context);
                                    }
                                  });
                                },
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
                            ),
                          ),

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
    _sharedPreferences.setBool(AppConfig.KEY_IS_LOGGEDIN, true);
    _sharedPreferences.setString(AppConfig.USER_TYPE, "B2C-USER");
    setState(() {
      user_email = _sharedPreferences.getString(AppConfig.EMAIL_ID);
      user_name = _sharedPreferences.getString(AppConfig.NAME);
    });
  }
}
