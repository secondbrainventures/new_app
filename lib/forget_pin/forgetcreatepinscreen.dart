import 'dart:convert';

import 'package:eeslsamparkapp/coprate_customer/business_pin_screen.dart';
import 'package:eeslsamparkapp/libary/ars_progress_dialog.dart';
import 'package:eeslsamparkapp/libary/pin_entry_text_field.dart';
import 'package:eeslsamparkapp/registration/login_pin_screen.dart';
import 'package:eeslsamparkapp/util/app_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ForgetCreatePinScreen extends StatefulWidget {
  @override
  _ForgetCreatePinScreenScreenState createState() =>
      _ForgetCreatePinScreenScreenState();
}

class _ForgetCreatePinScreenScreenState extends State<ForgetCreatePinScreen> {
  String pin_text = "";
  String confrim_pin_text = "";

  String encryptedText="";

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
                  Text("Set Up a PIN",
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
                  SizedBox(height: 30.0),
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
                          if (confrim_pin_text.length < 4) {
                            Fluttertoast.showToast(
                                msg: "Please enter correct New pin");
                          } else if (pin_text.length < 4) {
                            Fluttertoast.showToast(
                                msg: "Please enter correct Confirm pin");
                          } else if (pin_text == confrim_pin_text) {
                            getLoginDetails(pin_text);
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
    _sharedPreferences.setBool(AppConfig.KEY_IS_LOGGEDIN, true);
    print(_sharedPreferences.getBool(AppConfig.KEY_IS_LOGGEDIN));

    String mobile_no = _sharedPreferences.getString(AppConfig.MOBILE_NUMBER);
    _createPIN(mobile_no, pin_text);
  }

  _createPIN(String mobile_no, String login_pin) async {
    _progressDialog.show();

    String token = _sharedPreferences.getString(AppConfig.TOKEN);

    String user_type = "";
    if (_sharedPreferences.getString(AppConfig.USER_TYPE) == "B2B-USER") {
      user_type = "1";
    } else {
      user_type = "0";
    }


    String url =
        "${AppConfig.RESET_PIN + "?MobileNo=$mobile_no&NewLoginPin=${AppConfig.encryptPin(login_pin)}&IsB2BUser=$user_type"}";
    print(login_pin);
    print(url);

    var response = await http.Client().post(Uri.parse(url), headers: {
      "Accept": "application/json",
      'Authorization': 'Bearer $token'
    });


    var jsonData = json.decode(response.body);
    _progressDialog.dismiss();
    print(jsonData);


    if (jsonData['responseCode'] == AppConfig.SUCESS_CODE) {
      if (_sharedPreferences.getString(AppConfig.USER_TYPE) == "B2B-USER") {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                BusinessLoginWithPinScreen(mobile_no)));
      } else {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => LoginWithPinScreen()));
      }
    } else {
      Fluttertoast.showToast(msg: "Something went wrong, try again later");
    }
  }
}
