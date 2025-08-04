
import 'dart:convert';
import 'package:eeslsamparkapp/model/product_list_gs.dart';
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

class BuildingScheme extends StatefulWidget {

  int scheme_id, state_id, districtid;
  String number, name, address, landmark,state,district;

  BuildingScheme(this.scheme_id,this.state_id,this.districtid,this.number,this.name,this.address,this.landmark,this.state,this.district);

  @override
  _BuildingSchemeState createState() => _BuildingSchemeState(scheme_id,state_id,districtid,number,name,address,landmark,state,district);
}


class _BuildingSchemeState extends State<BuildingScheme> {

  int scheme_id, state_id, districtid;
  String number, name, address, landmark,state,district;

  _BuildingSchemeState(this.scheme_id,this.state_id,this.districtid,this.number,this.name,this.address,this.landmark,this.state,this.district);

  TextEditingController txt_remark = new TextEditingController();
  TextEditingController txt_reference_no = new TextEditingController();
  TextEditingController txt_floor = new TextEditingController();
  TextEditingController txt_qty = new TextEditingController();

  String buliding;
  int buliding_id;
  final List<StateResponse> buliding_list = [];

  SharedPreferences _sharedPreferences;
  ArsProgressDialog _progressDialog;

  List<bool> _isChecked;
  final List<ProductResponse> product_list = [];
  List<TextEditingController> _controllers = [];

  getLoginDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _getProductList();
    _getBuildingList();
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
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Padding(padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                    text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD,fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(text: 'Building '),
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
                    hint: buliding == null ?
                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text('Building', style: TextStyle(color: Colors.grey, fontSize: 17)))
                        : Padding(padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text(buliding, style: TextStyle(color: Colors.black))),

                    isExpanded: true,
                    iconSize: 30.0,
                    style: TextStyle(color: Colors.black),

                    items: buliding_list.map((
                        StateResponse response) {
                      return DropdownMenuItem<StateResponse>(
                          value: response,
                          child: Text(response.text));
                    },
                    ).toList(),

                    onChanged: (StateResponse response) {
                      setState(() {
                        buliding = response.text;
                        buliding_id = response.id;
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
                        TextSpan(text: 'Reference No. '),
                        TextSpan(text: '', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                      ],
                    ),
                  )),

              Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                  child: TextFormField(
                      controller: txt_reference_no,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,@&#-_]")),
                      ],
                      decoration: InputDecoration(
                          hintText: 'Reference No.', counter: Container(),
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
                        TextSpan(text: 'Floor/Block'),
                        TextSpan(text: '', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                      ],
                    ),
                  )),

              Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                  child: TextFormField(
                      controller: txt_floor,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,@&#-_]")),
                      ],
                      decoration: InputDecoration(
                          hintText: 'Floor/Block', counter: Container(),
                          contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                          filled: true,
                          hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                          border: InputBorder.none,
                          fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                      style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))),

              SizedBox(height: 10),

              Padding(padding: EdgeInsets.only(left: 15,top: 10),
                  child: RichText(
                    text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD,fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(text: 'Select Product'),
                        TextSpan(text: ' *', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                      ],
                    ),
                  )),

              Container(
                height: 350,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(4),
                    itemCount: product_list.length,
                    itemBuilder: (BuildContext context, int index) {
                      _controllers.add(new TextEditingController());
                      return Container(
                          margin: EdgeInsets.only(left: 5 , right: 5, bottom: 5,top: 5),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
                              color:Colors.grey[200]),

                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Row(

                              children: [

                                Expanded(
                                    flex: 8,
                                    child: CheckboxListTile(
                                      title: Text(product_list[index].product),
                                      value: _isChecked[index],
                                      onChanged: (val) {
                                        setState(() {
                                          _isChecked[index] = val;
                                        });
                                      },
                                      controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                    )),

                                Expanded(
                                    flex: 2,
                                    child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Center(
                                            child:TextFormField(
                                                controller: _controllers[index],
                                                keyboardType: TextInputType.number,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                                ],
                                                decoration: InputDecoration(
                                                    hintText: 'QTY', counter: Container(),
                                                    contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                                                    filled: true,
                                                    hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                                                    border: InputBorder.none,
                                                    fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                                                style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))))),
                              ],
                            )));
                    },
                  )),

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

                    if(buliding_id == null) {
                      Fluttertoast.showToast(msg: "Please select Building");
                    } else {
                      String product_type_qty = "";
                      String product_type_id = "";
                      String led_id = "";
                      String ac_id = "";

                      for (int i = 0; i < product_list.length; i++) {
                        if (_isChecked[i]) {
                          if (_controllers[i].text.length == 0) {
                            Fluttertoast.showToast(msg: "Please enter the qty of selected box");
                           return;
                          } else {
                            if(_controllers[i].text == "0") {
                              Fluttertoast.showToast(msg: "Quantity can not be Zero");
                              return;
                            }

                            product_type_id += "${product_list[i].id}" + ",";
                            product_type_qty += _controllers[i].text + ",";

                            if (product_list[i].vednorID == 3 &&
                                _isChecked[i]) {
                              led_id += "${product_list[i].id}" + ",";
                            }

                            if (product_list[i].vednorID == 4 &&
                                _isChecked[i]) {
                              ac_id += "${product_list[i].id}" + ",";
                            }
                          }
                        }
                      }

                      if(product_type_id.length != 0) {

                        _registerComplaint("","",product_type_qty,product_type_id, led_id,ac_id);
                      } else {
                        Fluttertoast.showToast(msg: "Please select the product");
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
            ],
          ),
        )
    );
  }

  _getProductList() async {

    _progressDialog.show();
    var response = await http.Client().get(Uri.parse(AppConfig.GET_BUILDING_PRODUCT_TYPE),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});
    _progressDialog.dismiss();

    setState(() {

      product_list.clear();
      var jsonData = json.decode(response.body);
      var responseObj = jsonData["responseObj"] as List;

      for (var model in responseObj) {
        product_list.add(new ProductResponse.fromJson(model));
      }
      _isChecked = List<bool>.filled(product_list.length, false);
    });
  }

  _getBuildingList() async {

    _progressDialog.show();
    var response = await http.Client().get(Uri.parse("${AppConfig.GET_BUILDING_LIST}$state_id&DistrictId=$districtid"),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});
    _progressDialog.dismiss();
    setState(() {

      buliding_list.clear();
      var jsonData = json.decode(response.body);
      var responseObj = jsonData["responseObj"] as List;

      for (var model in responseObj) {
        buliding_list.add(new StateResponse.fromJson(model));
      }
    });
  }


  _registerComplaint(String lat, String long, String product_type_qty, String product_type_id,
      String led_id, String ac_id) async {
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
          "hdn_scheme_Text": "Building",
          "hdn_CallCategory_Text":"Complaint",
          "States":state,
          "Districts":district,
          "Remark":txt_remark.text,
          "Longitude":lat,
          "Latitude": long,

          "BL_BuildingId":buliding_id.toString(),
          "BL_FlatNo":txt_floor.text,
          "BL_ReferenceNo":txt_reference_no.text,

          "BL_ProductTypes":product_type_id,
          "BL_ProductTypesQty":product_type_qty,
          "BL_LEDProductTypes":led_id,
          "BL_ACProductTypes":ac_id,
          
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