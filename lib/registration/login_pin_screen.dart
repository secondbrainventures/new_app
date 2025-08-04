import 'dart:convert';
import 'dart:io';

import 'package:eeslsamparkapp/forget_pin/forget_pin.dart';
import 'package:eeslsamparkapp/home_page/main_home_page.dart';
import 'package:eeslsamparkapp/libary/ars_progress_dialog.dart';
import 'package:eeslsamparkapp/libary/pin_entry_text_field.dart';
import 'package:eeslsamparkapp/util/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:random_string/random_string.dart';
import 'dart:math' show Random;

import '../libary/hb_check_code.dart';

class LoginWithPinScreen extends StatefulWidget {
  @override
  _LoginWithPinScreenState createState() => _LoginWithPinScreenState();
}

class _LoginWithPinScreenState extends State<LoginWithPinScreen> {
  String currentText = "";

  SharedPreferences _sharedPreferences;
  ArsProgressDialog _progressDialog;
  TextEditingController txt_capcha_txt = new TextEditingController();

  String randomGeneratedString = "";

  static const _chars = '1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  @override
  void initState() {
    super.initState();
    randomGeneratedString = getRandomString(4);
    _getDetails();

    // This is initialize the progress dialog
    _progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(AppConfig.PROGRESS_COLOR[0]),
        animationDuration: Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    txt_capcha_txt.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              ListView(
                children: <Widget>[
                  SizedBox(height: 50.0),
                  Container(
                      child: Image.asset('assets/image/eesl_logo.png',
                          height: 50)),
                  SizedBox(height: 10.0),
                  Text("SAMPARK",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Color(AppConfig.BLUE_COLOR[1]),
                          fontFamily: AppConfig.FONT_TYPE_BOLD)),
                  SizedBox(height: 50.0),
                  Text("Login with PIN",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Color(AppConfig.BLUE_COLOR[1]),
                          fontFamily: AppConfig.FONT_TYPE_BOLD)),
                  SizedBox(height: 5.0),
                  Text("PIN/ Password which is created by you.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: AppConfig.FONT_TYPE_REGULAR,
                          color: Colors.black)),
                  SizedBox(height: 15.0),
                  PinEntryTextField(
                    showFieldAsBox: false,
                    fontSize: 25.0,
                    fieldWidth: 60.0,
                    isTextObscure: true,
                    onSubmit: (String pin) {
                      setState(() {
                        currentText = pin;
                      });
                    }, // end onSubmit
                  ),
                  SizedBox(height: 30.0),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          alignment: Alignment.center,
                          child: HBCheckCode(
                            dotCount: 0,

                            backgroundColor: Colors.white,
                            code: randomGeneratedString,
                          )),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            randomGeneratedString = getRandomString(4);
                          });
                        },
                        child: Icon(Icons.refresh),
                      ),
                      SizedBox(width: 10.0),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter the Captcha',
                          ),
                          controller: txt_capcha_txt,
                        ),
                        margin: EdgeInsets.only(bottom: 10),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.0),
                  Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: ElevatedButton(
                        child: Text('SUBMIT'),
                        onPressed: () {

                          print(txt_capcha_txt.text);
                          print(randomGeneratedString);

                          FocusScope.of(context).requestFocus(FocusNode());

                          AppConfig.checkInternetConnectivity().then((intenet) {
                            if (intenet != null && intenet) {
                              if (currentText.isNotEmpty &&
                                  currentText.length == 4 &&
                                  txt_capcha_txt.text ==
                                      randomGeneratedString) {
                                print(txt_capcha_txt.text);
                                _loginWithPIN(currentText);
                              } else if (currentText.isEmpty ||
                                  currentText.length != 4) {
                                Fluttertoast.showToast(
                                    msg: 'Please enter valid Pin');
                              } else if (txt_capcha_txt.text !=
                                  randomGeneratedString) {
                                Fluttertoast.showToast(
                                    msg: "The characters did\'not match");
                              }
                            } else {
                              AppConfig.showAlertDialog(context);
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Color(AppConfig.BLUE_COLOR[0]),
                            textStyle: TextStyle(
                                fontSize: 18,
                                fontFamily: AppConfig.FONT_TYPE_BOLD))),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ForgetPassword()));
                              },
                              child: Text("Forgot Pin Number",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      decoration: TextDecoration.underline,
                                      fontFamily: AppConfig.FONT_TYPE_BOLD,
                                      color: Color(AppConfig.BLUE_COLOR[1])))),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50.0),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    initPackageInfo();

    AppConfig.checkInternetConnectivity().then((intenet) {
      if (intenet != null && intenet) {
      } else {
        AppConfig.showAlertDialog(context);
      }
    });
  }

  _loginWithPIN(String login_pin) async {
    _progressDialog.show();



        String mobile_no = _sharedPreferences.getString(AppConfig.MOBILE_NUMBER);

    String url =
        "${AppConfig.LOGIN_WITH_PIN + "?LoginPin=${AppConfig.encryptPin(login_pin)}&MobileNo=$mobile_no&IsB2BUser=0"}";

    print(url);

    var response = await http.Client()
        .post(Uri.parse(url), headers: {"Accept": "application/json"});
    var jsonData = json.decode(response.body);
    _progressDialog.dismiss();
    print(jsonData);

    if (jsonData['responseCode'] == AppConfig.SUCESS_CODE) {
      var responseToken = jsonData["responseToken"];
      var responseObj = jsonData["responseObj"];
      var token = responseToken["data"];

      try {
        var name = responseObj["name"];
        var email = responseObj["email"];
        var address = responseObj["address"];

        if (name == null) {
          name = "";
        }
        if (email == null) {
          email = "";
        }

        if (address == null) {
          address = "";
        }

        _sharedPreferences.setString(AppConfig.TOKEN, token);
        _sharedPreferences.setString(AppConfig.NAME, name);
        _sharedPreferences.setString(AppConfig.EMAIL_ID, email);
        _sharedPreferences.setString(AppConfig.ADDRESS, address);
      } catch (e) {


      }

      Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => MainHomePage()));
          } else if (jsonData['responseCode'] == AppConfig.NotFound) {
      Fluttertoast.showToast(msg: "${jsonData['responseObj']}");
    } else {
      Fluttertoast.showToast(msg: "Something went wrong, try again later");
    }
 

  }

  _updateApp(String version) async {
    String device_type = "";
    if (Platform.isIOS) {
      device_type = "IOS";
    } else {
      device_type = "Android";
    }

    

    var response = await http.Client().get(
      
        Uri.parse("${AppConfig.GET_APP_VERSION}$device_type"),
        headers: {"Accept": "application/json"});

    setState(() {
      var jsonData = json.decode(response.body);

      if (jsonData['responseCode'] == AppConfig.SUCESS_CODE) {
        var responseObj = jsonData["responseObj"];

        if (responseObj["devicetype"] == "IOS") {
          var app_version = responseObj["version"];
          int isIOSForceUpdate = responseObj["isIOSForceUpdate"];

          if (app_version != version) {
            _showVersionDialog(
                isIOSForceUpdate, responseObj["remark"].toString());
          }
        } else {
          var app_version = responseObj["version"];
          int isAndroidForceUpdate = responseObj["isAndroidForceUpdate"];

          if (app_version != version) {
            _showVersionDialog(
                isAndroidForceUpdate, responseObj["remark"].toString());
          }
        }
      }
    });
  }

  initPackageInfo() async {
    String projectVersion;
    try {
      projectVersion = "1";
    } on PlatformException {
      projectVersion = 'Failed to get build number.';
    }

    print("+++++>>>>>>");
    print(projectVersion);

    _updateApp(projectVersion);
  }

  _showVersionDialog(int i, String message) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: i == 1 ? false : true,
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
                      ElevatedButton(
                            child: Text(btnLabel),
                            onPressed: () =>
                                _launchURL(AppConfig.APP_STORE_URL)),
                      ])
                : AlertDialog(
                    title: Text(title),
                    content: Text(message),
                    actions: <Widget>[
                      ElevatedButton(
                          child: Text(btnLabel),
                          onPressed: () =>
                              _launchURL(AppConfig.PLAY_STORE_URL)),
                      i == 0
                          ? ElevatedButton(
                              child: Text("Later"),
                              onPressed: () => Navigator.pop(context))
                          : Container()
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
