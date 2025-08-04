import 'dart:convert';

import 'package:eeslsamparkapp/model/state_gs.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:eeslsamparkapp/libary/ars_progress_dialog.dart';
import 'package:eeslsamparkapp/util/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgdcmScheme extends StatefulWidget {

  int scheme_id, state_id, districtid;
  String number, name, address, landmark,state,district,usc_no,panel_board;

  AgdcmScheme(this.scheme_id,this.state_id,this.districtid,this.number,this.name,this.usc_no,this.panel_board,
      this.address,this.landmark,this.state,this.district);

  @override
  _AgdcmSchemeState createState() => _AgdcmSchemeState(scheme_id,state_id,districtid,number,name,usc_no,panel_board,
      address,landmark,state,district);
}


class _AgdcmSchemeState extends State<AgdcmScheme> {

  int scheme_id, state_id, districtid;
  String number, name, address, landmark,state,district,usc_no,panel_board;

  _AgdcmSchemeState(this.scheme_id,this.state_id,this.districtid,this.number,this.name,this.usc_no,this.panel_board,
      this.address,this.landmark,this.state,this.district);

  TextEditingController txt_remark = new TextEditingController();

  String reason_of_complaint;
  int reason_of_complaint_id;
  final List<StateResponse> reason_of_complaint_list = [];

  SharedPreferences _sharedPreferences;
  ArsProgressDialog _progressDialog;

  getLoginDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _getReasonList();
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

              Padding(padding: EdgeInsets.only(left: 15,top: 20), child: Text("HPkW Rating : 5", style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15))),

              Padding(padding: EdgeInsets.only(left: 15,top: 20),
                  child: RichText(
                    text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD,fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(text: 'Reason Of Complaint '),
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
                    hint: reason_of_complaint == null ?
                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text('Select Scheme', style: TextStyle(color: Colors.grey, fontSize: 17)))
                        : Padding(padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text(reason_of_complaint, style: TextStyle(color: Colors.black))),

                    isExpanded: true,
                    iconSize: 30.0,
                    style: TextStyle(color: Colors.black),

                    items: reason_of_complaint_list.map((
                        StateResponse response) {
                      return DropdownMenuItem<StateResponse>(
                          value: response,
                          child: Text(response.text));
                    },
                    ).toList(),

                    onChanged: (StateResponse response) {
                      setState(() {
                        reason_of_complaint = response.text;
                        reason_of_complaint_id = response.id;
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
                        TextSpan(text: 'Call Remark'),
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
                    if(reason_of_complaint_id == null) {
                      Fluttertoast.showToast(msg: "please select complaint type");
                    } else {

                      _registerComplaint("","");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Color(AppConfig.BLUE_COLOR[0]),
                      padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),

              SizedBox(height: 10),



            ],
          ),
        )
    );
  }

  _getReasonList() async {

    var response = await http.Client().get(Uri.parse(AppConfig.GET_REASON_COMPLAINT_LIST),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});

    setState(() {
      reason_of_complaint_list.clear();
      var jsonData = json.decode(response.body);
      var responseObj = jsonData["responseObj"] as List;

      for (var model in responseObj) {
        reason_of_complaint_list.add(new StateResponse.fromJson(model));
      }
    });
  }

  _registerComplaint(String lat, String long) async {
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
          "hdn_scheme_Text": "AgDSM",
          "hdn_CallCategory_Text":"Complaint",
          "States":state,
          "Districts":district,
          "Remark":txt_remark.text,

          "AGDSM_AssignedToId":"",
          "AGDSM_Town":"",
          "AGDSM_DistributionCenter":"",
          "AGDSM_ConsumerNo":"",

          "AGDSM_USCORServiceConnNo":usc_no,
          "AGDSM_PanelBoardMobNo":panel_board,
          "AGDSM_HPkWRating":"5",
          "AGDSM_ComplaintReason":reason_of_complaint,
          "Longitude":lat,
          "Latitude": long
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