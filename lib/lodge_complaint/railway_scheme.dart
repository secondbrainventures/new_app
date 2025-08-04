
import 'dart:convert';
import 'package:eeslsamparkapp/libary/ars_progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:eeslsamparkapp/model/state_gs.dart';
import 'package:eeslsamparkapp/util/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RailwayScheme extends StatefulWidget {

  int scheme_id, state_id, districtid;
  String number, name, address, state,district;

  RailwayScheme(this.scheme_id,this.state_id,this.districtid,this.number,this.name,this.address,this.state,this.district);

  @override
  _RailwaySchemeState createState() => _RailwaySchemeState(scheme_id,state_id,districtid,number,name,address,state,district);
}


class _RailwaySchemeState extends State<RailwayScheme> {

  int scheme_id, state_id, districtid;
  String number, name, address, state,district;

  _RailwaySchemeState(this.scheme_id,this.state_id,this.districtid,this.number,this.name,this.address,this.state,this.district);

  TextEditingController txt_remark = new TextEditingController();
  TextEditingController txt_no_of_faulty = new TextEditingController();
  TextEditingController txt_nature_of_faulty = new TextEditingController();

  String railway_zone;
  int railway_zone_id;
  final List<StateResponse> railway_zone_list = [];

  String railway_div;
  int railway_div_id;
  final List<StateResponse> railway_div_list = [];

  String railway_station;
  int railway_station_id;
  final List<StateResponse> railway_station_list = [];

  String product_category;
  int product_category_id;
  final List<StateResponse> product_category_list = [];

  String product;
  int product_id;
  final List<StateResponse> product_list = [];

  String watt;
  int watt_id;
  final List<StateResponse> watt_list = [];

  String mounting;
  int mounting_id;
  final List<StateResponse> mounting_list = [];


  String manufacturer;
  int manufacturer_id;
  final List<StateResponse> manufacturer_list = [];

  String dimension;
  final List<String> dimension_list = [];

  SharedPreferences _sharedPreferences;
  ArsProgressDialog _progressDialog;

  getLoginDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _getRailwayZoneList();
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
          child: AppBar(title: Text("Railway ",
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
                        TextSpan(text: 'Railway Zone '),
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
                    hint: railway_zone == null ?
                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text('Please select Railway Zone', style: TextStyle(color: Colors.grey, fontSize: 17)))
                        : Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text(railway_zone, style: TextStyle(color: Colors.black))),

                    isExpanded: true,
                    iconSize: 30.0,
                    style: TextStyle(color: Colors.black),

                    items: railway_zone_list.map((
                        StateResponse response) {
                      return DropdownMenuItem<StateResponse>(
                          value: response,
                          child: Text(response.text));
                    },
                    ).toList(),

                    onChanged: (StateResponse response) {
                      setState(() {
                        railway_zone = response.text;
                        railway_zone_id = response.id;
                        _getRailwayDivisionList(railway_zone_id);
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
                        TextSpan(text: 'Railway Division '),
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
                    hint: railway_div == null ?
                    Padding(padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text('Select Railway Division', style: TextStyle(color: Colors.grey, fontSize: 17)))
                        : Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text(railway_div, style: TextStyle(color: Colors.black))),

                    isExpanded: true,
                    iconSize: 30.0,
                    style: TextStyle(color: Colors.black),

                    items: railway_div_list.map((
                        StateResponse response) {
                      return DropdownMenuItem<StateResponse>(
                          value: response,
                          child: Text(response.text));
                    },
                    ).toList(),

                    onChanged: (StateResponse response) {
                      setState(() {
                        railway_div = response.text;
                        railway_div_id = response.id;
                        _getRailwayStationList(railway_zone_id, railway_div_id);
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

                        TextSpan(text: 'Railway Station/ Workshop '),
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
                    hint: railway_station == null ?
                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text('Select Railway Station', style: TextStyle(color: Colors.grey, fontSize: 17)))
                        : Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text(railway_station, style: TextStyle(color: Colors.black))),

                    isExpanded: true,
                    iconSize: 30.0,
                    style: TextStyle(color: Colors.black),

                    items: railway_station_list.map((
                        StateResponse response) {
                      return DropdownMenuItem<StateResponse>(
                          value: response,
                          child: Text(response.text));
                    },
                    ).toList(),

                    onChanged: (StateResponse response) {
                      setState(() {
                        railway_station = response.text;
                        railway_station_id = response.id;
                        _getRailwayProductList(railway_zone_id, railway_div_id, railway_station_id);
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
                        TextSpan(text: 'Product Category'),
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
                    hint: product_category == null ?
                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text('Select Product Category', style: TextStyle(color: Colors.grey, fontSize: 17)))
                        : Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text(product_category, style: TextStyle(color: Colors.black))),

                    isExpanded: true,
                    iconSize: 30.0,
                    style: TextStyle(color: Colors.black),

                    items: product_category_list.map((
                        StateResponse response) {
                      return DropdownMenuItem<StateResponse>(
                          value: response,
                          child: Text(response.text));
                    },
                    ).toList(),

                    onChanged: (StateResponse response) {
                      setState(() {
                        product_category = response.text;
                        product_category_id = response.id;

                        _getRailwayProductItemList(railway_zone_id, railway_div_id, railway_station_id, product_category_id);
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
                        TextSpan(text: 'Product '),
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
                    hint: product == null ?
                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text('Select Product ', style: TextStyle(color: Colors.grey, fontSize: 17)))
                        : Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text(product, style: TextStyle(color: Colors.black))),

                    isExpanded: true,
                    iconSize: 30.0,
                    style: TextStyle(color: Colors.black),

                    items: product_list.map((
                        StateResponse response) {
                      return DropdownMenuItem<StateResponse>(
                          value: response,
                          child: Text(response.text));
                    },
                    ).toList(),

                    onChanged: (StateResponse response) {
                      setState(() {
                        product = response.text;
                        product_id = response.id;

                        _getProductWattList(product_id);
                        _getProductMountingList(product_id);

                        _getRailwayManufacturerList(railway_zone_id, railway_div_id, railway_station_id, product_category_id, product_id);

                        if(product == "Tube Light") {
                          dimension_list.clear();
                          dimension = null;
                          dimension_list.add("2feet");
                          dimension_list.add("4feet");
                        } else if(product == "Led Panel Light") {
                          dimension_list.clear();
                          dimension = null;
                          dimension_list.add("1X1 Panel");
                          dimension_list.add("2X2 Panel");
                          dimension_list.add("1X4 Panel");
                        } else {
                          dimension_list.clear();
                          dimension = null;
                          dimension_list.add("NA");

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
                        TextSpan(text: 'Dimension '),
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
                    hint: dimension == null ?
                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text('Select Dimension ', style: TextStyle(color: Colors.grey, fontSize: 17)))
                        : Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text(dimension, style: TextStyle(color: Colors.black))),

                    isExpanded: true,
                    iconSize: 30.0,
                    style: TextStyle(color: Colors.black),

                    items: dimension_list.map((
                        String response) {
                      return DropdownMenuItem<String>(
                          value: response,
                          child: Text(response));
                    },
                    ).toList(),

                    onChanged: (String response) {
                      setState(() {
                        dimension = response;
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
                        TextSpan(text: 'Watt '),
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
                    hint: watt == null ?
                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text('Watt ', style: TextStyle(color: Colors.grey, fontSize: 17)))
                        : Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text(watt, style: TextStyle(color: Colors.black))),

                    isExpanded: true,
                    iconSize: 30.0,
                    style: TextStyle(color: Colors.black),

                    items: watt_list.map((
                        StateResponse response) {
                      return DropdownMenuItem<StateResponse>(
                          value: response,
                          child: Text(response.text));
                    },
                    ).toList(),

                    onChanged: (StateResponse response) {
                      setState(() {
                        watt = response.text;
                        watt_id = response.id;
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
                        TextSpan(text: 'Mounting '),
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
                    hint: mounting == null ?
                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text('Select Mounting ', style: TextStyle(color: Colors.grey, fontSize: 17)))
                        : Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text(mounting, style: TextStyle(color: Colors.black))),

                    isExpanded: true,
                    iconSize: 30.0,
                    style: TextStyle(color: Colors.black),

                    items: mounting_list.map((
                        StateResponse response) {
                      return DropdownMenuItem<StateResponse>(
                          value: response,
                          child: Text(response.text));
                    },
                    ).toList(),

                    onChanged: (StateResponse response) {
                      setState(() {
                        mounting = response.text;
                        mounting_id = response.id;
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
                        TextSpan(text: 'No. of Faulty Items  '),
                        TextSpan(text: '', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                      ],
                    ),
                  )),

              Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                  child: TextFormField(controller: txt_no_of_faulty,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      ],
                      decoration: InputDecoration(
                          hintText: '0  ', counter: Container(),
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
                        TextSpan(text: 'Nature Of Faulty '),
                        TextSpan(text: '', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                      ],
                    ),
                  )),

              Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                  child: TextFormField(
                      controller: txt_nature_of_faulty,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,&#-]")),
                      ],
                      decoration: InputDecoration(
                          hintText: 'Nature Of Faulty ', counter: Container(),
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
                        TextSpan(text: 'Manufacturer '),
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
                    hint: manufacturer == null ?
                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text('Select Manufacturer ', style: TextStyle(color: Colors.grey, fontSize: 17)))
                        : Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Text(manufacturer, style: TextStyle(color: Colors.black))),

                    isExpanded: true,
                    iconSize: 30.0,
                    style: TextStyle(color: Colors.black),

                    items: manufacturer_list.map((
                        StateResponse response) {
                      return DropdownMenuItem<StateResponse>(
                          value: response,
                          child: Text(response.text));
                    },
                    ).toList(),

                    onChanged: (StateResponse response) {
                      setState(() {
                        manufacturer = response.text;
                        manufacturer_id = response.id;
                      },
                      );
                    },
                  ),
                ),
              ),

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
                      controller: txt_remark, inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,&#-]")),
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

                    if(railway_zone_id == null) {
                      Fluttertoast.showToast(msg: "Please select Zone");
                    } else if(railway_div_id == null) {
                      Fluttertoast.showToast(msg: "Please select Division");
                    } else if(railway_station_id == null) {
                      Fluttertoast.showToast(msg: "Please select Railway Station");
                    } else if(product_category_id == null) {
                      Fluttertoast.showToast(msg: "Please select Product category");
                    } else if(product_id == null) {
                      Fluttertoast.showToast(msg: "Please select product");
                    }else if(dimension == null) {
                      Fluttertoast.showToast(msg: "Please select Dimension");
                    } else if(watt_id == null) {
                      Fluttertoast.showToast(msg: "Please select Watt");
                    } else if(mounting_id == null) {
                      Fluttertoast.showToast(msg: "Please select Mounting");
                    } else if(manufacturer_id == null) {
                      Fluttertoast.showToast(msg: "Please select Manufacturer");
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

  _getRailwayZoneList() async {

    _progressDialog.show();
    var response = await http.Client().get(Uri.parse("${AppConfig.GET_BEEP_RAILWAYZONE_LIST}$state_id"),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});
    _progressDialog.dismiss();

    setState(() {

      railway_zone_list.clear();
      var jsonData = json.decode(response.body);
      var responseObj = jsonData["responseObj"] as List;

      for (var model in responseObj) {
        railway_zone_list.add(new StateResponse.fromJson(model));
      }
    });
  }

  _getRailwayDivisionList(int id) async {
    _progressDialog.show();
    var response = await http.Client().get(Uri.parse("${AppConfig.GET_BEEP_DIVISION_LIST}$state_id&ZoneId=$id"),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});
    _progressDialog.dismiss();
    setState(() {

      railway_div_list.clear();
      railway_div_id = null;
      railway_div = null;

      railway_station_list.clear();
      railway_station = null;
      railway_station_id = null;

      product_category_list.clear();
      product_category = null;
      product_category_id = null;

      product_list.clear();
      product = null;
      product_id = null;

      watt_list.clear();
      watt_id = null;
      watt = null;

      mounting_list.clear();
      mounting_id = null;
      mounting = null;

      manufacturer_list.clear();
      manufacturer_id = null;
      manufacturer = null;

      var jsonData = json.decode(response.body);
      var responseObj = jsonData["responseObj"] as List;

      for (var model in responseObj) {
        railway_div_list.add(new StateResponse.fromJson(model));
      }
    });
  }

  _getRailwayStationList(int id,int division_id) async {

    _progressDialog.show();
    var response = await http.Client().get(Uri.parse("${AppConfig.GET_BEEP_STATION_LIST}$state_id&ZoneId=$id&DivisionId=$division_id"),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});
    _progressDialog.dismiss();
    setState(() {

      railway_station_list.clear();
      railway_station = null;
      railway_station_id = null;

      product_category_list.clear();
      product_category = null;
      product_category_id = null;

      product_list.clear();
      product = null;
      product_id = null;

      watt_list.clear();
      watt_id = null;
      watt = null;

      mounting_list.clear();
      mounting_id = null;
      mounting = null;

      manufacturer_list.clear();
      manufacturer_id = null;
      manufacturer = null;

      var jsonData = json.decode(response.body);
      var responseObj = jsonData["responseObj"] as List;

      for (var model in responseObj) {
        railway_station_list.add(new StateResponse.fromJson(model));
      }
    });
  }

  _getRailwayProductList(int id,int division_id,int station_id) async {

    _progressDialog.show();
    var response = await http.Client().get(Uri.parse("${AppConfig.GET_BEEP_PRODUCT_CATEGORY_LIST}$state_id&ZoneId=$id&DevisionId=$division_id&StationId=$station_id"),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});
    _progressDialog.dismiss();

    setState(() {

      product_category_list.clear();
      product_category = null;
      product_category_id = null;

      product_list.clear();
      product = null;
      product_id = null;

      watt_list.clear();
      watt_id = null;
      watt = null;

      mounting_list.clear();
      mounting_id = null;
      mounting = null;

      manufacturer_list.clear();
      manufacturer_id = null;
      manufacturer = null;

      var jsonData = json.decode(response.body);
      var responseObj = jsonData["responseObj"] as List;

      for (var model in responseObj) {
        product_category_list.add(new StateResponse.fromJson(model));
      }
    });
  }

  _getRailwayProductItemList(int id,int division_id,int station_id,int productcategoryid) async {

    _progressDialog.show();
    var response = await http.Client().get(Uri.parse("${AppConfig.GET_BEEP_PRODUCT_CATEGORY_ITEM_LIST}"
        "$state_id&ZoneId=$id&DevisionId=$division_id&StationId=$station_id&ProductCategoryId=$productcategoryid"),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});
    _progressDialog.dismiss();

    setState(() {

      product_list.clear();
      product = null;
      product_id = null;

      watt_list.clear();
      watt_id = null;
      watt = null;

      mounting_list.clear();
      mounting_id = null;
      mounting = null;

      manufacturer_list.clear();
      manufacturer_id = null;
      manufacturer = null;

      var jsonData = json.decode(response.body);
      var responseObj = jsonData["responseObj"] as List;

      for (var model in responseObj) {
        product_list.add(new StateResponse.fromJson(model));
      }
    });
  }

  _getProductWattList(int id) async {
    _progressDialog.show();
    var response = await http.Client().get(Uri.parse("${AppConfig.GET_PRODUCT_WATT_LIST}$id"),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});
    _progressDialog.dismiss();
    setState(() {

      watt_list.clear();
      watt_id = null;
      watt = null;

      mounting_list.clear();
      mounting_id = null;
      mounting = null;

      var jsonData = json.decode(response.body);
      var responseObj = jsonData["responseObj"] as List;

      for (var model in responseObj) {
        watt_list.add(new StateResponse.fromJson(model));
      }
    });
  }

  _getProductMountingList(int id) async {
    _progressDialog.show();
    var response = await http.Client().get(Uri.parse("${AppConfig.GET_PRODUCT_MOUNTING_LIST}$id"),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});
    _progressDialog.dismiss();
    setState(() {

      mounting_list.clear();
      mounting_id = null;
      mounting = null;

      var jsonData = json.decode(response.body);
      var responseObj = jsonData["responseObj"] as List;

      for (var model in responseObj) {
        mounting_list.add(new StateResponse.fromJson(model));
      }
    });
  }

  _getRailwayManufacturerList(int id,int division_id,int station_id,int productcategoryid,int product_id) async {

    _progressDialog.show();
    var response = await http.Client().get(Uri.parse("${AppConfig.GET_PRODUCT_MANUFACTURER_LIST}"
        "$state_id&ZoneId=$id&DevisionId=$division_id&RailwayStationId=$station_id&"
        "ProductCategoryId=$productcategoryid&ProductId=$product_id"),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});
    _progressDialog.dismiss();

    setState(() {

      manufacturer_list.clear();
      manufacturer_id = null;
      manufacturer = null;

      var jsonData = json.decode(response.body);
      var responseObj = jsonData["responseObj"] as List;

      for (var model in responseObj) {
        manufacturer_list.add(new StateResponse.fromJson(model));
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
          "Landmark": "",
          "StateId":state_id.toString(),
          "DistrictId":"",
          "SchemeId":scheme_id.toString(),
          "hdn_scheme_Text": "BEEP- Railway",
          "hdn_CallCategory_Text":"Complaint",
          "States":state,
          "Districts":"",
          "Remark":txt_remark.text,
          "Longitude":lat,
          "Latitude": long,
          "Beep_ZoneId":"$railway_zone_id",
          "Beep_DevisionId":"$railway_div_id",
          "Beep_Devision_Other":"",
          "Beep_StationId":"$railway_station_id",
          "Beep_Station_Other":"",
          "Beep_ProductCategoryId":"$product_category_id",
          "Beep_ProductId":"$product_id",
          "Beep_WattTonsId":"$watt_id",
          "Beep_MountingId":"$mounting_id",
          "Beep_NoOfFaultyItem":txt_no_of_faulty.text,
          "Beep_ManufaturerId":"$manufacturer_id",
          "Beep_NatureOfFaulty":txt_nature_of_faulty.text,
          "Beep_Dimension_Led":"0",
          "Beep_Dimension_Down":"0",
          "Beep_Dimension_Tube": dimension
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