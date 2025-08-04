
import 'dart:convert';
import 'dart:io';
import 'package:eeslsamparkapp/home_page/guset_home_page.dart';
import 'package:eeslsamparkapp/libary/ars_progress_dialog.dart';
import 'package:eeslsamparkapp/registration/login_pin_screen.dart';
import 'package:eeslsamparkapp/registration/otp_verification.dart';
import 'package:eeslsamparkapp/util/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  FocusNode _focusNode;
  TextEditingController txt_mobile = new TextEditingController(text:'');
  DateTime currentBackPressTime;
  ArsProgressDialog _progressDialog;
  SharedPreferences _sharedPreferences;

  @override
  void initState() {
    super.initState();
    _getDetails();
    //_initPackageInfo();
    // This is initialize the progress dialog
    _progressDialog = ArsProgressDialog(context, blur: 2, backgroundColor: Color(AppConfig.PROGRESS_COLOR[0]),
        animationDuration: Duration(milliseconds: 500));
  }

  _getDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      if(_sharedPreferences.getString(AppConfig.MOBILE_NUMBER) != null) {
        txt_mobile.text = _sharedPreferences.getString(AppConfig.MOBILE_NUMBER);
      }
    });

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
        child: ListView(
          children: <Widget>[

            SizedBox(height: 50.0),

            Container(
                child:Image.asset('assets/image/eesl_logo.png', height: 50)),

            SizedBox(height: 10.0),

            Text("SAMPARK", textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0, color: Color(AppConfig.BLUE_COLOR[1]),
                    fontFamily: AppConfig.FONT_TYPE_BOLD)),

            SizedBox(height: 30.0),

            Text("Login with your mobile number",textAlign: TextAlign.center ,
                style: TextStyle(fontSize: 20.0, color: Color(AppConfig.BLUE_COLOR[1]),
                    fontFamily: AppConfig.FONT_TYPE_BOLD)),

            SizedBox(height: 5.0),

            Text("Please enter your 10-Digit Mobile Number",
                textAlign: TextAlign.center ,style: TextStyle(fontSize: 14.0, fontFamily: AppConfig.FONT_TYPE_REGULAR,
                    color: Colors.black)),

            SizedBox(height: 20.0),

            Row(
              children: <Widget>[

                Expanded(
                  flex: 3,
                  child: Container(
                    color: Color(AppConfig.LIGHT_GRAY_COLOR[0]),
                    height: 49,
                    margin: EdgeInsets.only(left: 10,top: 2,right: 2),
                    child: Row(
                      children: [

                        Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Image.asset('assets/image/india_flag.png')),

                        Text("+91",textAlign: TextAlign.center ,style: TextStyle(fontSize: 16.0,
                            color: Color(AppConfig.BLUE_COLOR[1]),fontFamily: AppConfig.FONT_TYPE_BOLD)),
                      ],
                    ),
                  ),
                ),

                Expanded(flex: 7,
                  child: Padding(
                    padding: const EdgeInsets.only(top:9.0,left: 10.0,right: 20.0),
                    child: TextField(
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                        ],
                        keyboardType: TextInputType.number, textInputAction: TextInputAction.done,
                        controller: txt_mobile, focusNode: _focusNode,
                        maxLength: 10, decoration: new InputDecoration(
                            filled: true, hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                            hintText: "Enter Your Mobile Number", counter: Container(),
                            border: InputBorder.none, fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                        style: TextStyle(fontSize: 20.0, color: Colors.black,fontFamily: AppConfig.FONT_TYPE_REGULAR)
                    ),
                  ),)

              ],
            ),

            SizedBox(height: 20.0),

            Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.only(left: 20, right: 20),
              child: ElevatedButton(
                  child: Text('NEXT'),
                  onPressed: () {
                    if(txt_mobile.text.length!=10 || txt_mobile.text.startsWith(RegExp(r'[0-5]'))) {
                      Fluttertoast.showToast(msg: "Enter Valid Number");
                    } else {
                      _isMobileExist(txt_mobile.text);
                    }
                  }, style: ElevatedButton.styleFrom(
                  primary: Color(AppConfig.BLUE_COLOR[0]),
                  textStyle: TextStyle(fontSize: 18, fontFamily: AppConfig.FONT_TYPE_BOLD))),
            ),

            SizedBox(height: 20.0),

            Text("By Creating an Account you agree to our ",textAlign: TextAlign.center ,
                style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: AppConfig.FONT_TYPE_REGULAR,)),

            SizedBox(height: 5.0),

            Text("Terms of Service & Privacy Policy", textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD)),

            SizedBox(height: 80.0),

            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => GuestMainHomePage()));
              },
              child: Container(
                  height: 40,
                  margin: const EdgeInsets.only(left:30.0,right: 30),
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(AppConfig.BLUE_COLOR[1]))
                  ),
                  child: Center(child: Text('Continue as GUEST',style: TextStyle(fontSize: 18, color:Color(AppConfig.BLUE_COLOR[1]),fontFamily: AppConfig.FONT_TYPE_BOLD)))),
            ),

            SizedBox(height: 50.0),

          ],
        ),
      ),
    );
  }

  _isMobileExist(String mobile_no) async {

    _progressDialog.show();
    print(AppConfig.IS_MOBILE_EXIST+mobile_no+"&IsB2BUser=0");

   // String url='http://172.16.16.43:8082/api/commonapi/IsMobileExist?mobileno=$mobile_no&IsB2BUser=0';

  

    var response = await http.post(Uri.parse(AppConfig.IS_MOBILE_EXIST+mobile_no+"&IsB2BUser=0"),
     headers: {"Accept": "application/json"});
  
    print(response.statusCode);
    var jsonData = json.decode(response.body);
    _progressDialog.dismiss();
    print(jsonData);
    _sharedPreferences.setString(AppConfig.USER_TYPE, "B2C-USER");
    if (jsonData['responseCode'] == AppConfig.NewUser) {
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => OTPVerificationScreen(mobile_no)));
    } else if(jsonData['responseCode'] == AppConfig.SUCESS_CODE) {
      _sharedPreferences.setString(AppConfig.MOBILE_NUMBER, mobile_no);
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => LoginWithPinScreen()));
    } else {
      Fluttertoast.showToast(msg: "Something went wrong, try again later");
    }

  }

  _updateApp(String version) async {

    String device_type = "";
    if(Platform.isIOS) {
      device_type = "IOS";
    } else {
      device_type = "Android";
    }

    var response = await http.Client().get(Uri.parse("${AppConfig.GET_APP_VERSION}$device_type"),
        headers: {"Accept": "application/json"});

    setState(() {
      var jsonData = json.decode(response.body);

      if (jsonData['responseCode'] == AppConfig.SUCESS_CODE) {
           var responseObj = jsonData["responseObj"];

        if (responseObj["devicetype"] == "IOS") {
          var app_version = responseObj["version"];
          int isIOSForceUpdate = responseObj["isIOSForceUpdate"];

          if (app_version != version) {
            _showVersionDialog(isIOSForceUpdate,responseObj["remark"].toString());
          }
        } else {
          var app_version = responseObj["version"];
          int isAndroidForceUpdate = responseObj["isAndroidForceUpdate"];

          if (app_version != version) {
             _showVersionDialog(isAndroidForceUpdate, responseObj["remark"].toString());
          }
        }
      }
    });
  }

  _initPackageInfo() async {

    String projectVersion;
    try {
      projectVersion = await "1";
    } on PlatformException {
      projectVersion = 'Failed to get build number.';
    }

    print("+++++>>>>>>");
    print(projectVersion);

    _updateApp(projectVersion);

  }

  _showVersionDialog(int i,String message) async {

    await showDialog<String>(
      context: context,
      //barrierDismissible: i == 1 ? false : true,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "New Update Available".toUpperCase();
        String btnLabel = "Update Now";

        return WillPopScope(
            onWillPop: () async => false,
            child: Platform.isIOS
                ? CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  ElevatedButton(child: Text(btnLabel),
                      onPressed: () => _launchURL(AppConfig.APP_STORE_URL)),
                ])
                : AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: <Widget>[
                ElevatedButton(
                    child: Text(btnLabel),
                    onPressed: () => _launchURL(AppConfig.PLAY_STORE_URL)),
                i == 0 ? ElevatedButton(child: Text("Later"),
                    onPressed: () => Navigator.pop(context)) : Container()
              ],
            ));
      },
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}