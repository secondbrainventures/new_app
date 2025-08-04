import 'dart:convert';
import 'dart:ui';
import 'package:eeslsamparkapp/coprate_customer/business_otp_verification.dart';
import 'package:eeslsamparkapp/libary/ars_progress_dialog.dart';
import 'package:eeslsamparkapp/util/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CheckRegistration extends StatefulWidget {
  @override
  _CheckRegistrationState createState() => _CheckRegistrationState();
}


class _CheckRegistrationState extends State<CheckRegistration> {

  ArsProgressDialog _progressDialog;

  TextEditingController txt_mobile = new TextEditingController();
  TextEditingController txt_unique_code = new TextEditingController();

  bool flag =false;

  @override
  void initState() {
    super.initState();

    // This is initialize the progress dialog
    _progressDialog = ArsProgressDialog(context, blur: 2,
        backgroundColor: Color(AppConfig.PROGRESS_COLOR[0]),
        animationDuration: Duration(milliseconds: 500));

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: AppBar(
                title: Text("Register",
                    style: TextStyle(fontSize: 18, color: Colors.white,fontFamily : AppConfig.FONT_TYPE_BOLD)),
                centerTitle: true, backgroundColor: Color(AppConfig.BLUE_COLOR[0]))),

        body: SafeArea(
          child: ListView(

            children: [

              SizedBox(height: 30.0),

              Container(
                  child:Image.asset('assets/image/eesl_logo.png', height: 50)),

              SizedBox(height: 10.0),

              Text("SAMPARK", textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0, color: Color(AppConfig.BLUE_COLOR[1]),
                      fontFamily: AppConfig.FONT_TYPE_BOLD)),

              SizedBox(height: 30.0),


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

                          Text(" +91",textAlign: TextAlign.center ,style: TextStyle(fontSize: 16.0,
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
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          controller: txt_mobile,
                          maxLength: 10,
                          decoration: new InputDecoration(
                              filled: true,
                              hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                              hintText: "Enter Your Mobile Number", counter: Container(),
                              border: InputBorder.none,
                              fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                          style: TextStyle(fontSize: 20.0, color: Colors.black,fontFamily: AppConfig.FONT_TYPE_REGULAR)
                      ),
                    ),)
                ],
              ),



              Padding(
                  padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                      text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                        children: <TextSpan>[
                          TextSpan(text: 'Enter Predefined code '),
                        ],
                      )
                  )),

              Container(
                  margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                  child: TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp("[a-z A-Z 0-9 -_@#.]")),
                      ],
                      controller: txt_unique_code,
                      decoration: InputDecoration(
                          hintText: 'Enter Your Enter Predefined code.', counter: Container(),
                          contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                          filled: true,
                          hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                          border: InputBorder.none,
                          fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                      style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))),

              SizedBox(height: 30),

              Container(
                width: double.infinity,
                height: 50,
                margin: EdgeInsets.only(left: 20, right: 20),
                child: ElevatedButton(
                    child: Text('SEND OTP',style : TextStyle(color: Colors.white, fontFamily: AppConfig.FONT_TYPE_BOLD,fontSize: 16.0)),
                    onPressed: () {

                      FocusScope.of(context).requestFocus(new FocusNode());

                      if(txt_mobile.text.length == 0) {
                        Fluttertoast.showToast(msg: "Please enter the Mobile Number");
                      } else if(txt_unique_code.text.length != 0) {
                        _isMobileExist(txt_mobile.text);
                      } else {
                        Fluttertoast.showToast(msg: "Please enter the unique code");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Color(AppConfig.BLUE_COLOR[0]),
                        padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10))
                ),
              ),

              SizedBox(height: 20.0),

              Text("By Creating an Account you agree to our ",textAlign: TextAlign.center ,
                  style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: AppConfig.FONT_TYPE_REGULAR,)),

              SizedBox(height: 5.0),

              Text("Terms of Service & Privacy Policy", textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, color: Color(AppConfig.BLUE_COLOR[1]),
                      fontFamily: AppConfig.FONT_TYPE_BOLD)),


            ],
          ),
        )
    );
  }

  _validateB2BCode(String id) async {

    // _progressDialog.show();
    var response = await http.Client().get(Uri.parse(AppConfig.VALIDATE_B2B_CODE+id),
        headers: {"Accept": "application/json"});

    setState(() {

      var jsonData = json.decode(response.body);
      var responseCode = jsonData["responseCode"];

      print(jsonData);

      if(responseCode == AppConfig.SUCESS_CODE) {
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => BusinessOTPVerificationScreen(txt_mobile.text,txt_unique_code.text)));
        _sendOTP(txt_mobile.text);
      } else {
        _progressDialog.dismiss();
        Fluttertoast.showToast(msg: "Unique code is incorrect ");
      }



    });
  }

  _sendOTP(String mobile_no) async {
    // _progressDialog.show();
    String url = AppConfig.RESEND_OTP + mobile_no+"&SMStype=0";

    var response = await http.Client().post(Uri.parse(url), headers: {"Accept": "application/json"});
    var jsonData = json.decode(response.body);
    _progressDialog.dismiss();
    print(jsonData);
    if (jsonData['responseCode'] == AppConfig.SUCESS_CODE) {
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => BusinessOTPVerificationScreen(txt_mobile.text,txt_unique_code.text)));
      Fluttertoast.showToast(msg: "OTP Send Successfully");
      _progressDialog.dismiss();
    } else {
      Fluttertoast.showToast(msg: jsonData['responseObj']);
      _progressDialog.dismiss();
    }
  }

  _isMobileExist(String mobile_no) async {

    _progressDialog.show();
    var response = await http.Client().post(Uri.parse(AppConfig.IS_MOBILE_EXIST + mobile_no+"&IsB2BUser=1"), headers: {"Accept": "application/json"});
    var jsonData = json.decode(response.body);
    _progressDialog.dismiss();
    print(jsonData);

    if (jsonData['responseCode'] == AppConfig.NewUser) {
      _validateB2BCode(txt_unique_code.text);
    } else if(jsonData['responseCode'] == AppConfig.SUCESS_CODE) {
      AppConfig.showProcessAlertDialog(context,jsonData['responseToken']);
      _progressDialog.dismiss();
    } else {
      Fluttertoast.showToast(msg: "Something went wrong, try again later");
    }

  }
}