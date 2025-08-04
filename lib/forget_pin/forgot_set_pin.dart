import 'dart:convert';
import 'dart:io';

import 'package:eeslsamparkapp/libary/ars_progress_dialog.dart';
import 'package:eeslsamparkapp/libary/pin_entry_text_field.dart';
import 'package:eeslsamparkapp/registration/login_pin_screen.dart';
import 'package:eeslsamparkapp/side_menu/create_profile.dart';
import 'package:eeslsamparkapp/util/app_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPinSetScreen extends StatefulWidget {
  @override
  _ForgotPinSetScreenState createState() => _ForgotPinSetScreenState();
}

class _ForgotPinSetScreenState extends State<ForgotPinSetScreen> {
  String pin_text = "";
  String confrim_pin_text = "";

  SharedPreferences _sharedPreferences;
  ArsProgressDialog _progressDialog;

  @override
  void initState() {
    super.initState();

    // This is initialize the progress dialog
    _progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(AppConfig.PROGRESS_COLOR[0]),
        animationDuration: Duration(milliseconds: 500));
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
                  Text("Set Up a New PIN",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Color(AppConfig.BLUE_COLOR[1]),
                          fontFamily: AppConfig.FONT_TYPE_BOLD)),
                  SizedBox(height: 5.0),
                  Text("Create a PIN to use in place of password.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: AppConfig.FONT_TYPE_REGULAR,
                          color: Colors.black)),
                  SizedBox(height: 30.0),
                  Text("Enter PIN",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Color(AppConfig.BLUE_COLOR[1]),
                          fontFamily: AppConfig.FONT_TYPE_BOLD)),
                  PinEntryTextField(
                    showFieldAsBox: false,
                    isTextObscure: true,
                    fontSize: 25.0,
                    onSubmit: (String pin) {
                      setState(() {
                        pin_text = pin;
                      });
                    }, // end onSubmit
                  ),
                  SizedBox(height: 10.0),
                  Text("Confirm PIN",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Color(AppConfig.BLUE_COLOR[1]),
                          fontFamily: AppConfig.FONT_TYPE_BOLD)),
                  PinEntryTextField(
                    showFieldAsBox: false,
                    isTextObscure: true,
                    fontSize: 25.0,
                    onSubmit: (String pin) {
                      setState(() {
                        confrim_pin_text = pin;
                      });
                    }, // end onSubmit
                  ),
                  SizedBox(height: 30.0),
                  Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: ElevatedButton(
                        child: Text('SUBMIT'),
                        onPressed: () {
                          if (pin_text == confrim_pin_text) {
                            // getLoginDetails(pin_text);
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        LoginWithPinScreen()));
                          } else {
                            Fluttertoast.showToast(
                                msg: "Pin and confirm pin not match");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Color(AppConfig.BLUE_COLOR[0]),
                            textStyle: TextStyle(
                                fontSize: 18,
                                fontFamily: AppConfig.FONT_TYPE_BOLD))),
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

  getLoginDetails(String pin_text) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    String mobile_no = _sharedPreferences.getString(AppConfig.MOBILE_NUMBER);
    String device_type = "";

    if ((Platform.isIOS)) {
      device_type = "iOS";
    } else {
      device_type = "Android";
    }

    String deviceId = await _getId();

    _createPIN(mobile_no, pin_text, device_type, deviceId);
  }

  Future<String> _getId() async {
    return "123";
  }

  _createPIN(String mobile_no, String login_pin, String device_type,
      String device_id) async {
    _progressDialog.show();

    String token = _sharedPreferences.getString(AppConfig.TOKEN);

    String user_type = "";
    if (_sharedPreferences.getString(AppConfig.USER_TYPE) == "B2B-USER") {
      user_type = "1";
    } else {
      user_type = "0";
    }

    String url =
        "${AppConfig.CREATE_PIN + "?MobileNo=$mobile_no&LoginPin=$login_pin&DeviceId=$device_id&DeviceType=$device_type&IsB2BUser=$user_type"}";
    var response = await http.Client().post(Uri.parse(url), headers: {
      "Accept": "application/json",
      'Authorization': 'Bearer $token'
    });
    var jsonData = json.decode(response.body);
    _progressDialog.dismiss();
    print(jsonData);

    if (jsonData['responseCode'] == AppConfig.SUCESS_CODE) {
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => CreateProfile()));
    } else if (jsonData['responseCode'] == AppConfig.NotFound) {
      Fluttertoast.showToast(msg: "your are not register, please sign up first");
    } else {
      Fluttertoast.showToast(msg: "please try other pin");
    }
  }
}
