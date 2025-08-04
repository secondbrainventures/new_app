
import 'dart:convert';
import 'dart:ui';

import 'package:eeslsamparkapp/coprate_customer/buisness_add_scheme.dart';
import 'package:eeslsamparkapp/libary/ars_progress_dialog.dart';
import 'package:eeslsamparkapp/model/scheme_status_list_gs.dart';
import 'package:eeslsamparkapp/util/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BusinessUserProfile extends StatefulWidget {

  @override
  _BusinessUserProfileState createState() => _BusinessUserProfileState();
}


class _BusinessUserProfileState extends State<BusinessUserProfile> {

  SharedPreferences _sharedPreferences;
  ArsProgressDialog _progressDialog;

  TextEditingController txt_name = new TextEditingController();
  TextEditingController txt_email = new TextEditingController();

  TextEditingController txt_mobile = new TextEditingController(text: "");
  TextEditingController txt_client_name = new TextEditingController(text: "");
  TextEditingController txt_predefined_code = new TextEditingController(text: "");
  TextEditingController txt_scheme = new TextEditingController(text: "");
  TextEditingController txt_state = new TextEditingController(text: "");

  String B2BCode_Id = "";

  String scheme;
  int scheme_id;

  String state;
  int state_id;

  String district;
  int district_id;

  getLoginDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _isMobileExist();
    setState(() {
      txt_mobile.text = _sharedPreferences.getString(AppConfig.MOBILE_NUMBER);
      txt_client_name.text = _sharedPreferences.getString(AppConfig.CLIENT_NAME);
    });
  }

  @override
  void initState() {
    super.initState();

    getLoginDetails();
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
              title: Text("Your Profile",
                  style: TextStyle(fontSize: 18, color: Colors.white,fontFamily: AppConfig.FONT_TYPE_BOLD)),
              centerTitle: true, backgroundColor: Color(AppConfig.BLUE_COLOR[0]),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: () {

                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => BusinessAddScheme()));
                  },
                )
              ],

            )),

        body: SafeArea(

          child: ListView(

            children: [

              Padding(
                  padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                    text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(text: 'Mobile Number'),
                      ],
                    ),
                  )),

              Container(
                margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                child: TextFormField(
                    controller: txt_mobile,
                    enabled: false,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0), filled: true,
                        hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                        border: InputBorder.none, fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                    style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black)),
              ),

              Padding(
                  padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                    text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(text: 'Predefined Code'),
                      ],
                    ),
                  )),

              Container(
                margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                child: TextFormField(
                    controller: txt_predefined_code,
                    enabled: false,
                    decoration: InputDecoration(

                        contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0), filled: true,
                        hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                        border: InputBorder.none, fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                    style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black)),
              ),

              Padding(
                  padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                    text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(text: 'Client Name'),
                      ],
                    ),
                  )),

              Container(
                margin: EdgeInsets.only(left: 10, right: 10,top: 10),

                child: TextFormField(
                    controller: txt_client_name,
                    enabled: false,
                    decoration: InputDecoration(

                        contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0), filled: true,
                        hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                        border: InputBorder.none, fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                    style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black)),
              ),

              Padding(
                  padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                    text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(text: 'Name'),
                        TextSpan(text: '', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                      ],
                    ),
                  )),

              Container(
                  margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                  child: TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp("[a-z A-Z 0-9]")),
                      ],
                      controller: txt_name,
                      decoration: InputDecoration(
                          hintText: 'Your Enter Name', counter: Container(),
                          contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                          filled: true,
                          enabled: false,
                          hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                          border: InputBorder.none,
                          fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                      style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))),

              Padding(
                  padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                      text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                        children: <TextSpan>[
                          TextSpan(text: 'Email'),
                          TextSpan(text: '', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                        ],
                      )
                  )),

              Container(
                  margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                  child: TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp("[a-z A-Z 0-9 -_@#.]")),
                      ],
                      controller: txt_email,
                      enabled: false,
                      decoration: InputDecoration(
                          hintText: 'Enter Your Email Id', counter: Container(),
                          contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                          filled: true,
                          hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                          border: InputBorder.none,
                          fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                      style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))),


              Padding(padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                    text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(text: 'Scheme '),
                        TextSpan(text: '', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                      ],
                    ),
                  )),

              Container(
                margin: EdgeInsets.only(left: 10, right: 10,top: 10),

                child: TextFormField(
                    controller: txt_scheme,
                    enabled: false,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0), filled: true,
                        hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                        border: InputBorder.none, fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                    style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black)),
              ),

              Padding(padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                    text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(text: 'State '),
                        TextSpan(text: '', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                      ],
                    ),
                  )),


              Container(
                margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                child: TextFormField(
                    controller: txt_state,
                    enabled: false,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0), filled: true,
                        hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                        border: InputBorder.none, fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                    style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black)),
              ),



              SizedBox(height: 30),


            ],
          ),
        )
    );
  }

  _isMobileExist() async {
    _progressDialog.show();

    String mobie_number = _sharedPreferences.getString(AppConfig.MOBILE_NUMBER);
    String url =  AppConfig.IS_MOBILE_EXIST + mobie_number +"&IsB2BUser=1";
    var response = await http.Client().post(Uri.parse(url), headers: {"Accept": "application/json"});
    var jsonData = json.decode(response.body);
    final List<SchemeStatusListGS> status_list = [];

    print(jsonData);
    _progressDialog.dismiss();
    setState(() {
      if (jsonData['responseCode'] == AppConfig.SUCESS_CODE) {
        var responseObj = jsonData["responseObj"] as List;
        for (var model in responseObj) {
          status_list.add(new SchemeStatusListGS.fromJson(model));
        }

        if (status_list.length != 0) {

          txt_predefined_code.text = status_list[0].uniqueCode;
          txt_client_name.text = status_list[0].clientName;
          txt_name.text = status_list[0].name;
          txt_email.text = status_list[0].email;
          txt_scheme.text = status_list[0].schemeName;
          scheme_id = status_list[0].schemeId;
          txt_state.text = status_list[0].stateName;
          state_id = status_list[0].stateId;

          B2BCode_Id = status_list[0].b2BCodeId.toString();

        }
      }
    });
  }
}