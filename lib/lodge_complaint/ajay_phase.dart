
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:eeslsamparkapp/libary/ars_progress_dialog.dart';
import 'package:eeslsamparkapp/model/state_gs.dart';
import 'package:eeslsamparkapp/util/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AjayPhaseScheme extends StatefulWidget {

  int scheme_id, state_id, districtid;
  String number, name, address, landmark,state,district,pole_id;

  AjayPhaseScheme(this.scheme_id,this.state_id,this.districtid,this.number,this.name,this.pole_id,this.address,this.landmark,this.state,this.district);

  @override
  _AjayPhaseSchemeState createState() => _AjayPhaseSchemeState(scheme_id,state_id,districtid,number,name,pole_id,address,landmark,state,district);
}


class _AjayPhaseSchemeState extends State<AjayPhaseScheme> {

  int scheme_id, state_id, districtid;
  String number, name, address, landmark,state,district,pole_id;

  _AjayPhaseSchemeState(this.scheme_id,this.state_id,this.districtid,this.number,this.name,this.pole_id,this.address,this.landmark,this.state,this.district);

  TextEditingController txt_remark = new TextEditingController();
  TextEditingController txt_block = new TextEditingController();
  TextEditingController txt_village = new TextEditingController();

  String constituency;
  int constituency_id;
  final List<StateResponse> constituency_list = [];

  String category_type;
  int category_type_id;
  final List<StateResponse> category_type_list = [];
  SharedPreferences _sharedPreferences;
  ArsProgressDialog _progressDialog;

  getLoginDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _getComplaintCategoryList();

   if(scheme_id == 6) {
     _getConstituencyListOne();
   } else {
     _getConstituencyListTwo();
   }
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
          child: AppBar(title: Text("Lodge Complaint",
              style: TextStyle(fontSize: 18, color: Colors.white,fontFamily: AppConfig.FONT_TYPE_BOLD)),
              centerTitle: true, backgroundColor: Color(AppConfig.BLUE_COLOR[0])),
        ),

        body: SafeArea(

          child: ListView(

            children: <Widget>[

              Padding(padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                    text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD,fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(text: 'Constituency '),
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
                    hint: constituency == null ?
                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text('Select Constituency', style: TextStyle(color: Colors.grey, fontSize: 17)))
                        : Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text(constituency, style: TextStyle(color: Colors.black))),

                    isExpanded: true,
                    iconSize: 30.0,
                    style: TextStyle(color: Colors.black),

                    items: constituency_list.map((
                        StateResponse response) {
                      return DropdownMenuItem<StateResponse>(
                          value: response,
                          child: Text(response.text));
                    },
                    ).toList(),

                    onChanged: (StateResponse response) {
                      setState(() {
                        constituency = response.text;
                        constituency_id = response.id;
                      },
                      );
                    },
                  ),
                ),
              ),


              Padding(padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                    text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD,fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(text: 'Block '),
                        TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                      ],
                    ),
                  )),

              Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                  child: TextFormField(
                      controller: txt_block,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,@&#-_]")),
                      ],
                      decoration: InputDecoration(
                          hintText: 'Block ', counter: Container(),
                          contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                          filled: true,
                          hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                          border: InputBorder.none,
                          fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                      style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))),

              Padding(padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                    text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD,fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(text: 'Village '),
                        TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                      ],
                    ),
                  )),

              Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                  child: TextFormField(
                      controller: txt_village,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,@&#-_]")),
                      ],
                      decoration: InputDecoration(
                          hintText: 'Village', counter: Container(),
                          contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                          filled: true,
                          hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                          border: InputBorder.none,
                          fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                      style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))),

              Padding(padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                    text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD,fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(text: 'Complaint Category '),
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
                    hint: category_type == null ?
                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text('Select Category', style: TextStyle(color: Colors.grey, fontSize: 17)))
                        : Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text(category_type, style: TextStyle(color: Colors.black))),

                    isExpanded: true,
                    iconSize: 30.0,
                    style: TextStyle(color: Colors.black),

                    items: category_type_list.map((
                        StateResponse response) {
                      return DropdownMenuItem<StateResponse>(
                          value: response,
                          child: Text(response.text));
                    },
                    ).toList(),

                    onChanged: (StateResponse response) {
                      setState(() {
                        category_type = response.text;
                        category_type_id = response.id;
                      },
                      );
                    },
                  ),
                ),
              ),

              SizedBox(height: 10),

              Padding(padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                    text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD,fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(text: 'Remark'),
                      ],
                    ),
                  )),

              Container(
                  margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                  child: TextFormField(
                      controller: txt_remark,
                      inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,@&#-_]")),
                  ],
                      maxLines: 5,
                      minLines: 3,

                      decoration: InputDecoration(
                          hintText: 'Remark ',
                          contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                          filled: true,
                          hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                          border: InputBorder.none,
                          fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                      style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))),

              SizedBox(height: 20.0),

              Center(
                child: ElevatedButton(
                  child: Text('REGISTER', style : TextStyle(color: Colors.white,
                      fontFamily: AppConfig.FONT_TYPE_BOLD,fontSize: 16.0)),
                  onPressed: () {

                    if(constituency_id == null) {
                      Fluttertoast.showToast(msg: "Please select constituency");
                    } else if(txt_block.text.length == 0) {
                      Fluttertoast.showToast(msg: "Please enter block no");
                    } else if(txt_village.text.length == 0) {
                      Fluttertoast.showToast(msg: "Please enter village name");
                    } else if(category_type_id == null) {
                      Fluttertoast.showToast(msg: "Please select Complaint Category");
                    } else {

                      if(scheme_id == 6) {
                        _registerComplaintOne("", "");
                      } else {
                        _registerComplaintTwo("", "");
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Color(AppConfig.BLUE_COLOR[0]),
                      padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),

              SizedBox(height: 10)
              ,
            ],
          ),
        )
    );
  }

  _getConstituencyListOne() async {

    var response = await http.Client().get(Uri.parse("${AppConfig.AJAYONE_CONSTITUENCY_LIST}$state_id&DistrictId=$districtid"),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});

    setState(() {
      constituency_list.clear();
      var jsonData = json.decode(response.body);
      var responseObj = jsonData["responseObj"] as List;

      for (var model in responseObj) {
        constituency_list.add(new StateResponse.fromJson(model));
      }
    });
  }

  _getConstituencyListTwo() async {

    var response = await http.Client().get(Uri.parse("${AppConfig.AJAY_TWO_CONSTITUENCY_LIST}$state_id&DistrictId=$districtid"),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});

    setState(() {
      constituency_list.clear();
      var jsonData = json.decode(response.body);
      var responseObj = jsonData["responseObj"] as List;

      for (var model in responseObj) {
        constituency_list.add(new StateResponse.fromJson(model));
      }
    });
  }

  _getComplaintCategoryList() async {
    _progressDialog.show();
    var response = await http.Client().get(Uri.parse("${AppConfig.AJAY_COMPLAINT_CATEGORYLIST}"),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});
    _progressDialog.dismiss();
    setState(() {
      category_type_list.clear();
      var jsonData = json.decode(response.body);
      var responseObj = jsonData["responseObj"] as List;

      for (var model in responseObj) {
        category_type_list.add(new StateResponse.fromJson(model));
      }
    });
  }

  _registerComplaintOne(String lat, String long) async {
    _progressDialog.show();
    String token = _sharedPreferences.getString(AppConfig.TOKEN);
    var response = await http.Client().post(Uri.parse(AppConfig.CONSUMER_ENTRY),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer $token'},

        body: {
          "LanguageId": "1" ,
          "CallerNumber":number,
          "CallerName":name,
          "Address": address,
          "Landmark": landmark,
          "StateId":state_id.toString(),
          "DistrictId":districtid.toString(),
          "SchemeId":scheme_id.toString(),
          "States":state,
          "Districts":district,
          "Remark":"",
          "Longitude":lat,
          "Latitude": long,

          "hdn_scheme_Text": "Ajay Phase-I",
          "hdn_CallCategory_Text":"Complaint",
          "AP1_ConstituencyMappingId":"$constituency_id",
          "AP1_Block":txt_block.text,
          "AP1_Village":txt_village.text,
          "AP1_Remark":txt_remark.text,
          "AP1_UniqueIdNo":pole_id,
          "AP2_ComplaintCategoryId1":"$category_type_id"
        });

    _progressDialog.dismiss();
    var jsonData = json.decode(response.body);

    if(jsonData["responseCode"] == AppConfig.SUCESS_CODE) {
      AppConfig.showResponseAlertDialog(context, 'EESL Sampark', "Your Complaint Successfully Registered and ${jsonData["responseObj"]}", 1);
    } else {
      AppConfig.showResponseAlertDialog(context, 'EESL Sampark', "${jsonData["responseObj"]}", 0);
    }
  }

  _registerComplaintTwo(String lat, String long) async {
   // _progressDialog.show();
    String token = _sharedPreferences.getString(AppConfig.TOKEN);
    var response = await http.Client().post(Uri.parse(AppConfig.CONSUMER_ENTRY),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer $token'},

        body: {
          "LanguageId": "1" ,
          "CallerNumber":number,
          "CallerName":name,
          "Address": address,
          "Landmark": landmark,
          "StateId":state_id.toString(),
          "DistrictId":districtid.toString(),
          "SchemeId":scheme_id.toString(),
          "States":state,
          "Districts":district,
          "Remark":"",
          "Longitude":lat,
          "Latitude": long,

          "hdn_scheme_Text": "Ajay Phase-II",
          "hdn_CallCategory_Text":"Complaint",
          "AP2_ConstituencyMappingId":"$constituency_id",
          "AP2_Block":txt_block.text,
          "AP2_Village":txt_village.text,
          "AP2_Remark":txt_remark.text,
          "AP2_UniqueIdNo":pole_id,
          "AP2_ComplaintCategoryId":"$category_type_id",
        });

    _progressDialog.dismiss();
    var jsonData = json.decode(response.body);

    if(jsonData["responseCode"] == AppConfig.SUCESS_CODE) {
      AppConfig.showResponseAlertDialog(context, 'EESL Sampark', "Your Complaint Successfully Registered and ${jsonData["responseObj"]}", 1);
    } else {
      AppConfig.showResponseAlertDialog(context, 'EESL Sampark', "${jsonData["responseObj"]}", 0);
    }
  }
}