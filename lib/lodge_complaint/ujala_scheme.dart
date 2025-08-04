import 'dart:convert';

import 'package:eeslsamparkapp/libary/ars_progress_dialog.dart';
import 'package:eeslsamparkapp/model/state_gs.dart';
import 'package:eeslsamparkapp/util/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UjalaScheme extends StatefulWidget {

  int scheme_id, state_id, districtid;
  String number, name, address, landmark,state,district;

  UjalaScheme(this.scheme_id,this.state_id,this.districtid,this.number,this.name,this.address,this.landmark,this.state,this.district);

  @override
  _UjalaSchemeState createState() => _UjalaSchemeState(scheme_id,state_id,districtid,number,name,address,landmark,state,district);
}


class _UjalaSchemeState extends State<UjalaScheme> {

  int scheme_id, state_id, districtid;
  String number, name, address, landmark,state,district;

  _UjalaSchemeState(this.scheme_id,this.state_id,this.districtid,this.number,this.name,this.address,this.landmark,this.state,this.district);

  TextEditingController txt_remark = new TextEditingController();
  TextEditingController txt_block = new TextEditingController();
  TextEditingController txt_consumer = new TextEditingController();
  TextEditingController txt_town = new TextEditingController();
  TextEditingController txt_email = new TextEditingController();

  String discom_txt;
  int discom_id;
  final List<StateResponse> discom_list = [];

  String complaint_type;
  int complaint_id;
  final List<StateResponse> complaint_type_list = [];

  bool _blub = false;
  bool _fans = false;
  bool _tube_light = false;

  SharedPreferences _sharedPreferences;
  ArsProgressDialog _progressDialog;

  getLoginDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _getDisComeList();
    _getReasonOfComplaintList();
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
                        TextSpan(text: 'Discom '),
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
                    hint: discom_txt == null ?
                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text('Please select a Discom ', style: TextStyle(color: Colors.grey, fontSize: 17)))
                        : Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text(discom_txt, style: TextStyle(color: Colors.black))),

                    isExpanded: true,
                    iconSize: 30.0,
                    style: TextStyle(color: Colors.black),

                    items: discom_list.map((
                        StateResponse response) {
                      return DropdownMenuItem<StateResponse>(
                          value: response,
                          child: Text(response.text));
                    },
                    ).toList(),

                    onChanged: (StateResponse response) {
                      setState(() {
                        discom_txt = response.text;
                        discom_id = response.id;
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
                        TextSpan(text: 'Email '),
                        TextSpan(text: '', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                      ],
                    ),
                  )),

              Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                  child: TextFormField(
                      controller: txt_email,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,@&#-_.]")),
                      ],
                      decoration: InputDecoration(
                          hintText: 'Email  ', counter: Container(),
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
                        TextSpan(text: 'Town '),
                        TextSpan(text: '', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                      ],
                    ),
                  )),

              Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                  child: TextFormField(
                      controller: txt_town,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ]")),
                      ],
                      decoration: InputDecoration(
                          hintText: 'Town  ', counter: Container(),
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
                        TextSpan(text: 'Consumer No. '),
                        TextSpan(text: '', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                      ],
                    ),
                  )),

              Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                  child: TextFormField(
                      controller: txt_consumer,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,@&#-_]")),
                      ],
                      decoration: InputDecoration(
                          hintText: 'Consumer No. ', counter: Container(),
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
                        TextSpan(text: 'Product '),
                        TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                      ],
                    ),
                  )),

              Row(
                children: [

                  Expanded(
                    flex: 3,
                    child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text('Blub'),
                      value: _blub,
                      onChanged: (value) {
                        setState(() {
                          _blub = !_blub;
                        });
                      },
                    ),
                  ),

                  Expanded(
                      flex: 3,
                    child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text('Fans'),
                    value: _fans,
                    onChanged: (value) {
                      setState(() {
                        _fans = !_fans;
                      });
                    },
                  )),

                  Expanded(
                      flex: 4,
                    child:
                    CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text('Tube Light',style: TextStyle(color: Colors.black),),
                    value: _tube_light,
                    onChanged: (value) {
                      setState(() {
                        _tube_light = !_tube_light;
                      });
                    },
                  )),

                ],
              ),

              Padding(padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                    text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD,fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(text: 'Complaint Type '),
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
                    hint: complaint_type == null ?
                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text('Select Complaint', style: TextStyle(color: Colors.grey, fontSize: 17)))
                        : Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text(complaint_type, style: TextStyle(color: Colors.black))),

                    isExpanded: true,
                    iconSize: 30.0,
                    style: TextStyle(color: Colors.black),

                    items: complaint_type_list.map((
                        StateResponse response) {
                      return DropdownMenuItem<StateResponse>(
                          value: response,
                          child: Text(response.text));
                    },
                    ).toList(),

                    onChanged: (StateResponse response) {
                      setState(() {
                        complaint_type = response.text;
                        complaint_id = response.id;
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
                    if(discom_id == null) {
                      Fluttertoast.showToast(msg: "please select the Discom");
                    } else if(complaint_id == null) {
                      Fluttertoast.showToast(msg: "please select complaint type");
                    } else {
                      if(txt_email.text.length != 0) {
                        var email = txt_email.text;
                        bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);

                        if(emailValid) {

                          _registerComplaint("","");
                        } else {
                          Fluttertoast.showToast(msg: "Email id not valid");
                        }
                      } else {
                        _registerComplaint("","");
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

  _getDisComeList() async {

    _progressDialog.show();

    var response = await http.Client().get(Uri.parse("${AppConfig.DIS_COME_FILL}$state_id&DistrictId=$districtid"),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});

    setState(() {

      var jsonData = json.decode(response.body);
      var responseObj = jsonData["responseObj"] as List;

      for (var model in responseObj) {
        discom_list.add(new StateResponse.fromJson(model));
      }

    });
    _progressDialog.dismiss();
  }

  _getReasonOfComplaintList() async {

    _progressDialog.show();

    var response = await http.Client().get(Uri.parse("${AppConfig.GET_REASON_OF_COMPLAINT_LIST}"),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});

    setState(() {

      var jsonData = json.decode(response.body);
      var responseObj = jsonData["responseObj"] as List;

      for (var model in responseObj) {
        complaint_type_list.add(new StateResponse.fromJson(model));
      }

    });
    _progressDialog.dismiss();
  }

  _registerComplaint(String lat, String long) async {
    String value = "";

    if (_blub) {
      value = value + "1,";
    }
    if (_fans) {
      value = value + "2,";
    }
    if (_tube_light) {
      value = value + "3";
    }

    if(value.length !=0) {
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
            "hdn_scheme_Text": "UJALA/NEEFP",
            "hdn_CallCategory_Text":"Complaint",

            "UJ_DiscomId":discom_id.toString(),
            "UJ_Email":txt_email.text,
            "SchemeId":scheme_id.toString(),
            "States":state,
            "Districts":district,
            "UJ_Town":txt_town.text,
            "UJ_ConsumerNo":txt_consumer.text,
            "UJ_Products":"1",
            "UJ_ComplaintType":complaint_type,
            "Remark":txt_remark.text,
            "Longitude":lat,
            "Latitude": long });

      _progressDialog.dismiss();
      var jsonData = json.decode(response.body);

      if(jsonData["responseCode"] == AppConfig.SUCESS_CODE) {
        AppConfig.showResponseAlertDialog(context, 'EESL Sampark', "Your Complaint Successfully Registered and ${jsonData["responseObj"]}", 1);
      } else {
        AppConfig.showResponseAlertDialog(context, 'EESL Sampark', "${jsonData["responseObj"]}", 0);
      }
    } else {
      Fluttertoast.showToast(msg: "Please select the Product");
    }


  }

}