
import 'dart:convert';

import 'package:eeslsamparkapp/forget_pin/forgetcreatepinscreen.dart';
import 'package:eeslsamparkapp/libary/ars_progress_dialog.dart';
import 'package:eeslsamparkapp/libary/bouncing_button.dart';
import 'package:eeslsamparkapp/libary/pin_entry_text_field.dart';
import 'package:eeslsamparkapp/util/app_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPinOTPVerification extends StatefulWidget {

  String mobile_no;
  ForgotPinOTPVerification(this.mobile_no);

  @override
  _ForgotPinOTPVerificationScreenState createState() => _ForgotPinOTPVerificationScreenState(mobile_no);
}

class _ForgotPinOTPVerificationScreenState extends State<ForgotPinOTPVerification> {

  String currentText = "";
  String mobile_no;

  _ForgotPinOTPVerificationScreenState(this.mobile_no);

  ArsProgressDialog _progressDialog;
  SharedPreferences _sharedPreferences;

  @override
  void initState() {
    super.initState();

    _getDetails();
    // This is initialize the progress dialog
    _progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(AppConfig.PROGRESS_COLOR[0]),
        animationDuration: Duration(milliseconds: 500));
  }

  _getDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();
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
                      child: Image.asset(
                          'assets/image/eesl_logo.png', height: 50)),

                  SizedBox(height: 10.0),

                  Text("SAMPARK", textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20.0, color: Color(AppConfig.BLUE_COLOR[1]),
                          fontFamily: AppConfig.FONT_TYPE_BOLD)),

                  SizedBox(height: 50.0),

                  Text(
                      "Mobile number verification", textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20.0,
                          color: Color(AppConfig.BLUE_COLOR[1]),
                          fontFamily: AppConfig.FONT_TYPE_BOLD)),

                  SizedBox(height: 5.0),

                  Text("Enter your OTP code below",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.0,
                          fontFamily: AppConfig.FONT_TYPE_REGULAR,
                          color: Colors.black)),

                  SizedBox(height: 20.0),


                  PinEntryTextField(
                    showFieldAsBox: false,
                    fontSize: 25.0,
                    onSubmit: (String pin) {
                      setState(() {
                        currentText = pin;
                      });

                    }, // end onSubmit
                  ),


                  SizedBox(height: 40.0),


                  Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: ElevatedButton(
                        child: Text('VERIFY'),
                        onPressed: () {
                          if (currentText.length == 4) {
                            FocusScope.of(context).requestFocus();
                            _validateOTP(mobile_no, currentText);
                          } else {
                            Fluttertoast.showToast(msg: "Enter Valid OTP");
                          }
                        }, style: ElevatedButton.styleFrom(
                        primary: Color(AppConfig.BLUE_COLOR[0]),
                        textStyle: TextStyle(fontSize: 18,
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
                                Navigator.pop(context);
                              },
                              child: Text("Edit Phone Number",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14.0,
                                      decoration: TextDecoration.underline,
                                      fontFamily: AppConfig.FONT_TYPE_BOLD,
                                      color: Color(AppConfig.BLUE_COLOR[1])))),
                        ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: Bouncing(
                              onPress: () {
                                _resendOTP(mobile_no);
                              },
                              child: Text(
                                  "Resend OTP", textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14.0,
                                      color: Color(AppConfig.BLUE_COLOR[0]),
                                      decoration: TextDecoration.underline,
                                      fontFamily: AppConfig.FONT_TYPE_BOLD,
                                      fontWeight: FontWeight.bold))),
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

  _validateOTP(String mobile_no, String otp) async {
    _progressDialog.show();

    String url = "${AppConfig.VALIDATE_OTP + "?OTPNumber=$otp&mobileno=$mobile_no"}";
    var response = await http.Client().post(Uri.parse(url), headers: {"Accept": "application/json"});
    var jsonData = json.decode(response.body);
    _progressDialog.dismiss();
    print(jsonData);

    if (jsonData['responseCode'] == AppConfig.SUCESS_CODE) {
      var responseToken = jsonData['responseToken'];
      var data = responseToken['data'];
      _sharedPreferences.setString(AppConfig.MOBILE_NUMBER, mobile_no);
      _sharedPreferences.setString(AppConfig.TOKEN, data);

      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ForgetCreatePinScreen()));
    } else {
      Fluttertoast.showToast(msg: jsonData['responseObj']);
    }
  }

  _resendOTP(String mobile_no) async {
    _progressDialog.show();
    String url = AppConfig.RESEND_OTP + mobile_no+"&SMStype=1";

    var response = await http.Client().post(Uri.parse(url), headers: {"Accept": "application/json"});
    var jsonData = json.decode(response.body);
    _progressDialog.dismiss();
    if (jsonData['responseCode'] == AppConfig.SUCESS_CODE) {
      Fluttertoast.showToast(msg: "OTP Send Successfully");
    } else {
      Fluttertoast.showToast(msg: "Something went wrong, try again later");
    }
  }
}
