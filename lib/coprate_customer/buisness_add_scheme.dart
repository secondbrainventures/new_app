
import 'dart:convert';
import 'dart:core';
import 'dart:ui';

import 'package:eeslsamparkapp/libary/ars_progress_dialog.dart';
import 'package:eeslsamparkapp/model/scheme_status_list_gs.dart';
import 'package:eeslsamparkapp/model/state_gs.dart';
import 'package:eeslsamparkapp/util/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessAddScheme extends StatefulWidget {

  @override
  _BusinessAddSchemeState createState() => _BusinessAddSchemeState();
}

class _BusinessAddSchemeState extends State<BusinessAddScheme> {

  SharedPreferences _sharedPreferences;
  ArsProgressDialog _progressDialog;

  TextEditingController txt_name = new TextEditingController();
  TextEditingController txt_email = new TextEditingController();

  TextEditingController txt_mobile = new TextEditingController(text: "");
  TextEditingController txt_client_name = new TextEditingController(text: "");
  TextEditingController txt_predefined_code = new TextEditingController(text: "");


  String B2BCode_Id = "";

  List<StateResponse> scheme_list = [];
  String scheme;
  int scheme_id;

  List<StateResponse> state_list = [];
  String state;
  int state_id;

  List<StateResponse> district_list = [];
  String district_ids = "";

  List<StateResponse> _selectedvalues = [];
  final _multiSelectKey = GlobalKey<FormFieldState>();

  List<MultiSelectItem<StateResponse>> district_list2 = [];

  getLoginDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _isMobileExist();
    setState(() {
      txt_mobile.text = _sharedPreferences.getString(AppConfig.MOBILE_NUMBER);
      txt_predefined_code.text = _sharedPreferences.getString(AppConfig.UNIQUE_CODE);
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
              title: Text("Add Scheme",
                  style: TextStyle(fontSize: 18, color: Colors.white,fontFamily: AppConfig.FONT_TYPE_BOLD)),
              centerTitle: true, backgroundColor: Color(AppConfig.BLUE_COLOR[0]),
            )),

        body: SafeArea(

          child: ListView(

            children: [

              Padding(
                  padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                    text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(text: 'Name'),
                        TextSpan(text: ' *', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
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
                          TextSpan(text: ' *', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
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
                        TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                      ],
                    ),
                  )),

              Container(
                height: 40,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color(AppConfig.LIGHT_GRAY_COLOR[0]),
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Color(AppConfig.LIGHT_GRAY_COLOR[0]), style: BorderStyle.solid, width: 0.80)),

                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                    underline: SizedBox(),
                    hint: scheme == null ?
                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text('Select Scheme', style: TextStyle(color: Colors.grey, fontSize: 17)))
                        : Padding(padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text(scheme, style: TextStyle(color: Colors.black))),

                    isExpanded: true,
                    iconSize: 30.0,
                    style: TextStyle(color: Colors.black),

                    items: scheme_list.map((
                        StateResponse response) {
                      return DropdownMenuItem<StateResponse>(
                          value: response,
                          child: Text(response.text));
                    },
                    ).toList(),

                    onChanged: (StateResponse response) {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      setState(() {
                        scheme = response.text;
                        scheme_id = response.id;

                        _getAllState(response.id);

                      },
                      );
                    },
                  ),
                ),
              ),

              Padding(padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                    text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(text: 'State '),
                        TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                      ],
                    ),
                  )),

              Container(
                height: 40,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color(AppConfig.LIGHT_GRAY_COLOR[0]),
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Color(AppConfig.LIGHT_GRAY_COLOR[0]), style: BorderStyle.solid, width: 0.80)),

                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                    underline: SizedBox(),
                    hint: state == null ?
                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text('Select State', style: TextStyle(color: Colors.grey, fontSize: 17)))
                        : Padding(padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text(state, style: TextStyle(color: Colors.black))),

                    isExpanded: true,
                    iconSize: 30.0,
                    style: TextStyle(color: Colors.black),

                    items: state_list.map((
                        StateResponse response) {
                      return DropdownMenuItem<StateResponse>(
                          value: response,
                          child: Text(response.text));
                    },
                    ).toList(),

                    onChanged: (StateResponse response) {
                      setState(() {

                        state = response.text;
                        state_id = response.id;

                        _getAllDistrict(state_id);
                      },
                      );
                    },
                  ),
                ),
              ),

              Padding(padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                    text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(text: 'District '),
                        TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                      ],
                    ),
                  )),

              Container(

                  margin: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Color(AppConfig.LIGHT_GRAY_COLOR[0]),
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all( color: Color(AppConfig.LIGHT_GRAY_COLOR[0]), style: BorderStyle.solid, width: 0.80)),

                  child: MultiSelectBottomSheetField<StateResponse>(
                    key: _multiSelectKey,
                    initialChildSize: 0.7,

                    maxChildSize: 0.95,
                    title: Text("Select District"),
                    buttonText: Text("District "),
                    items: district_list2,
                    searchable: true,
                    validator: (values) {
                      if (values == null || values.isEmpty) {
                        return "Required";
                      }

                      return null;
                    },
                    onConfirm: (values) {

                      setState(() {
                        district_ids = "";
                        _selectedvalues.clear();
                        _selectedvalues = values;

                        for(int i = 0; i <_selectedvalues.length; i++) {
                          district_ids = '$district_ids' + '${_selectedvalues[i].id}' + ',';
                        }

                        if (district_ids != null && district_ids.length > 0) {
                          district_ids = district_ids.substring(0, district_ids.length - 1);
                        }
                        print(district_ids);

                      });
                      _multiSelectKey.currentState.validate();
                    },

                    chipDisplay: MultiSelectChipDisplay(
                      chipColor: Color(AppConfig.BLUE_COLOR[0]),
                      textStyle: TextStyle(color: Colors.white),
                      onTap: (item) {
                        setState(() {
                          _selectedvalues.remove(item);

                          district_ids = "";

                          for(int i = 0; i <_selectedvalues.length; i++) {
                            district_ids = '$district_ids' + '${_selectedvalues[i].id}' + ',';
                          }

                          if (district_ids != null && district_ids.length > 0) {
                            district_ids = district_ids.substring(0, district_ids.length - 1);
                          }
                          print(district_ids);

                        });
                        _multiSelectKey.currentState.validate();
                      },
                    ),
                  ),),

              SizedBox(height: 30),

              Center(
                child: ElevatedButton(
                    child: Text('SUBMIT',style : TextStyle(color: Colors.white, fontFamily: AppConfig.FONT_TYPE_BOLD,fontSize: 16.0)),
                    onPressed: () {

                      FocusScope.of(context).requestFocus(new FocusNode());

                      if(txt_name.text.length == 0) {
                        Fluttertoast.showToast(msg: "Please enter Name ");
                      } else if(txt_email.text.length == 0) {
                        Fluttertoast.showToast(msg: "Please enter Email-Id ");
                      } else if(scheme_id == null){
                        Fluttertoast.showToast(msg: "Please select Scheme ");
                      } else if(state_id == null){
                        Fluttertoast.showToast(msg: "Please select state ");
                      } else if(district_ids == null){
                        Fluttertoast.showToast(msg: "Please select District ");
                      } else {
                        _b2bUserProfile();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Color(AppConfig.BLUE_COLOR[0]),
                        padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10))
                ),
              ),




            ],
          ),
        )
    );
  }

  _getSchemeList(String B2BCodeId) async {

    _progressDialog.show();
    var response = await http.Client().get(Uri.parse(AppConfig.GET_SCHEMES + B2BCodeId),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});

    setState(() {

      var jsonData = json.decode(response.body);
      print(jsonData);
      var responseObj = jsonData["responseObj"] as List;

      for (var model in responseObj) {
        scheme_list.add(new StateResponse.fromJson(model));
      }

    });
    _progressDialog.dismiss();
  }

  _getAllState(int id) async {

    _progressDialog.show();

    String url = "${AppConfig.GET_STATES}$B2BCode_Id&SchemeId=$id";
    print(url);

    var response = await http.Client().get(Uri.parse(url),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});

    setState(() {

      state = null;
      state_id = null;

      district_ids = null;

      state_list.clear();
      district_list.clear();
      district_list2.clear();

      var jsonData = json.decode(response.body) ;
      var responseObj = jsonData["responseObj"] as List;

      for (var model in responseObj) {
        state_list.add(new StateResponse.fromJson(model));
      }

    });
    _progressDialog.dismiss();
  }

  _getAllDistrict(int id) async {

    String  url = "${AppConfig.GET_DISTRICTS}$id";

    _progressDialog.show();
    var response = await http.Client().get(Uri.parse(url), headers: {"Accept": "application/json",
      'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});

    setState(() {
      district_ids = null;
      district_list.clear();
      district_list2.clear();

      setState(() {
        var jsonData = json.decode(response.body);
        var responseObj = jsonData["responseObj"] as List;

        for (var model in responseObj) {
          district_list.add(new StateResponse.fromJson(model));
        }

        for (var i = 0; i < district_list.length; i++) {
          district_list2.add(MultiSelectItem(district_list[i], district_list[i].text));
        }

      });
    });
    _progressDialog.dismiss();
  }

  _b2bUserProfile() async {

    _progressDialog.show();

    String token = _sharedPreferences.getString(AppConfig.TOKEN);

    var response = await http.Client().post(Uri.parse(AppConfig.ADD_SCHEME_B2B_USER_PROFILE),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer $token'},
        body: {

          "MobileNo": _sharedPreferences.getString(AppConfig.MOBILE_NUMBER),
          "Name":txt_name.text,
          "email": txt_email.text,
          "IsB2BUser":"true",
          "IsFirstTimeLogin": "0",
          "StateId":state_id.toString(),
          "DistrictId":"1",
          "DistrictIds":district_ids.toString(),
          "SchemeId":scheme_id.toString(),
          "B2BCodeId": B2BCode_Id,
        });

    _progressDialog.dismiss();
    var jsonData = json.decode(response.body);

    print(jsonData);

    if(jsonData["responseCode"] == AppConfig.SUCESS_CODE) {
      AppConfig.showAddSchemeDialog(context, jsonData["responseObj"]);
    } else {
      Fluttertoast.showToast(msg: jsonData["responseObj"]);
    }

  }


  _isMobileExist() async {

    String mobie_number = _sharedPreferences.getString(AppConfig.MOBILE_NUMBER);
    String url =  AppConfig.IS_MOBILE_EXIST + mobie_number +"&IsB2BUser=1";
    var response = await http.Client().post(Uri.parse(url), headers: {"Accept": "application/json"});
    var jsonData = json.decode(response.body);
    final List<SchemeStatusListGS> status_list = [];
    print(jsonData);

    setState(() {
      if (jsonData['responseCode'] == AppConfig.SUCESS_CODE) {
        var responseObj = jsonData["responseObj"] as List;
        for (var model in responseObj) {
          status_list.add(new SchemeStatusListGS.fromJson(model));
        }

        if (status_list.length != 0) {

          txt_name.text = status_list[0].name;
          txt_email.text = status_list[0].email;
          B2BCode_Id = status_list[0].b2BCodeId.toString();
          _getSchemeList(B2BCode_Id);
        }
      }
    });
  }

}