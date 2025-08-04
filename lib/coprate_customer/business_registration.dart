
import 'dart:convert';
import 'dart:ui';
import 'package:eeslsamparkapp/libary/ars_progress_dialog.dart';
import 'package:eeslsamparkapp/model/scheme_list_gs.dart';
import 'package:eeslsamparkapp/model/state_gs.dart';
import 'package:eeslsamparkapp/util/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BusinessRegistration extends StatefulWidget {

  String B2BCodeId = "";

  BusinessRegistration(this.B2BCodeId);

  @override
  _BusinessRegistrationState createState() => _BusinessRegistrationState(B2BCodeId);
}


class _BusinessRegistrationState extends State<BusinessRegistration> {

  String B2BCodeId = "";
  _BusinessRegistrationState(this.B2BCodeId);

  SharedPreferences _sharedPreferences;
  ArsProgressDialog _progressDialog;

  TextEditingController txt_name = new TextEditingController();
  TextEditingController txt_email = new TextEditingController();

  TextEditingController txt_mobile = new TextEditingController(text: "");
  TextEditingController txt_client_name = new TextEditingController(text: "");
  TextEditingController txt_predefined_code = new TextEditingController(text: "");
  TextEditingController schemeController = new TextEditingController(text: "");
  TextEditingController stateController = new TextEditingController(text: "");
  TextEditingController districtController = new TextEditingController(text: "");


  bool _isdistrictVisible = true;

  List<StateResponse> scheme_list = [];
  String scheme;
  int scheme_id;

  List<StateResponse> state_list = [];
  String state;
  int state_id;

  List<StateResponse> district_list = [];
  String district;
  int district_id;

  GlobalKey _toolTipKey = GlobalKey();
  GlobalKey _toolTipKey_name = GlobalKey();
  GlobalKey _toolTipKey_predefined_code = GlobalKey();

  getLoginDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _getSchemeList();

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
                title: Text("Complete Your Profile",
                    style: TextStyle(fontSize: 18, color: Colors.white,fontFamily : AppConfig.FONT_TYPE_BOLD)),
                centerTitle: true, backgroundColor: Color(AppConfig.BLUE_COLOR[0]))),

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
                  child: InkWell(
                    onTap: () {
                      final dynamic tooltip = _toolTipKey.currentState;
                      tooltip.ensureTooltipVisible();
                    },
                    child: TextFormField(
                        controller: txt_mobile,
                        enabled: false,
                        decoration: InputDecoration(
                          suffixIcon:Tooltip(
                              key: _toolTipKey,
                              child: Icon(Icons.info_outline_rounded),
                              message: "This is non-editable",
                              decoration: BoxDecoration(color: Color(AppConfig.BLUE_COLOR[1]),
                                borderRadius: BorderRadius.circular(10), )),
                            contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0), filled: true,
                            hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                            border: InputBorder.none, fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                            style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black)),
                  )),

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
                  child: InkWell(
                    onTap: () {
                      final dynamic tooltip = _toolTipKey_predefined_code.currentState;
                      tooltip.ensureTooltipVisible();
                    },
                    child: TextFormField(
                        controller: txt_predefined_code,
                        enabled: false,
                        decoration: InputDecoration(
                            suffixIcon:Tooltip(
                                key: _toolTipKey_predefined_code,
                                child: Icon(Icons.info_outline_rounded),
                                message: "This is non-editable",
                                decoration: BoxDecoration(color: Color(AppConfig.BLUE_COLOR[1]),
                                  borderRadius: BorderRadius.circular(10), )),
                            contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0), filled: true,
                            hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                            border: InputBorder.none, fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                        style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black)),
                  )),

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
                  child: InkWell(
                    onTap: () {
                      final dynamic tooltip = _toolTipKey_name.currentState;
                      tooltip.ensureTooltipVisible();
                    },
                    child: TextFormField(
                        controller: txt_client_name,
                        enabled: false,
                        decoration: InputDecoration(
                            suffixIcon:Tooltip(
                                key: _toolTipKey_name,
                                child: Icon(Icons.info_outline_rounded),
                                message: "This is non-editable",
                                decoration: BoxDecoration(color: Color(AppConfig.BLUE_COLOR[1]),
                                  borderRadius: BorderRadius.circular(10), )),
                            contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0), filled: true,
                            hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                            border: InputBorder.none, fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                        style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black)),
                  )),

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

                        if(response.id == 9) {
                          _isdistrictVisible = false;
                        } else {
                          _isdistrictVisible = true;
                        }

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

              Visibility(
                  visible: _isdistrictVisible,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

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
                        height: 40,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Color(AppConfig.LIGHT_GRAY_COLOR[0]),
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all( color: Color(AppConfig.LIGHT_GRAY_COLOR[0]), style: BorderStyle.solid, width: 0.80)),

                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton(
                            underline: SizedBox(),
                            hint: district == null ?
                            Padding(
                                padding: EdgeInsets.only(left: 5, right: 10),
                                child: Text('Select District', style: TextStyle(color: Colors.grey, fontSize: 17)))
                                : Padding(padding: EdgeInsets.only(left: 5, right: 10),
                                child: Text(district, style: TextStyle(color: Colors.black))),

                            isExpanded: true,
                            iconSize: 30.0,
                            style: TextStyle(color: Colors.black),

                            items: district_list.map((
                                StateResponse response) {
                              return DropdownMenuItem<StateResponse>(
                                  value: response,
                                  child: Text(response.text));
                            },
                            ).toList(),

                            onChanged: (StateResponse response) {
                              setState(() {
                                district = response.text;
                                district_id = response.id;
                              },
                              );
                            },
                          ),
                        ),
                      ),

                    ],
                  )),

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
                      }else if(state_id == null){
                        Fluttertoast.showToast(msg: "Please select state ");
                      } else if(district_id == null){
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

  _getSchemeList() async {

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

    String url = "${AppConfig.GET_STATES}$B2BCodeId&SchemeId=$id";
    print(url);

    var response = await http.Client().get(Uri.parse(url),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});

    setState(() {

      state = null;
      state_id = null;

      district_id = null;
      district = null;

      state_list.clear();
      district_list.clear();

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
    print(url);
    print(id);

    _progressDialog.show();
    var response = await http.Client().get(Uri.parse(url), headers: {"Accept": "application/json",
      'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});

    setState(() {
      district = null;
      district_id = null;
      district_list.clear();

      setState(() {
        var jsonData = json.decode(response.body);
        var responseObj = jsonData["responseObj"] as List;

        for (var model in responseObj) {
          district_list.add(new StateResponse.fromJson(model));
        }
      });
    });
    _progressDialog.dismiss();
  }

  _b2bUserProfile() async {
    _progressDialog.show();
    String token = _sharedPreferences.getString(AppConfig.TOKEN);

    var response = await http.Client().post(Uri.parse(AppConfig.B2B_USER_PROFILE),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer $token'},
        body: {

          "MobileNo": _sharedPreferences.getString(AppConfig.MOBILE_NUMBER),
          "Name":txt_name.text,
          "email": txt_email.text,
          "IsB2BUser":"true",
          "IsFirstTimeLogin": "0",
          "StateId":state_id.toString(),
          "DistrictId":district_id.toString(),
          "SchemeId":scheme_id.toString(),
          "B2BCodeId": B2BCodeId,
        });

    _progressDialog.dismiss();
    var jsonData = json.decode(response.body);

    print(jsonData);

    if(jsonData["responseCode"] == AppConfig.SUCESS_CODE) {
      AppConfig.showRegisterAlertDialog(context, "${jsonData["responseObj"]}");
    } else {
     Fluttertoast.showToast(msg: jsonData["responseObj"]);
    }

  }
}