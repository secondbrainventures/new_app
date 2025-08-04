
import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:eeslsamparkapp/libary/ars_progress_dialog.dart';
import 'package:eeslsamparkapp/model/state_gs.dart';
import 'package:eeslsamparkapp/util/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AcScheme extends StatefulWidget {

  int scheme_id, state_id, districtid;
  String number, name, email,state,district;

  AcScheme(this.scheme_id,this.state_id,this.districtid,this.number,this.name,this.email,this.state,this.district);

  @override
  _ACschemeState createState() => _ACschemeState(scheme_id,state_id,districtid,number,name,email,state,district);
}


class _ACschemeState extends State<AcScheme> {

  int scheme_id, state_id, districtid;
  String number, name, email,state,district;

  _ACschemeState(this.scheme_id,this.state_id,this.districtid,this.number,this.name,this.email,this.state,this.district);

  TextEditingController txt_order_id = new TextEditingController();
  TextEditingController txt_registered_mobile = new TextEditingController();
  TextEditingController txt_serial_no = new TextEditingController();

  TextEditingController txt_remark = new TextEditingController();
  TextEditingController txt_date_order_place = new TextEditingController();

  TextEditingController txt_date_order_delivery = new TextEditingController();
  TextEditingController txt_date_order_cancellation = new TextEditingController();
  TextEditingController txt_other = new TextEditingController();

  int selectedAcDetails = 0;
  int selectedUnit = 0;
  final date_format = DateFormat("dd-MM-yyyy");

  String issue_type;
  int issue_id;
  List<StateResponse> issue_type_list =[];

  bool is_order = true;
  bool is_register_mobile = false;
  bool is_serial_no = false;
  bool is_ac_not_install = false;
  bool is_refund_issue = false;
  bool is_other_issue = false;

  SharedPreferences _sharedPreferences;
  ArsProgressDialog _progressDialog;

  getLoginDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _getIssueList();
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

            children: [

              Padding(padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                    text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(text: 'Issue Type '),
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
                    hint: issue_type == null ?
                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text('Select Scheme', style: TextStyle(color: Colors.grey, fontSize: 17)))
                        : Padding(padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text(issue_type, style: TextStyle(color: Colors.black))),

                    isExpanded: true,
                    iconSize: 30.0,
                    style: TextStyle(color: Colors.black),

                    items: issue_type_list.map((
                        StateResponse response) {
                      return DropdownMenuItem<StateResponse>(
                          value: response,
                          child: Text(response.text));
                    },
                    ).toList(),

                    onChanged: (StateResponse response) {
                      setState(() {
                        issue_type = response.text;
                        issue_id = response.id;

                        if(issue_id == 1) {
                          is_ac_not_install = true;
                        } else {
                          is_ac_not_install = false;
                        }

                        if(issue_id == 5) {
                          is_refund_issue = true;
                        } else {
                          is_refund_issue = false;
                        }

                        if(issue_id == 10) {
                          is_other_issue = true;
                        } else {
                          is_other_issue = false;
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
                        TextSpan(text: 'AC Detail '),
                        TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                      ],
                    ),
                  )),

              Column(

                children: <Widget>[
                  Radio(
                    value: 0,
                    groupValue: selectedAcDetails,
                    onChanged: (val) {
                      setState(() {
                        selectedAcDetails = val;

                        is_order = true;
                        is_register_mobile = false;
                        is_serial_no = false;

                      });
                    },
                  ),

                  Text('Order Id', style: TextStyle(color: Colors.black, fontFamily: AppConfig.FONT_TYPE_REGULAR,fontSize: 14.0)),

                  Radio(
                    value: 1,
                    groupValue: selectedAcDetails,
                    onChanged: (val) {
                      setState(() {
                        selectedAcDetails = val;

                        is_order = false;
                        is_register_mobile = true;
                        is_serial_no = false;

                      });

                    },
                  ),

                  Text('Registered Mobile', style: TextStyle(color: Colors.black, fontFamily: AppConfig.FONT_TYPE_REGULAR,fontSize: 14.0)),

                  Radio(
                    value: 2,
                    groupValue: selectedAcDetails,
                    onChanged: (val) {
                      setState(() {
                        selectedAcDetails = val;

                        is_order = false;
                        is_register_mobile = false;
                        is_serial_no = true;

                      });
                    },
                  ),

                  Text('Serial No.',style: TextStyle(color: Colors.black, fontFamily: AppConfig.FONT_TYPE_REGULAR,fontSize: 14.0)),




                ],
              ),

              Visibility(
                visible: is_order,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Padding(padding: EdgeInsets.only(left: 15,top: 10),
                          child: RichText(
                            text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                              children: <TextSpan>[
                                TextSpan(text: 'Order ID '),
                                TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                              ],
                            ),
                          )),

                      Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                          child: TextFormField(
                              controller: txt_order_id,
                              maxLength: 6, keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                              ],
                              decoration: InputDecoration(
                                  hintText: 'Order ID',
                                  contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                                  filled: true,
                                  hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                                  border: InputBorder.none,
                                  fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                              style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))),

                    ],
                  )),

              Visibility(
                  visible: is_register_mobile,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Padding(padding: EdgeInsets.only(left: 15,top: 10),
                          child: RichText(
                            text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                              children: <TextSpan>[
                                TextSpan(text: 'Registered Mobile '),
                                TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                              ],
                            ),
                          )),

                      Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                          child: TextFormField(
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                              ],
                              controller: txt_registered_mobile,
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              decoration: InputDecoration(
                                  hintText: 'Registered Mobile',

                                  contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                                  filled: true,
                                  hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                                  border: InputBorder.none,
                                  fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                              style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))),

                    ],
                  )),

              Visibility(
                  visible: is_serial_no,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Padding(padding: EdgeInsets.only(left: 15,top: 10),
                          child: RichText(
                            text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                              children: <TextSpan>[
                                TextSpan(text: 'Unit Type '),
                                TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                              ],
                            ),
                          )),

                      Row(

                        children: <Widget>[

                          Radio(
                            value: 0,
                            groupValue: selectedUnit,
                            onChanged: (val) {
                              setState(() {
                                selectedUnit = val;
                              });
                            },
                          ),

                          Text('Indoor Unit',style: TextStyle(color: Colors.black, fontFamily: AppConfig.FONT_TYPE_REGULAR,fontSize: 14.0)),

                          Radio(
                            value: 1,
                            groupValue: selectedUnit,
                            onChanged: (val) {
                              setState(() {
                                selectedUnit = val;
                              });

                            },
                          ),

                          Text('Outdoor Unit', style: TextStyle(color: Colors.black, fontFamily: AppConfig.FONT_TYPE_REGULAR,fontSize: 14.0)),

                        ],
                      ),

                      Padding(padding: EdgeInsets.only(left: 15,top: 10),
                          child: RichText(
                            text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                              children: <TextSpan>[
                                TextSpan(text: 'Serial Number '),
                                TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                              ],
                            ),
                          )),

                      Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                          child: TextFormField(
                              controller: txt_serial_no,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,@&#-_.]")),
                              ],
                              decoration: InputDecoration(
                                  hintText: 'Serial Number',
                                  contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                                  filled: true,
                                  hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                                  border: InputBorder.none,
                                  fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                              style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))),

                    ],
                  )),

              Padding(padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                    text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(text: 'Date Of Order Placed '),
                        TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                      ],
                    ),
                  )),

              Padding(
                padding: const EdgeInsets.only(top:8.0,left: 8.0,right: 8.0),
                child: DateTimeField(
                  format: date_format,
                  controller: txt_date_order_place,
                  decoration: InputDecoration(
                      hintText: 'Select Date',
                      contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      filled: true,
                      hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                      border: InputBorder.none,
                      fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                  onShowPicker: (context, currentValue) async {
                    DateTime picked = await showDatePicker(
                        context: context,
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: ColorScheme.dark(
                                primary: Colors.blue,
                                onPrimary: Colors.black,
                                surface: Colors.blue,
                                onSurface: Colors.black,
                              ),
                              dialogBackgroundColor:Colors.white,
                            ),
                            child: child,
                          );
                        },
                        firstDate: DateTime(1950),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime.now());

                    return picked;
                  },
                ),
              ),

              Visibility(
                  visible: is_ac_not_install,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Padding(padding: EdgeInsets.only(left: 15,top: 15),
                          child: RichText(
                            text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                              children: <TextSpan>[
                                TextSpan(text: 'Date Of Order Delivery'),
                                TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                              ],
                            ),
                          )),

                      Padding(
                        padding: const EdgeInsets.only(top:8.0,left: 8.0,right: 8.0),
                        child: DateTimeField(
                          format: date_format,
                          controller: txt_date_order_delivery,
                          decoration: InputDecoration(
                              hintText: 'Select Date',
                              contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                              filled: true,
                              hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                              border: InputBorder.none,
                              fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                          onShowPicker: (context, currentValue) async {
                            DateTime picked = await showDatePicker(
                                context: context,
                                builder: (BuildContext context, Widget child) {
                                  return Theme(
                                    data: ThemeData.dark().copyWith(
                                      colorScheme: ColorScheme.dark(
                                        primary: Colors.blue,
                                        onPrimary: Colors.black,
                                        surface: Colors.blue,
                                        onSurface: Colors.black,
                                      ),
                                      dialogBackgroundColor:Colors.white,
                                    ),
                                    child: child,
                                  );
                                },
                                firstDate: DateTime.now(),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime(2100));

                            return picked;
                          },
                        ),
                      ),

                    ],
                  )),

              Visibility(
                  visible: is_refund_issue,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Padding(padding: EdgeInsets.only(left: 15,top: 15),
                          child: RichText(
                            text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                              children: <TextSpan>[
                                TextSpan(text: 'Date Of Order Cancellation'),
                                TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                              ],
                            ),
                          )),

                      Padding(
                        padding: const EdgeInsets.only(top:8.0,left: 8.0,right: 8.0),
                        child: DateTimeField(
                          format: date_format,
                          controller: txt_date_order_cancellation,
                          decoration: InputDecoration(
                              hintText: 'Select Date',
                              contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                              filled: true,
                              hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                              border: InputBorder.none,
                              fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                          onShowPicker: (context, currentValue) async {
                            DateTime picked = await showDatePicker(
                                context: context,
                                builder: (BuildContext context, Widget child) {
                                  return Theme(
                                    data: ThemeData.dark().copyWith(
                                      colorScheme: ColorScheme.dark(
                                        primary: Colors.blue,
                                        onPrimary: Colors.black,
                                        surface: Colors.blue,
                                        onSurface: Colors.black,
                                      ),
                                      dialogBackgroundColor:Colors.white,
                                    ),
                                    child: child,
                                  );
                                },
                                firstDate: DateTime.now(),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime(2100));

                            return picked;
                          },
                        ),
                      ),

                    ],
                  )),

              Visibility(
                  visible: is_other_issue,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Padding(padding: EdgeInsets.only(left: 15,top: 15),
                          child: RichText(
                            text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                              children: <TextSpan>[
                                TextSpan(text: 'Other'),
                                TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                              ],
                            ),
                          )),

                      Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                          child: TextFormField(controller: txt_other,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,@&#-_]")),
                              ],
                              decoration: InputDecoration(
                                  hintText: 'Other',
                                  contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                                  filled: true,
                                  hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                                  border: InputBorder.none,
                                  fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                              style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))),

                    ],
                  )),

              SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  child: Text('REGISTER', style : TextStyle(color: Colors.white,
                      fontFamily: AppConfig.FONT_TYPE_BOLD,fontSize: 16.0)),
                  onPressed: () {

                    switch(selectedAcDetails) {

                      case 0:
                        if(issue_id == null) {
                          Fluttertoast.showToast(msg: "Please select the Issue type");
                        } else if(txt_order_id.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please enter Order ID");
                        } else if(txt_date_order_place.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please enter Date of Order Placed");
                        } else if(issue_id == 1 && txt_date_order_delivery.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please enter Date of order Delivery");
                        } else if(issue_id == 10 && txt_other.text.isEmpty){
                          Fluttertoast.showToast(msg: "Please enter Other Issue");
                        } else if(issue_id == 5 && txt_date_order_cancellation.text.isEmpty){
                          Fluttertoast.showToast(msg: "Please enter Date of order Cancellation");
                        } else {

                          _registerComplaint("","");
                        }
                        break;

                      case 1:
                        if(issue_id == null) {
                          Fluttertoast.showToast(msg: "Please select the Issue type");
                        } else if(txt_registered_mobile.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please enter Mobile Number");
                        } else if(txt_date_order_place.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please enter Date of Order Placed");
                        } else if(issue_id == 1 && txt_date_order_delivery.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please enter Date of order Delivery");
                        } else if(issue_id == 10 && txt_other.text.isEmpty){
                          Fluttertoast.showToast(msg: "Please enter Other Issue");
                        } else if(issue_id == 5 && txt_date_order_cancellation.text.isEmpty){
                          Fluttertoast.showToast(msg: "Please enter Date of order Cancellation");
                        } else {
                          _registerComplaint("","");
                        }
                        break;


                      case 2:

                        if(issue_id == null) {
                          Fluttertoast.showToast(msg: "Please select the Issue type");
                        } else if(txt_serial_no.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please enter Serial Number");
                        } else if(txt_date_order_place.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please enter Date of Order Placed");
                        } else if(issue_id == 1 && txt_date_order_delivery.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please enter Date of order Delivery");
                        } else if(issue_id == 10 && txt_other.text.isEmpty){
                          Fluttertoast.showToast(msg: "Please enter Other Issue");
                        } else if(issue_id == 5 && txt_date_order_cancellation.text.isEmpty){
                          Fluttertoast.showToast(msg: "Please enter Date of order Cancellation");
                        } else {

                          _registerComplaint("","");
                        }
                        break;
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

  _getIssueList() async {

    _progressDialog.show();
    var response = await http.Client().get(Uri.parse(AppConfig.GET_AC_ISSUE_TYPE_LIST),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});
    _progressDialog.dismiss();

    setState(() {

      issue_type_list.clear();
      var jsonData = json.decode(response.body);
      var responseObj = jsonData["responseObj"] as List;

      for (var model in responseObj) {
        issue_type_list.add(new StateResponse.fromJson(model));
      }
    });
  }

  _registerComplaint(String lat, String long) async {
    _progressDialog.show();
    String token = _sharedPreferences.getString(AppConfig.TOKEN);

    String unit = "";
    if(selectedUnit == 0) {
      unit = "Indoor Unit";
    } else {
      unit = "Outdoor Unit";
    }

    var response = await http.Client().post(Uri.parse(AppConfig.CONSUMER_ENTRY),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer $token'},
        body: {

          "LanguageId": "1" ,
          "CallerNumber":number,
          "CallerName":name,
          "Address": "",
          "Landmark": "",
          "StateId":state_id.toString(),
          "DistrictId":districtid.toString(),
          "SchemeId":scheme_id.toString(),
          "hdn_scheme_Text": "AC",
          "hdn_CallCategory_Text":"Complaint",
          "States":state,
          "Districts":district,
          "Remark":txt_remark.text,
          "Longitude":lat,
          "Latitude": long,

          "SEAC_OrderId":txt_order_id.text,
          "SEAC_OrderPlaceDate":txt_date_order_place.text,
          "SEAC_DateOfOrderDelivery":txt_date_order_delivery.text,
          "SEAC_DateOforderCancellation":txt_date_order_cancellation.text,
          "IssueType":"$issue_id",
          "SEAC_SerialNumber":txt_serial_no.text,
          "SEAC_UnitType":unit,
          "SEAC_RegMobNo":txt_registered_mobile.text,
          "SEAC_Other":txt_other.text,


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