
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

class SolusScheme extends StatefulWidget {

  int scheme_id, state_id, districtid;
  String number, name, address, landmark,state,district;

  SolusScheme(this.scheme_id,this.state_id,this.districtid,this.number,this.name,this.address,this.landmark,this.state,this.district);

  @override
  _SolusSchemeState createState() => _SolusSchemeState(scheme_id,state_id,districtid,number,name,address,landmark,state,district);
}


class _SolusSchemeState extends State<SolusScheme> {

  int scheme_id, state_id, districtid;
  String number, name, address, landmark,state,district;

  _SolusSchemeState(this.scheme_id,this.state_id,this.districtid,this.number,this.name,this.address,this.landmark,this.state,this.district);

  TextEditingController txt_remark = new TextEditingController();
  TextEditingController txt_block = new TextEditingController();

  TextEditingController txt_adc_name = new TextEditingController();
  TextEditingController setup_date = new TextEditingController();

  String r_m_code,full_name;
  final List<StateResponse> full_name_list = [];

  SharedPreferences _sharedPreferences;
  ArsProgressDialog _progressDialog;

  String adc_code, adc_address, adc_contact_person, adc_setup_date, status;

  getLoginDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _getAllData();
    _getFullNameList();
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

              Padding(padding: EdgeInsets.only(left: 15,top: 20),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(text: 'ADC Code : ',style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15)),
                        TextSpan(text: adc_code,  style: TextStyle(color: Colors.black, fontSize: 14)),
                      ],
                    ),
                  )),

              Padding(padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(text: 'Address : ',style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15)),
                        TextSpan(text: adc_address, style: new TextStyle(color: Colors.black, fontSize: 14)),
                      ],
                    ),
                  )),

              Padding(padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(text: 'Contact Person : ',style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),),
                        TextSpan(text: adc_contact_person, style: new TextStyle(color: Colors.black, fontSize: 14)),
                      ],
                    ),
                  )),

              Padding(padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(text: 'Setup Date : ',style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),),
                        TextSpan(text: adc_setup_date, style: new TextStyle(color: Colors.black, fontSize: 14)),
                      ],
                    ),
                  )),

              Padding(padding: EdgeInsets.only(left: 15,top: 10,bottom: 10),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(text: 'Status : ',style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),),
                        TextSpan(text: status, style: new TextStyle(color: Colors.black, fontSize: 14)),
                      ],
                    ),
                  )),


              Divider(color: Colors.grey,),

              Padding(padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                    text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(text: 'R & M Code '),
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
                    hint: r_m_code == null ?
                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text('Select R & M code', style: TextStyle(color: Colors.grey, fontSize: 17)))
                        : Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text(r_m_code, style: TextStyle(color: Colors.black))),

                    isExpanded: true,
                    iconSize: 30.0,
                    style: TextStyle(color: Colors.black),

                    items: full_name_list.map((
                        StateResponse response) {
                      return DropdownMenuItem<StateResponse>(
                          value: response,
                          child: Text(response.text));
                    },
                    ).toList(),

                    onChanged: (StateResponse response) {
                      setState(() {
                        r_m_code = response.text;
                        full_name = response.mastertext;
                        _getSolusData(r_m_code);
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
                        TextSpan(text: 'Full Name '),
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
                    hint: full_name == null ?
                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text('Select Full Name', style: TextStyle(color: Colors.grey, fontSize: 17)))
                        : Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text(full_name, style: TextStyle(color: Colors.black))),

                    isExpanded: true,
                    iconSize: 30.0,
                    style: TextStyle(color: Colors.black),

                    items: full_name_list.map((
                        StateResponse response) {
                      return DropdownMenuItem<StateResponse>(
                          value: response,
                          child: Text(response.mastertext));
                    },
                    ).toList(),

                    onChanged: (StateResponse response) {
                      setState(() {
                        r_m_code = response.text;
                        full_name = response.mastertext;
                        _getSolusData(r_m_code);
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
                        TextSpan(text: 'ADC Name  '),
                        TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                      ],
                    ),
                  )),

              Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                  child: TextFormField(
                    enabled: false,
                      controller: txt_adc_name, textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                          hintText: 'ADC Name  ', counter: Container(),
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
                        TextSpan(text: 'Setup Date  '),
                        TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                      ],
                    ),
                  )),

              Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                  child: TextFormField(controller: setup_date , textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                          enabled: false,
                          hintText: 'Date', counter: Container(),
                          contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                          filled: true,
                          hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                          border: InputBorder.none,
                          fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                      style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))),

              SizedBox(height: 10),

              Padding(padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                    text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(text: 'Remark'),
                      ],
                    ),
                  )),

              Container(
                  margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                  child: TextFormField(
                      controller: txt_remark, textCapitalization: TextCapitalization.characters,
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

                    if(r_m_code == null) {
                      Fluttertoast.showToast(msg: "Please select R & M Code First");
                    } else if(full_name == null) {
                      Fluttertoast.showToast(msg: "Please select Name First");
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

              SizedBox(height: 10)
              ,
            ],
          ),
        )
    );
  }

  _getAllData() async {

    _progressDialog.show();
    var response = await http.Client().get(Uri.parse(AppConfig.GET_ADC_MASTER_DATA+"$districtid"),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});
    _progressDialog.dismiss();

    setState(() {

      var jsonData = json.decode(response.body);
      var responseObj = jsonData["responseObj"];

      adc_address = responseObj["adcAddress"];
      adc_contact_person = responseObj["contactPersonDetails"];
      adc_code = responseObj["adcName"];
      status = responseObj["status"];
      adc_setup_date = responseObj["setupDate"];

    });
  }

  _getFullNameList() async {

    var response = await http.Client().get(Uri.parse(AppConfig.GET_RM_CODE_NAME_ONLOAD+"$districtid"),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});

    setState(() {
      full_name_list.clear();
      var jsonData = json.decode(response.body);
      var responseObj = jsonData["responseObj"] as List;

      for (var model in responseObj) {
        full_name_list.add(new StateResponse.fromJson(model));
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
          "hdn_scheme_Text": "SoULS",
          "hdn_CallCategory_Text":"Complaint",
          "States":state,
          "Districts":district,
          "Remark":txt_remark.text,
          "Longitude":lat,
          "Latitude": long,
          "SoulRMCode": r_m_code,
        });

    _progressDialog.dismiss();
    var jsonData = json.decode(response.body);

    if(jsonData["responseCode"] == AppConfig.SUCESS_CODE) {
      AppConfig.showResponseAlertDialog(context, 'EESL Sampark', "Your Complaint Successfully Registered and ${jsonData["responseObj"]}", 1);
    } else {
      AppConfig.showResponseAlertDialog(context, 'EESL Sampark', "${jsonData["responseObj"]}", 0);
    }
  }

  _getSolusData(String id) async {

    _progressDialog.show();
    var response = await http.Client().get(Uri.parse(AppConfig.GET_RM_CENTER_MASTER+"$id"),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});
    _progressDialog.dismiss();

    setState(() {
      var jsonData = json.decode(response.body);
      var responseObj = jsonData["responseObj"];
      txt_adc_name.text = responseObj["adcName"];
      setup_date.text = responseObj["centerStartDate"];
    });
  }

}