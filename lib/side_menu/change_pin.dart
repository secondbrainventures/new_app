import 'dart:convert';

import 'package:eeslsamparkapp/coprate_customer/buisness_home_page.dart';
import 'package:eeslsamparkapp/home_page/main_home_page.dart';
import 'package:eeslsamparkapp/libary/ars_progress_dialog.dart';
import 'package:eeslsamparkapp/libary/pin_entry_text_field.dart';
import 'package:eeslsamparkapp/util/app_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChangePin extends StatefulWidget {
  @override
  _ChangePinScreenState createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePin> {
  String old_Text = "";
  String new_Text = "";
  String confirm_Text = "";

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
            title: Text("Change Pin",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontFamily: AppConfig.FONT_TYPE_BOLD)),
            centerTitle: true,
            backgroundColor: Color(AppConfig.BLUE_COLOR[0])),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text("Old Pin",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Color(AppConfig.BLUE_COLOR[1]),
                        fontFamily: AppConfig.FONT_TYPE_BOLD)),
              ),
              SizedBox(height: 20.0),
              PinEntryTextField(
                showFieldAsBox: false,
                isTextObscure: true,
                fontSize: 25.0,
                onSubmit: (String pin) {
                  setState(() {
                    old_Text = pin;
                  });
                }, // end onSubmit
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text("New Pin",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Color(AppConfig.BLUE_COLOR[1]),
                        fontFamily: AppConfig.FONT_TYPE_BOLD)),
              ),
              SizedBox(height: 20.0),
              PinEntryTextField(
                showFieldAsBox: false,
                fontSize: 25.0,
                isTextObscure: true,
                onSubmit: (String pin) {
                  setState(() {
                    new_Text = pin;
                  });
                }, // end onSubmit
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text("Confirm Pin",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Color(AppConfig.BLUE_COLOR[1]),
                        fontFamily: AppConfig.FONT_TYPE_BOLD)),
              ),
              SizedBox(height: 20.0),
              PinEntryTextField(
                showFieldAsBox: false,
                fontSize: 25.0,
                isTextObscure: true,
                onSubmit: (String pin) {
                  setState(() {
                    confirm_Text = pin;
                  });
                }, // end onSubmit
              ),
              SizedBox(height: 40.0),
              Container(
                width: double.infinity,
                height: 50,
                margin: EdgeInsets.only(left: 20, right: 20),
                child: ElevatedButton(
                    child: Text('SUBMIT'),
                    onPressed: () {
                      if (old_Text.length < 4) {
                        Fluttertoast.showToast(
                            msg: "Please enter correct Old pin");
                      } else if (new_Text.length < 4) {
                        Fluttertoast.showToast(
                            msg: "Please enter correct New pin");
                      } else if (confirm_Text.length < 4) {
                        Fluttertoast.showToast(
                            msg: "Please enter correct Confirm pin");
                      } else if (new_Text != confirm_Text) {
                        Fluttertoast.showToast(
                            msg: "new pin and confirm pin do not match");
                      } else if (new_Text == old_Text) {
                        Fluttertoast.showToast(
                            msg: "new pin can't be same as old pin");
                      } else {
                        _changePin(old_Text, new_Text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Color(AppConfig.BLUE_COLOR[0]),
                        textStyle: TextStyle(
                            fontSize: 18,
                            fontFamily: AppConfig.FONT_TYPE_BOLD))),
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  _changePin(String old_pin, String newpin) async {
    _progressDialog.show();

    String token = _sharedPreferences.getString(AppConfig.TOKEN);
    String mobile_no = _sharedPreferences.getString(AppConfig.MOBILE_NUMBER);

    String user_type = "";
    if (_sharedPreferences.getString(AppConfig.USER_TYPE) == "B2B-USER") {
      user_type = "1";
    } else {
      user_type = "0";
    }
    


    String url =
        "${AppConfig.CHANGE_PIN + "?MobileNo=$mobile_no&OldPin=${AppConfig.encryptPin(old_pin)}&NewLoginPin=${AppConfig.encryptPin(newpin)}&IsB2BUser=$user_type"}";
    print(url);
     
    
    var response = await http.Client().post(Uri.parse(url), headers: {
      "Accept": "application/json",
      'Authorization': 'Bearer $token'
    });

    var jsonData = json.decode(response.body);
    _progressDialog.dismiss();

    if (jsonData['responseCode'] == AppConfig.SUCESS_CODE) {
      Fluttertoast.showToast(msg: "Pin Changed Successfully");

      if (_sharedPreferences.getString(AppConfig.USER_TYPE) == "B2B-USER") {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => BusinessHomePage()));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => MainHomePage()));
      }
    } else {
      Fluttertoast.showToast(msg: "Incorrect Old Pin");
    }
  }
}
