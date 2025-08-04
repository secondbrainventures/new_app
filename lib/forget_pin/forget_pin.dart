import 'dart:convert';

import 'package:eeslsamparkapp/forget_pin/forgot_pin_otp_verify.dart';
import 'package:eeslsamparkapp/libary/ars_progress_dialog.dart';
import 'package:eeslsamparkapp/registration/login_pin_screen.dart';
import 'package:eeslsamparkapp/registration/otp_verification.dart';
import 'package:eeslsamparkapp/util/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPassword> {
  FocusNode _focusNode;
  TextEditingController txt_mobile = new TextEditingController(text: '');
  DateTime currentBackPressTime;
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
                  Text("Lost Your Pin?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Color(AppConfig.BLUE_COLOR[1]),
                          fontFamily: AppConfig.FONT_TYPE_BOLD)),
                  SizedBox(height: 5.0),
                  Text("Provide your mobile number",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: AppConfig.FONT_TYPE_REGULAR,
                          color: Colors.black)),
                  SizedBox(height: 20.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Container(
                          color: Color(AppConfig.LIGHT_GRAY_COLOR[0]),
                          height: 49,
                          margin: EdgeInsets.only(left: 10, top: 2, right: 2),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child:
                                    Image.asset('assets/image/india_flag.png'),
                              ),
                              Text("+91",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Color(AppConfig.BLUE_COLOR[1]),
                                      fontFamily: AppConfig.FONT_TYPE_BOLD)),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 9.0, left: 10.0, right: 20.0),
                          child: TextField(
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9]")),
                              ],
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              controller: txt_mobile,
                              focusNode: _focusNode,
                              maxLength: 10,
                              decoration: new InputDecoration(
                                  filled: true,
                                  hintStyle: TextStyle(
                                      color: Color(AppConfig.BLUE_COLOR[1]),
                                      fontSize: 14),
                                  hintText: "Enter Your Mobile Number",
                                  counter: Container(),
                                  border: InputBorder.none,
                                  fillColor:
                                      Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  fontFamily: AppConfig.FONT_TYPE_REGULAR)),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: ElevatedButton(
                        child: Text('SEND OTP'),
                        onPressed: () {
                          if (txt_mobile.text.length != 10 ||
                              txt_mobile.text
                                  .startsWith(new RegExp(r'[0-5]'))) {
                            Fluttertoast.showToast(msg: "Enter Valid Number");
                          } else {
                            _otpSend(txt_mobile.text);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Color(AppConfig.BLUE_COLOR[0]),
                            textStyle: TextStyle(
                                fontSize: 18,
                                fontFamily: AppConfig.FONT_TYPE_BOLD))),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 20.0),
                    child: Text(
                        "We will send you an OTP to authenticate your number",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontFamily: AppConfig.FONT_TYPE_REGULAR,
                        )),
                  ),
                  SizedBox(height: 5.0),
                  Text("",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Color(AppConfig.BLUE_COLOR[1]),
                          fontFamily: AppConfig.FONT_TYPE_BOLD)),
                  SizedBox(height: 50.0),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _otpSend(String mobile_no) async {
    _progressDialog.show();

    String url = AppConfig.RESEND_OTP + mobile_no + "&SMStype=1";
    print('resend OTp url$url');

    var response = await http.Client()
        .post(Uri.parse(url), headers: {"Accept": "application/json"});
    var jsonData = json.decode(response.body);
    _progressDialog.dismiss();
    print(jsonData);

    if (jsonData['responseCode'] == AppConfig.SUCESS_CODE) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>
              ForgotPinOTPVerification(mobile_no)));
    } else {
      Fluttertoast.showToast(msg: "Something went wrong, try again later");
    }
  }
}
