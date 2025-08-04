
import 'dart:convert';

import 'package:eeslsamparkapp/home_page/main_home_page.dart';
import 'package:eeslsamparkapp/libary/ars_progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:eeslsamparkapp/util/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfile> {

  FocusNode _focusNode;
  TextEditingController txt_mobile_no = new TextEditingController(text:'+91 - ');
  TextEditingController txt_email = new TextEditingController(text:'');
  TextEditingController txt_address = new TextEditingController(text:'');
  TextEditingController txt_name = new TextEditingController(text:'');

  bool email = false;
  bool address = false;
  bool name = false;

  SharedPreferences _sharedPreferences;
  ArsProgressDialog _progressDialog;

  _getDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    txt_mobile_no.text = "+91-${_sharedPreferences.getString(AppConfig.MOBILE_NUMBER)}";

    _getUserProfile();
  }

  @override
  void initState() {
    super.initState();
    _getDetails();
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
              title: Text("Profile",
                  style: TextStyle(fontSize: 18, color: Colors.white,fontFamily: AppConfig.FONT_TYPE_BOLD)),
              centerTitle: true, backgroundColor: Color(AppConfig.BLUE_COLOR[0]),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                onPressed: () {

                    setState(() {

                      email = true;
                      address = true;
                      name = true;

                    });

                },
              )
            ],

          )),

      body: SafeArea(
        child:Column(
          children: <Widget>[

            SizedBox(height: 20.0),

            Row(
              children: [

                Expanded(
                  flex:1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5,top: 20.0),
                    child: Image.asset('assets/image/person_icon.png', height: 25),
                  ),),

                Expanded(
                    flex:9,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, right:25.0,left: 8),
                      child: TextFormField(
                          enabled: name,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,&#-@._-]")),
                          ],
                          decoration: new InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 5),
                              labelStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                              labelText: "Full Name", counter: Container(),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue)) ,
                              border: UnderlineInputBorder(
                              )
                          ),
                          controller: txt_name,
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontSize: 18.0, color: Colors.black,fontFamily: AppConfig.FONT_TYPE_REGULAR)
                      ),
                    ))
              ],
            ),

            Row(
              children: [

                Expanded(
                  flex:1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5,top: 20.0),
                    child: Image.asset('assets/image/mail_icon.png', height: 18),
                  ),),

                Expanded(
                    flex:9,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, right:25.0,left: 8),
                      child: TextFormField(
                          controller: txt_email,
                          enabled: email,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,&#-@._-]")),
                          ],
                          decoration: new InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 5),
                              labelStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                              labelText: "Email ID", counter: Container(),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue)) ,
                              border: UnderlineInputBorder(
                              )
                          ),
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontSize: 18.0, color: Colors.black,fontFamily: AppConfig.FONT_TYPE_REGULAR)
                      ),
                    ))
              ],
            ),

            Row(

              children: [

                Expanded(
                  flex:1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5,top: 20.0),
                    child: Image.asset('assets/image/phone_icon.png', height: 25),
                  ),),

                Expanded(
                  flex: 9,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, right:25.0,left: 8),
                    child: TextFormField(
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,&#-@._-]")),
                        ],
                        controller: txt_mobile_no,
                        focusNode: _focusNode,
                        enabled: false,
                        decoration: new InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 5),
                            labelStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                            labelText: "Mobile Number", counter: Container(),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue)) ,
                            border: UnderlineInputBorder(
                            )
                        ),
                        style: TextStyle(fontSize: 18.0, color: Colors.black,fontFamily: AppConfig.FONT_TYPE_REGULAR)
                    ),
                  ),
                )

              ],
            ),

            Row(

              children: [

                Expanded(
                  flex:1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5,top: 20.0),
                    child: Image.asset('assets/image/home_icon.png', height: 25),
                  ),),

                Expanded(
                  flex: 9,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, right:25.0,left: 8),
                    child: TextFormField(
                        textInputAction: TextInputAction.done,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,&#-@._-]")),
                        ],
                        controller: txt_address,
                        focusNode: _focusNode,
                        enabled: address,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: new InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 5),
                            labelStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                            labelText: "Address", counter: Container(),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue)) ,
                            border: UnderlineInputBorder(
                            )
                        ),
                        style: TextStyle(fontSize: 18.0, color: Colors.black,fontFamily: AppConfig.FONT_TYPE_REGULAR)
                    ),
                  ),
                )

              ],
            ),

            SizedBox(height: 40.0),

           email == true ?  Container(
                width: double.infinity,
                height: 50,
                margin: EdgeInsets.only(left: 20, right: 20),
                child: ElevatedButton(
                    child: Text('SAVE'),
                    style: ElevatedButton.styleFrom(
                        primary: Color(AppConfig.BLUE_COLOR[0]),
                        textStyle: TextStyle(fontSize: 18, fontFamily: AppConfig.FONT_TYPE_BOLD)),
                    onPressed: () {
                      if (txt_email.text.length == 0) {
                          Fluttertoast.showToast(msg: "Please enter valid email id");
                        } else if (txt_name.text.length == 0) {
                          Fluttertoast.showToast(msg: "Please enter Name ");
                        } else if (txt_address.text.length == 0) {
                          Fluttertoast.showToast(msg: "Please enter Address ");
                        } else {

                        var email = txt_email.text;
                        bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);

                        if(emailValid) {
                          _createProfile(txt_name.text, txt_address.text, txt_email.text, "0", "0");
                        } else {
                          Fluttertoast.showToast(msg: "Email id not valid");
                        }


                        }
                    }

                )) : Container(),

            SizedBox(height: 20.0),

          ],
        ),
      ),
    );
  }


  _createProfile(String name, String address, String email, String lat, String long) async {
    _progressDialog.show();

    String token = _sharedPreferences.getString(AppConfig.TOKEN);
    String mobile_no = _sharedPreferences.getString(AppConfig.MOBILE_NUMBER);
    String url = "${AppConfig.CREATE_PROFILE + "?MobileNo=$mobile_no&Name=$name&Address=$address&Email=$email&Let=$lat&longi=$long&IsB2BUser=0"}";

    var response = await http.Client().post(Uri.parse(url), headers: {"Accept": "application/json",'Authorization': 'Bearer $token'});
    var jsonData = json.decode(response.body);
    _progressDialog.dismiss();
    print(jsonData);

    if (jsonData['responseCode'] == AppConfig.SUCESS_CODE) {
      Fluttertoast.showToast(msg: "Profile Update Successfully");
      _sharedPreferences.setString(AppConfig.EMAIL_ID, email);
      _sharedPreferences.setString(AppConfig.NAME, name);
      _sharedPreferences.setString(AppConfig.ADDRESS, address);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => MainHomePage()));
    } else {
      Fluttertoast.showToast(msg: "Something went wrong, try again later");
    }
  }

  _getUserProfile() async {
    _progressDialog.show();

    String token = _sharedPreferences.getString(AppConfig.TOKEN);
    String mobile_no = _sharedPreferences.getString(AppConfig.MOBILE_NUMBER);
    String url = AppConfig.GET_USER_PROFILE + mobile_no+"&IsB2BUser=0";
    var response = await http.Client().get(Uri.parse(url), headers: {"Accept": "application/json",'Authorization': 'Bearer $token'});
    var jsonData = json.decode(response.body);
    _progressDialog.dismiss();
    print(jsonData);
    if (jsonData['responseCode'] == AppConfig.SUCESS_CODE) {
      var responseObj = jsonData['responseObj'];
      setState(() {
          txt_name.text = responseObj['name'];
          txt_address.text = responseObj['address'];
          txt_email.text = responseObj['email'];
        });

    } else {
      Fluttertoast.showToast(msg: "Something went wrong, try again later");
    }
  }
}
