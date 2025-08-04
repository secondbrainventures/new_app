import 'dart:convert';

import 'package:eeslsamparkapp/libary/ars_progress_dialog.dart';
import 'package:eeslsamparkapp/model/state_gs.dart';
import 'package:eeslsamparkapp/model/ulb_resonse.dart';
import 'package:eeslsamparkapp/model/zone_response.dart';
import 'package:eeslsamparkapp/util/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StreetLightScheme extends StatefulWidget {

  int scheme_id, state_id, districtid;
  String number, name, address, landmark,state,district,image;
  


  StreetLightScheme(this.scheme_id,this.state_id,this.districtid,this.number,this.name,this.address,this.landmark,this.state,this.district, this.image);

  @override
  _StreetLightSchemeState createState() => _StreetLightSchemeState(scheme_id,state_id,districtid,number,name,address,landmark,state,district);
}


class _StreetLightSchemeState extends State<StreetLightScheme> {

  int scheme_id, state_id, districtid;
  String number, name, address, landmark, state, district;

  _StreetLightSchemeState(this.scheme_id,this.state_id,this.districtid,this.number,this.name,this.address,this.landmark,this.state,this.district);

  TextEditingController txt_remark = new TextEditingController();
  TextEditingController txt_pole_no = new TextEditingController();
  TextEditingController txt_ward = new TextEditingController();

  String ulb;
  int ulb_id;
  final List<ULBResponse> ulb_list = [];

  String zone;
  int zone_id;
  final List<ZoneResponse> zone_list = [];

  String area_type;
  int area_id;
  final List<StateResponse> area_type_list = [];

  String ticket_type;
  int ticket_id;
  final List<StateResponse> ticket_type_list = [];

  ArsProgressDialog _progressDialog;
  SharedPreferences _sharedPreferences;

  getLoginDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _getTicketList();
    _getAreaList();
  }

  @override
  void initState() {
    super.initState();

    getLoginDetails();
    print(widget.image);

    // This is initialize the progress dialog
    _progressDialog = ArsProgressDialog(context, blur: 2, backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    Future.delayed(const Duration(milliseconds: 500), () {
      _getAllULB(state_id, districtid);
    });




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
                    text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(text: 'ULB '),
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
                    hint: ulb == null ?
                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text('Select ULB', style: TextStyle(color: Colors.grey, fontSize: 17)))
                        : Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text(ulb, style: TextStyle(color: Colors.black))),

                    isExpanded: true,
                    iconSize: 30.0,
                    style: TextStyle(color: Colors.black),

                    items: ulb_list.map((
                        ULBResponse response) {
                      return DropdownMenuItem<ULBResponse>(
                          value: response,
                          child: Text(response.ulb));
                    },
                    ).toList(),

                    onChanged: (ULBResponse response) {
                      setState(() {
                        ulb = response.ulb;
                        ulb_id = response.id;
                        _getZoneList(response.id);
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
                        TextSpan(text: 'Zone '),
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
                    hint: zone == null ?
                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text('Select Zone', style: TextStyle(color: Colors.grey, fontSize: 17)))
                        : Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text(zone, style: TextStyle(color: Colors.black))),

                    isExpanded: true,
                    iconSize: 30.0,
                    style: TextStyle(color: Colors.black),

                    items: zone_list.map((
                        ZoneResponse response) {
                      return DropdownMenuItem<ZoneResponse>(
                          value: response,
                          child: Text(response.zone));
                    },
                    ).toList(),

                    onChanged: (ZoneResponse response) {
                      setState(() {
                        zone = response.zone;
                        zone_id = response.id;
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
                        TextSpan(text: 'Ward/Sector/Society '),
                        TextSpan(text: '', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                      ],
                    ),
                  )),

              Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                  child: TextFormField(
                      controller: txt_ward,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,@&#-_]")),
                      ],
                      decoration: InputDecoration(
                          hintText: 'Ward/Sector/Society ', counter: Container(),
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
                        TextSpan(text: 'Pole No. '),
                        TextSpan(text: '', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                      ],
                    ),
                  )),

              Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                  child: TextFormField(
                      controller: txt_pole_no,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,@&#-_]")),
                      ],
                      decoration: InputDecoration(
                          hintText: 'Pole No.', counter: Container(),
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
                        TextSpan(text: 'Area Type '),
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
                    hint: area_type == null ?
                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text('Select Area Type', style: TextStyle(color: Colors.grey, fontSize: 17)))
                        : Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text(area_type, style: TextStyle(color: Colors.black))),

                    isExpanded: true,
                    iconSize: 30.0,
                    style: TextStyle(color: Colors.black),

                    items: area_type_list.map((
                        StateResponse response) {
                      return DropdownMenuItem<StateResponse>(
                          value: response,
                          child: Text(response.text));
                    },
                    ).toList(),

                    onChanged: (StateResponse response) {
                      setState(() {
                        area_type = response.text;
                        area_id = response.id;
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
                        TextSpan(text: 'Ticket Type '),
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
                    hint: ticket_type == null ?
                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text('Select Ticket Type', style: TextStyle(color: Colors.grey, fontSize: 17)))
                        : Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text(ticket_type, style: TextStyle(color: Colors.black))),

                    isExpanded: true,
                    iconSize: 30.0,
                    style: TextStyle(color: Colors.black),

                    items: ticket_type_list.map((
                        StateResponse response) {
                      return DropdownMenuItem<StateResponse>(
                          value: response,
                          child: Text(response.text));
                    },
                    ).toList(),

                    onChanged: (StateResponse response) {
                      setState(() {
                        ticket_type = response.text;
                        ticket_id = response.id;
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

                    FocusScope.of(context).requestFocus(new FocusNode());

                    if(ulb == null) {
                      Fluttertoast.showToast(msg: "Please select ULB");
                    } else if(zone == null) {
                      Fluttertoast.showToast(msg: "Please select Zone");
                    } else if(area_type == null) {
                      Fluttertoast.showToast(msg: "Please select Area Type");
                    } else if(ticket_type == null) {
                      Fluttertoast.showToast(msg: "Please select Ticket Type");
                    } else {
                      AppConfig.getpermiaaionLocation().then((value) => {

                      if(value) {
                          AppConfig.getUserLocation(context).then((
                          currentPostion) {
                        if (currentPostion != null) {
                          _progressDialog.show();
                          String lat = "${currentPostion.latitude}";
                          String long = "${currentPostion.longitude}";
                          _registerComplaint(
                              txt_ward.text, txt_pole_no.text, txt_remark.text,
                              lat, long);
                        }
                      })
                    } else {
                          AppConfig.showFancyCustomDialogLocation(context)
                    }

                  });


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

  _getAllULB(int state_id, int districtid) async {

    _progressDialog.show();
    var response = await http.Client().get(Uri.parse(AppConfig.API_GET_ULB_LIST + districtid.toString()),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});

    setState(() {

      var jsonData = json.decode(response.body);
      var responseObj = jsonData["responseObj"] as List;

      for (var model in responseObj) {
        ulb_list.add(new ULBResponse.fromJson(model));
      }

    });
    _progressDialog.dismiss();
  }

  _getZoneList(int ulb_id) async {

    _progressDialog.show();

    print(AppConfig.API_GET_ZONE_LIST+ulb_id.toString());

    var response = await http.Client().get(Uri.parse(AppConfig.API_GET_ZONE_LIST+ulb_id.toString()),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});

    setState(() {

      zone_list.clear();
      zone = null;

      var jsonData = json.decode(response.body);
      var responseObj = jsonData["responseObj"] as List;

      for (var model in responseObj) {
        zone_list.add(new ZoneResponse.fromJson(model));
      }

    });
    _progressDialog.dismiss();
  }

  _getAreaList() async {

    var response = await http.Client().get(Uri.parse(AppConfig.GET_AREA_TYPE_LIST),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});

    setState(() {

      area_type_list.clear();
      area_type = null;

      var jsonData = json.decode(response.body);
      var responseObj = jsonData["responseObj"] as List;

      for (var model in responseObj) {
        area_type_list.add(new StateResponse.fromJson(model));
      }
    });
  }

  _getTicketList() async {

    var response = await http.Client().get(Uri.parse(AppConfig.GET_TICKET_TYPE_LIST),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});

    setState(() {

      ticket_type_list.clear();
      ticket_type = null;

      var jsonData = json.decode(response.body);
      var responseObj = jsonData["responseObj"] as List;

      for (var model in responseObj) {
        ticket_type_list.add(new StateResponse.fromJson(model));
      }
    });
  }

  _registerComplaint(String ward_no,String pole_no, String remark,String lat, String long) async {

     _progressDialog.show();
    String token = _sharedPreferences.getString(AppConfig.TOKEN);
    print(AppConfig.CONSUMER_ENTRY);
    var response = await http.Client().post(Uri.parse(AppConfig.CONSUMER_ENTRY),
      headers: {"Accept": "application/json", 'Authorization': 'Bearer $token'},
      body: {
        'LanguageId': "1" ,
        'SL_ComplaintFromId': "2",
        'SL_LightTypeId': "1",
        'hdn_scheme_Text': "Street Light",
        'hdn_CallCategory_Text': "Complaint",
        'CallerNumber': number,
        'CallerName': name,
        'Address': address,
        'Landmark': landmark,
        'StateId': state_id.toString(),
        'DistrictId': districtid.toString(),
        'SchemeId': scheme_id.toString(),
        'States': state,
        'Districts': district,
        'SL_ULBId': ulb_id.toString() ,
        'hdnULBText': ulb,
        'hdnZoneText': zone,
        'SL_ZoneId': zone_id.toString(),
        'SL_WardNo': ward_no,
        'SL_PoleNo': pole_no,
        'SL_TicketTypeId': ticket_id.toString(),
        'SL_AreaType': area_type,
        'Remark': remark,
        'Longitude': lat,
        'Latitude': long,
        'ImgStr':widget.image

      });
    _progressDialog.dismiss();
    var jsonData = json.decode(response.body);

    print(jsonData);

    if(jsonData["responseCode"] == AppConfig.SUCESS_CODE) {
      AppConfig.showResponseAlertDialog(context, 'EESL Sampark', "Your Complaint Successfully Registered and ${jsonData["responseObj"]}", 1);
    } else {
      AppConfig.showResponseAlertDialog(context, 'EESL Sampark', "${jsonData["responseObj"]}", 0);
    }
  }
}