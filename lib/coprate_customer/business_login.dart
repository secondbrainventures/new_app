import 'dart:convert';
import 'dart:ui';

import 'package:eeslsamparkapp/coprate_customer/business_pin_screen.dart';
import 'package:eeslsamparkapp/coprate_customer/check_registration.dart';
import 'package:eeslsamparkapp/libary/ars_progress_dialog.dart';
import 'package:eeslsamparkapp/model/scheme_status_list_gs.dart';
import 'package:eeslsamparkapp/util/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BusinessLogin extends StatefulWidget {
  @override
  _BusinessLoginState createState() => _BusinessLoginState();
}

class _BusinessLoginState extends State<BusinessLogin> {
  SharedPreferences _sharedPreferences;
  ArsProgressDialog _progressDialog;

  TextEditingController txt_mobile = new TextEditingController();

  getLoginDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();

    getLoginDetails();
    // This is initialize the progress dialog
    _progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(AppConfig.PROGRESS_COLOR[0]),
        animationDuration: Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: AppBar(
                title: Text("Login",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: AppConfig.FONT_TYPE_BOLD)),
                centerTitle: true,
                backgroundColor: Color(AppConfig.BLUE_COLOR[0]))),
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
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
                  SizedBox(height: 30.0),
                  Text("Login with your mobile number",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Color(AppConfig.BLUE_COLOR[1]),
                          fontFamily: AppConfig.FONT_TYPE_BOLD)),
                  SizedBox(height: 5.0),
                  Text("Please enter your 10-Digit Mobile Number",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14.0,
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
                                  child: Image.asset(
                                      'assets/image/india_flag.png')),
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
                  SizedBox(height: 30.0),
                  Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: ElevatedButton(
                        child: Text('NEXT'),
                        onPressed: () {
                          if (txt_mobile.text.length != 10 ||
                              txt_mobile.text.startsWith(RegExp(r'[0-5]'))) {
                            Fluttertoast.showToast(msg: "Enter Valid Number");
                          } else {
                            _isMobileExist(txt_mobile.text);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Color(AppConfig.BLUE_COLOR[0]),
                            textStyle: TextStyle(
                                fontSize: 18,
                                fontFamily: AppConfig.FONT_TYPE_BOLD))),
                  ),
                  SizedBox(height: 50.0),
                  Expanded(
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Padding(
                          padding: EdgeInsets.only(bottom: 20.0),
                          child: Container(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        CheckRegistration()));
                              },
                              child: RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                        color: Color(AppConfig.BLUE_COLOR[1]),
                                        fontFamily: AppConfig.FONT_TYPE_REGULAR,
                                        fontSize: 14),
                                    children: [
                                      TextSpan(text: "Don't have a Account?"),
                                      TextSpan(
                                          text: ' SignUp',
                                          style: TextStyle(
                                              color: Color(
                                                  AppConfig.BLUE_COLOR[1]),
                                              fontFamily:
                                                  AppConfig.FONT_TYPE_BOLD,
                                              fontSize: 16)),
                                    ]),
                              ),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }


//   _isMobileExist(String mobile_no) async {
//     _progressDialog.show();
//     String url = AppConfig.IS_MOBILE_EXIST + mobile_no + "&IsB2BUser=1";
//     print(url);
//     var response = await http.Client()
//         .post(Uri.parse(url), headers: {"Accept": "application/json"});
//     var jsonData = json.decode(response.body);
//     _progressDialog.dismiss();

//     print(jsonData);

//     if (jsonData['responseCode'] == AppConfig.NewUser) {
//       Fluttertoast.showToast(msg: "Your account doesn't exists, Please SignUp");
//     } else if (jsonData['responseCode'] == AppConfig.SUCESS_CODE) {
//       print(jsonData["responseObj"]);
//       print(jsonData["responseObj"].runtimeType);

//       var responseObj = jsonData["responseObj"] as Map;
//       final List<SchemeStatusListGS> status_list = [] ;

//       print('response object is $responseObj');

//       status_list.add(new SchemeStatusListGS.fromJson(responseObj));  


//       // responseObj.forEach((key, value) {


//       //   var responseMap=Map();

//       //   responseMap.addEntries();     
//       //   print("key:$key,value:$value");
//       //   if () {
          
//       //   } else {
//       //   }
        
//       //   });
//       // for (var model in responseObj) {

//       //   status_list.add(new SchemeStatusListGS.fromJson(model));
//       // }

//  //     print(' first item is ${status_list[0].deviceId}');

//       if (status_list.length != 0) {
//         if (status_list[0].isValidB2BUser == true) {
//           Navigator.of(context).push(MaterialPageRoute(
//               builder: (BuildContext context) =>
//                   BusinessLoginWithPinScreen(mobile_no)));
//           _sharedPreferences.setString(AppConfig.USER_TYPE, "B2B-USER");
//         }else if (jsonData['responseToken']=="Mobile Number Exist") {

//           AppConfig.showProcessAlertDialog(context, "You are not valid Corporate Customer"); 
//         }

//          else {
//           AppConfig.showProcessAlertDialog(context, jsonData['responseToken']);
//         }
//       }
//     } else {
//       Fluttertoast.showToast(msg: "Something went wrong, try again later");
//     }
//   }

    _isMobileExist(String mobile_no) async {

    _progressDialog.show();
    String url =  AppConfig.IS_MOBILE_EXIST + mobile_no+"&IsB2BUser=1";
    var response = await http.Client().post(Uri.parse(url), headers: {"Accept": "application/json"});
    var jsonData = json.decode(response.body);
    _progressDialog.dismiss();
   
    print(jsonData);

    if (jsonData['responseCode'] == AppConfig.NewUser) {
      Fluttertoast.showToast(msg: "Your account doesn't exists, Please SignUp");
    } else if(jsonData['responseCode'] == AppConfig.SUCESS_CODE) {
      var responseObj = jsonData["responseObj"] as List;

      final List<SchemeStatusListGS> status_list = [];

      for (var model in responseObj) {
        status_list.add(new SchemeStatusListGS.fromJson(model));
      }

      if(status_list.length != 0) {
        if(status_list[0].isValidB2BUser == true) {
        //   _sharedPreferences.setString(AppConfig.SCHEME_NAME, status_list[0].schemeName);
        //   _sharedPreferences.setString(AppConfig.STATE_NAME, status_list[0].stateName);
        //   _sharedPreferences.setString(AppConfig.DISTRICT_NAME, status_list[0].districtName);
        //   _sharedPreferences.setInt(AppConfig.SCHEME_ID, status_list[0].schemeId);
        //   _sharedPreferences.setInt(AppConfig.SCHEME_ID, status_list[0].schemeId);
        //   _sharedPreferences.setInt(AppConfig.STATE_ID, status_list[0].stateId);
        //   _sharedPreferences.setInt(AppConfig.DISTRICT_ID, status_list[0].districtId);

          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => BusinessLoginWithPinScreen(mobile_no)));
          _sharedPreferences.setString(AppConfig.USER_TYPE, "B2B-USER");   

       } else {
          AppConfig.showProcessAlertDialog(context,jsonData['responseToken']);
        }
      }
    } else {
      Fluttertoast.showToast(msg: "Something went wrong, try again later");
    }

  }


}
