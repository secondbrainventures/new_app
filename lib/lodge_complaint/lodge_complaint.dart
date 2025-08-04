import 'dart:convert';
import 'dart:io';
import 'package:eeslsamparkapp/lodge_complaint/ac.dart';
import 'package:eeslsamparkapp/lodge_complaint/agdcm.dart';
import 'package:eeslsamparkapp/lodge_complaint/ajay_phase.dart';
import 'package:eeslsamparkapp/lodge_complaint/beep_scheme.dart';
import 'package:eeslsamparkapp/lodge_complaint/other_scheme.dart';
import 'package:eeslsamparkapp/lodge_complaint/solus_scheme.dart';
import 'package:eeslsamparkapp/lodge_complaint/street_light.dart';
import 'package:eeslsamparkapp/lodge_complaint/ujala_scheme.dart';
import 'package:eeslsamparkapp/model/scheme_list_gs.dart';
import 'package:eeslsamparkapp/start_up/login_as.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:eeslsamparkapp/libary/ars_progress_dialog.dart';
import 'package:eeslsamparkapp/model/scheme_gs.dart';
import 'package:eeslsamparkapp/model/state_gs.dart';
import 'package:eeslsamparkapp/util/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:quiver/async.dart';
import 'package:shared_preferences/shared_preferences.dart';



class LodgeComplaint extends StatefulWidget {



  @override
  _LodgeComplaintScreenState createState() => _LodgeComplaintScreenState();


}

class _LodgeComplaintScreenState extends State<LodgeComplaint>  with WidgetsBindingObserver{

  TextEditingController txt_number = new TextEditingController();
  TextEditingController txt_name = new TextEditingController();

  TextEditingController txt_street_light_address = new TextEditingController();
  TextEditingController txt_street_light_landmark = new TextEditingController();

  TextEditingController txt_ujala_address = new TextEditingController();
  TextEditingController txt_ujala_landmark = new TextEditingController();

  TextEditingController txt_usc = new TextEditingController();
  TextEditingController txt_panel_board = new TextEditingController();
  TextEditingController txt_usc_address = new TextEditingController();
  TextEditingController txt_usc_landmark = new TextEditingController();

  TextEditingController txt_buliding_address = new TextEditingController();
  TextEditingController txt_buliding_landmark = new TextEditingController();

  TextEditingController txt_other_address = new TextEditingController();
  TextEditingController txt_other_landmark = new TextEditingController();

  TextEditingController txt_pole_id = new TextEditingController();
  TextEditingController txt_pole_address = new TextEditingController();
  TextEditingController txt_pole_landmark = new TextEditingController();

  TextEditingController txt_address = new TextEditingController();
  TextEditingController txt_landmark = new TextEditingController();

  TextEditingController txt_email = new TextEditingController();

  TextEditingController txt_soulus_address = new TextEditingController();
  TextEditingController txt_soulus_landmark = new TextEditingController();

  TextEditingController txt_scheme_name = new TextEditingController();
  TextEditingController txt_state_name= new TextEditingController();
  TextEditingController txt_district_name = new TextEditingController();

  List<String> light_type_list = <String>['LED', 'NON-LED'];
  String light_type = "LED";

  List<SchemeResponse> language_list =[];
  String language;
  int language_id;

  List<SchemeListGS> scheme_list = [];
  String scheme;
  int scheme_id;

  List<StateResponse> state_list = [];
  String state;
  int state_id;

  List<StateResponse> district_list = [];
  String district;
  int district_id;

  Widget _widget;
  bool _isdistrictVisible = false;

  SharedPreferences _sharedPreferences;
  ArsProgressDialog _progressDialog;


  CountdownTimer _countdownTimer;



  File imageFile;

  String buttonText;

  Future<Null> pickImage(String source) async {
    var status = await Permission.camera.status;

    if (!status.isGranted) {
      //LocationPermissionInApp().requestCameraPermission();
      AppConfig.showFancyCustomDialogImage(context);
    } else {
      print('picking image');

      try {
        final imagePicked = await ImagePicker().pickImage(
          source: source == 'gallery' ? ImageSource.gallery : ImageSource
              .camera,
        );

        //checking if the user has selected the image
        if (imagePicked == null) return;

        //user has selected the image
        final selectedImage = File(imagePicked.path);

        setState(() {
          imageFile = selectedImage;
        });

        Navigator.pop(context);


        setState(() {
          buttonText = 'Preview Image';
        });
        _getWidget(1);
      } on PlatformException catch (e) {
        //exception could occur if the user has not permitted for the picker

        print('Failed to pick image: $e');
      }
    }
  }



  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    getLoginDetails();



    _widget = Container();

    print('the scheme id in init is $scheme_id');


    // This is initialize the progress dialog
    _progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(AppConfig.PROGRESS_COLOR[0]),
        animationDuration: Duration(milliseconds: 500));

    // This is use for Language list
    List<String> lang_list = <String>['English', 'Hindi', 'Bengali', 'Telugu' , 'Marathi',
      'Tamil','Kannada','Malayalam','Punjabi','Gujarati', 'Other'];

    for (int i = 0; i < lang_list.length; i++) {
      var k = 1;
      k = k+i;
      SchemeResponse scheme = SchemeResponse(id: k , type: lang_list[i]);
      language_list.add(scheme);
    }

  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('Applifecycle state is $state');

    if (state == AppLifecycleState.paused) {
      //user has paused the application

      _countdownTimer =
          CountdownTimer(Duration(minutes: 30), Duration(seconds: 1));

      print(_countdownTimer.elapsed);
    } else if (state == AppLifecycleState.resumed) {
      //user has started using the app

      if (_countdownTimer.remaining > Duration(seconds: 0)) {
        print('app life cycle timer is not completed');

        //let the user start using the app

      } else {
        print('lifecycle state timedout');
        //log user out

        Fluttertoast.showToast(
            msg: 'Sorry but you have been logged out due to inactivity...');

        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => LoginAsPage()));
      }

      _countdownTimer.cancel();
    } else {
      print(
          'the app lifecycle state of app is different than paused or resume');

      print('${AppLifecycleState}');
    }
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
                  text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),
                      fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                    children: <TextSpan>[
                      TextSpan(text: 'Mobile Number'),
                      TextSpan(text: ' *', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                    ],
                  ),
                )),

            Container(
                margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                child: TextFormField(
                    maxLength: 10,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                    ],
                    controller: txt_number,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: 'Enter Your Mobile Number', counter: Container(),
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
                      TextSpan(text: 'Name '),
                      TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                    ],
                  ),
                )),

            Container(
                margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                child: TextFormField(
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]")),
                    ],
                    controller: txt_name, textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                        hintText: 'Your Enter Your Name', counter: Container(),
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
                      SchemeListGS response) {
                    return DropdownMenuItem<SchemeListGS>(
                        value: response,
                        child: Text(response.schemeName));
                  },
                  ).toList(),

                  onChanged: (SchemeListGS response) {
                    FocusScope.of(context).requestFocus(new FocusNode());

                    print('scheme name is ${response.schemeName}');
                    print('scheme id is ${response.id}');
                    setState(() {
                      scheme = response.schemeName;
                      scheme_id = response.id;
                      _getWidget(response.id);
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

            scheme_id == 1 ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(left: 15,top: 10),
                    child: Text("Light Type", style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15))),

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
                      hint: light_type == null ?

                      Padding(
                          padding: EdgeInsets.only(left: 5, right: 10),
                          child: Text('Select Light Type', style: TextStyle(color: Colors.grey, fontSize: 17)))
                          : Padding(padding: EdgeInsets.only(left: 5, right: 10),
                          child: Text(light_type, style: TextStyle(color: Colors.black))),

                      isExpanded: true,
                      iconSize: 30.0,
                      style: TextStyle(color: Colors.black),

                      items: light_type_list.map((
                          String response) {
                        return DropdownMenuItem<String>(
                            value: response,
                            child: Text(response));
                      },
                      ).toList(),

                      onChanged: (String response) {
                        setState(() {
                          light_type = response;

                          if(light_type.toLowerCase() == "non-led") {

                            light_type = "LED";
                            openAlertBox();


                          }

                        },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ) : Container(),

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

                      _getAllDistrict(state_id, scheme_id);
                    },
                    );
                  },
                ),
              ),
            ),

            Column(
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

                        _getWidget(scheme_id);
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
            ),

            _widget,

            SizedBox(height: 20.0),

            Center(
              child: ElevatedButton(
                  child: Text('NEXT',style : TextStyle(color: Colors.white, fontFamily: AppConfig.FONT_TYPE_BOLD,fontSize: 16.0)),
                  onPressed: () {

                    FocusScope.of(context).requestFocus(new FocusNode());

                    switch(scheme_id) {

                      case 1:
                        if(txt_number.text.length != 10 || txt_number.text.startsWith(RegExp(r'[0-5]'))) {
                          Fluttertoast.showToast(msg: "Please enter Valid Mobile Number");
                        } else if (txt_name.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please enter Name");
                        } else if (state_id == null) {
                          Fluttertoast.showToast(msg: "Please select state");
                        } else if (district_id == null) {
                          Fluttertoast.showToast(msg: "Please select District");
                        } else if (txt_street_light_address.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please enter address");
                        } else if (txt_street_light_landmark.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please enter Landmark");
                        } else if (light_type == "NON-LED") {
                          Fluttertoast.showToast(msg: "We don't take NON_LED complaint");
                        } else{

                          if(buttonText == null) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => StreetLightScheme(scheme_id, state_id,
                                    district_id,txt_number.text, txt_name.text, txt_street_light_address.text,
                                    txt_street_light_landmark.text,state,district,"")));
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => StreetLightScheme(scheme_id, state_id,
                                    district_id,txt_number.text, txt_name.text, txt_street_light_address.text,
                                    txt_street_light_landmark.text,state,district,AppConfig.encodeImage(imageFile))));
                          }


                        }
                        break;

                      case 2:

                        if(txt_number.text.length != 10 || txt_number.text.startsWith(RegExp(r'[0-5]'))) {
                          Fluttertoast.showToast(msg: "Please enter Valid Mobile Number");
                        } else if (txt_name.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please enter Name");
                        } else if (state_id == null) {
                          Fluttertoast.showToast(msg: "Please select state");
                        } else if (district_id == null) {
                          Fluttertoast.showToast(msg: "Please select District");
                        } else if (txt_ujala_address.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please enter address");
                        } else if (txt_ujala_landmark.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please enter Landmark");
                        }  else {
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) =>
                              UjalaScheme(scheme_id, state_id, district_id,txt_number.text, txt_name.text,
                                  txt_ujala_address.text, txt_ujala_landmark.text,state,district)));
                        }

                        break;

                      case 3:

                        if(txt_number.text.length != 10 || txt_number.text.startsWith(RegExp(r'[0-5]'))) {
                          Fluttertoast.showToast(msg: "Please enter Valid Mobile Number");
                        } else if (txt_name.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please enter Name");
                        } else if (state_id == null) {
                          Fluttertoast.showToast(msg: "Please select state");
                        } else if (district_id == null) {
                          Fluttertoast.showToast(msg: "Please select District");
                        } else if (txt_usc.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please enter USC No. or Service Connection no");
                        } else {

                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) =>
                              AgdcmScheme(scheme_id, state_id, district_id,txt_number.text,
                                  txt_name.text, txt_usc.text, txt_panel_board.text,
                                  txt_usc_address.text, txt_usc_landmark.text,state,district)));
                        }

                        break;

                    // case 4:

                    //   if(txt_number.text.length != 10 || txt_number.text.startsWith(RegExp(r'[0-5]'))) {
                    //     Fluttertoast.showToast(msg: "Please enter Valid Mobile Number");
                    //   } else if (txt_name.text.isEmpty) {
                    //     Fluttertoast.showToast(msg: "Please enter Name");
                    //   } else if (state_id == null) {
                    //     Fluttertoast.showToast(msg: "Please select state");
                    //   } else if (district_id == null) {
                    //     Fluttertoast.showToast(msg: "Please select District");
                    //   } else if (txt_buliding_address.text.isEmpty) {
                    //     Fluttertoast.showToast(msg: "Please enter address");
                    //   } else {
                    //     Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) =>
                    //         BuildingScheme(scheme_id, state_id, district_id,txt_number.text,
                    //             txt_name.text,txt_buliding_address.text, txt_buliding_landmark.text,state,district)));
                    //   }

                    //   break;

                      case 5:
                        if(txt_number.text.length != 10 || txt_number.text.startsWith(RegExp(r'[0-5]'))) {
                          Fluttertoast.showToast(msg: "Please enter Valid Mobile Number");
                        } else if (txt_name.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please enter Name");
                        } else if (state_id == null) {
                          Fluttertoast.showToast(msg: "Please select state");
                        } else if (district_id == null) {
                          Fluttertoast.showToast(msg: "Please select District");
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) =>
                              OtherScheme(scheme_id, state_id, district_id,txt_number.text, txt_name.text,
                                  txt_other_address.text, txt_other_landmark.text,state,district)));
                        }

                        break;

                      case 6:

                        if(txt_number.text.length != 10 || txt_number.text.startsWith(RegExp(r'[0-5]'))) {
                          Fluttertoast.showToast(msg: "Please enter Valid Mobile Number");
                        } else if (txt_name.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please enter Name");
                        } else if (state_id == null) {
                          Fluttertoast.showToast(msg: "Please select state");
                        } else if (district_id == null) {
                          Fluttertoast.showToast(msg: "Please select District");
                        } else if (txt_pole_address.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please enter address");
                        } else if (txt_pole_id.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please enter Pole Id");
                        }  else {
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) =>
                              AjayPhaseScheme(scheme_id, state_id, district_id,txt_number.text, txt_name.text,
                                  txt_pole_id.text,txt_pole_address.text, txt_pole_landmark.text,state,district)));
                        }
                        break;

                      case 7:

                        if(txt_number.text.length != 10 || txt_number.text.startsWith(RegExp(r'[0-5]'))) {
                          Fluttertoast.showToast(msg: "Please enter Valid Mobile Number");
                        } else if (txt_name.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please enter Name");
                        } else if (state_id == null) {
                          Fluttertoast.showToast(msg: "Please select state");
                        } else if (district_id == null) {
                          Fluttertoast.showToast(msg: "Please select District");
                        } else if (txt_email.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please enter email id");
                        } else {

                          var email = txt_email.text;
                          bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);

                          if(emailValid) {
                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) =>
                                AcScheme(scheme_id, state_id, district_id,txt_number.text,
                                    txt_name.text,txt_email.text, state,district)));
                          } else {
                            Fluttertoast.showToast(msg: "Email id not valid");
                          }


                        }
                        break;

                      case 8:

                        if(txt_number.text.length != 10 || txt_number.text.startsWith(RegExp(r'[0-5]'))) {
                          Fluttertoast.showToast(msg: "Please enter Valid Mobile Number");
                        } else if (txt_name.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please enter Name");
                        } else if (state_id == null) {
                          Fluttertoast.showToast(msg: "Please select state");
                        } else if (district_id == null) {
                          Fluttertoast.showToast(msg: "Please select District");
                        } else if (txt_pole_address.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please enter address");
                        } else if (txt_pole_id.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please enter Pole Id");
                        }  else {
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) =>
                              AjayPhaseScheme(scheme_id, state_id, district_id,txt_number.text, txt_name.text,
                                  txt_pole_id.text,txt_pole_address.text, txt_pole_landmark.text,state,district)));
                        }

                        break;

                    // case 9:

                    //   if(txt_number.text.length != 10 || txt_number.text.startsWith(RegExp(r'[0-5]'))) {
                    //     Fluttertoast.showToast(msg: "Please enter Valid Mobile Number");
                    //   } else if (txt_name.text.isEmpty) {
                    //     Fluttertoast.showToast(msg: "Please enter Name");
                    //   } else if (state_id == null) {
                    //     Fluttertoast.showToast(msg: "Please select state");
                    //   } else {
                    //     Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) =>
                    //         RailwayScheme(scheme_id, state_id, district_id,txt_number.text,
                    //             txt_name.text,txt_address.text, state,district)));
                    //   }

                    //   break;

                      case 10:

                        if(txt_number.text.length != 10 || txt_number.text.startsWith(RegExp(r'[0-5]'))) {
                          Fluttertoast.showToast(msg: "Please enter Valid Mobile Number");
                        } else if (txt_name.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please enter Name");
                        } else if (state_id == null) {
                          Fluttertoast.showToast(msg: "Please select state");
                        } else if (district_id == null) {
                          Fluttertoast.showToast(msg: "Please select District");
                        } else if (txt_soulus_address.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please enter address");
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) =>
                              SolusScheme(scheme_id, state_id, district_id,txt_number.text,
                                  txt_name.text,txt_soulus_address.text, txt_soulus_landmark.text,state,district)));
                        }

                        break;

                      case 11:

                        if(txt_number.text.length != 10 || txt_number.text.startsWith(RegExp(r'[0-5]'))) {
                          Fluttertoast.showToast(msg: "Please enter Valid Mobile Number");
                        } else if (txt_name.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please enter Name");
                        } else if (state_id == null) {
                          Fluttertoast.showToast(msg: "Please select state");
                        }
                        else if (district_id == null) {
                          Fluttertoast.showToast(msg: "Please select District");
                        }
                        else if (txt_street_light_address.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please enter address");
                        }
                        else {
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) =>
                              BeepScheme(scheme_id, state_id, district_id,txt_number.text,
                                  txt_name.text,txt_street_light_address.text, state,district)));
                        }

                        break;
                      default :
                        Fluttertoast.showToast(msg: "Please Select Scheme First");
                        break;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Color(AppConfig.BLUE_COLOR[0]),
                      padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10))
              ),
            ),

            SizedBox(height: 10),

          ],
        ),
      ),
    );
  }

  Future<dynamic> bottomsheetUploads(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) {
        return Material(
          child: Container(
            height: 200,
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                ListTile(
                  onTap: () => pickImage('camera'),
                  title: const Text('Camera'),
                ),
                const Divider(
                  height: 1.0,
                ),
                ListTile(
                  onTap: () => pickImage('gallery'),
                  title: const Text('Gallery'),
                ),
                const Divider(
                  height: 2.0,
                ),
                ListTile(
                  onTap: () => Navigator.pop(context),
                  title: const Text('Cancel'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> bottomsheetShow(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) {
        return Material(
          child: Container(
            height: 200,
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [

                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    bottomsheetUploads(context);
                  },
                  title: const Text('New Upload'),
                ),
                const Divider(
                  height: 2.0,
                ),
                ListTile(
                  onTap: () => Navigator.pop(context),
                  title: const Text('Cancel'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _getWidget(int id) {

    switch(id) {

      case 1 : _widget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(padding: EdgeInsets.only(left: 15,top: 10),
              child: RichText(
                text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD,fontSize: 15),
                  children: <TextSpan>[
                    TextSpan(text: 'Address '),
                    TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                  ],
                ),
              )),

          Container(
              margin: EdgeInsets.only(left: 10, right: 10,top: 10),
              child: TextFormField(
                  controller: txt_street_light_address,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,&#-]")),
                  ],
                  decoration: InputDecoration(
                      hintText: 'Address',
                      contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      filled: true,
                      hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                      border: InputBorder.none,
                      fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                  style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))),

          Padding(
              padding: EdgeInsets.only(left: 15,top: 10),
              child: RichText(
                text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD,fontSize: 15),
                  children: <TextSpan>[
                    TextSpan(text: 'Landmark '),
                    TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                  ],
                ),
              )),

          Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
              child: TextFormField(
                  controller: txt_street_light_landmark,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,&#-]")),
                  ],
                  decoration: InputDecoration(
                      hintText: 'Landmark', counter: Container(),
                      contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      filled: true,
                      hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                      border: InputBorder.none,
                      fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                  style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))),



          //upload images from gallery or camera
          Padding(
            padding: EdgeInsets.only(left: 15,top: 10),
            child: RichText(
              text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD,fontSize: 15),
                children: <TextSpan>[
                  TextSpan(text: 'Upload Image '),
                  TextSpan(text: '', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                ],
              ),
            ),),

          SizedBox(height:10),



          Align(
            alignment: Alignment.center,
            child: ElevatedButton(onPressed: (){

              imageFile==null?bottomsheetUploads(context):

              bottomsheetShow(context);

            },
                child: Text(
                  //  imageFile==null?
                  //  'Upload Image':'Preview Image',

                    buttonText==null?'Upload Image':'Preview Image',

                    style : TextStyle(color: Colors.white, fontFamily: AppConfig.FONT_TYPE_BOLD,fontSize: 16.0))),
          ),
        ],
      );
      break;

      case 2 : _widget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(padding: EdgeInsets.only(left: 15,top: 10),
              child: RichText(
                text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD,fontSize: 15),
                  children: <TextSpan>[
                    TextSpan(text: 'Address '),
                    TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                  ],
                ),
              )),

          Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
              child: TextFormField(
                  controller: txt_ujala_address,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,&#-]")),
                  ],
                  decoration: InputDecoration(
                      hintText: 'Address',
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
                    TextSpan(text: 'Landmark '),
                    TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                  ],
                ),
              )),


          Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
              child: TextFormField(
                  controller: txt_ujala_landmark,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,&#-]")),
                  ],
                  decoration: InputDecoration(
                      hintText: 'Landmark', counter: Container(),
                      contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      filled: true,
                      hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                      border: InputBorder.none,
                      fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                  style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))),

        ],
      );
      break;

      case 3:  _widget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(padding: EdgeInsets.only(left: 15,top: 10),
              child: RichText(
                text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD,fontSize: 15),
                  children: <TextSpan>[
                    TextSpan(text: 'USC No./Service Connection No. '),
                    TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                  ],
                ),
              )),

          Container(
              margin: EdgeInsets.only(left: 10, right: 10,top: 10),
              child: TextFormField(
                  controller: txt_usc,
                  decoration: InputDecoration(
                      hintText: 'USC No./Service Connection No.',
                      contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      filled: true,
                      hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                      border: InputBorder.none,
                      fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                  style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))),

          Padding(padding: EdgeInsets.only(left: 15,top: 20),
              child: Text("Panel Board Mobile No",
                  style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15))),

          Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
              child: TextFormField(
                  controller: txt_panel_board,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                  ],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: 'Panel Board Mobile No',
                      contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      filled: true,
                      hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                      border: InputBorder.none,
                      fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                  style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))),

          Padding(padding: EdgeInsets.only(left: 15,top: 20), child: Text("Address",
              style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15))),

          Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
              child: TextFormField(
                  controller: txt_usc_address,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,&#-]")),
                  ],
                  decoration: InputDecoration(
                      hintText: 'Address',
                      contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      filled: true,
                      hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                      border: InputBorder.none,
                      fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                  style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))),

          Padding(padding: EdgeInsets.only(left: 15,top: 20), child: Text("Mandal/ Panchayat", style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15))),

          Container(
              margin: EdgeInsets.only(left: 10, right: 10,top: 10),
              child: TextFormField(
                  controller: txt_usc_landmark,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,&#-]")),
                  ],
                  decoration: InputDecoration(
                      hintText: 'Landmark', counter: Container(),
                      contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      filled: true,
                      hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                      border: InputBorder.none,
                      fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                  style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))),

        ],
      );
      break;

    // case 4 : _widget = Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [

    //     Padding(padding: EdgeInsets.only(left: 15,top: 10),
    //         child: RichText(
    //           text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD,fontSize: 15),
    //             children: <TextSpan>[
    //               TextSpan(text: 'Address '),
    //               TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
    //             ],
    //           ),
    //         )),

    //     Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
    //         child: TextFormField(
    //             controller: txt_buliding_address,
    //             inputFormatters: <TextInputFormatter>[
    //               FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,&#-]")),
    //             ],
    //             decoration: InputDecoration(
    //                 hintText: 'Address',
    //                 contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
    //                 filled: true,
    //                 hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
    //                 border: InputBorder.none,
    //                 fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
    //             style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))),

    //     Padding(padding: EdgeInsets.only(left: 15,top: 20), child: Text("Landmark", style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15))),

    //     Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
    //         child: TextFormField(
    //             controller: txt_buliding_landmark,
    //             inputFormatters: <TextInputFormatter>[
    //               FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,&#-]")),
    //             ],
    //             decoration: InputDecoration(
    //                 hintText: 'Landmark', counter: Container(),
    //                 contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
    //                 filled: true,
    //                 hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
    //                 border: InputBorder.none,
    //                 fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
    //             style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))),

    //   ],
    // );
    // break;

      case 5 : _widget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(padding: EdgeInsets.only(left: 15,top: 20), child: Text("Address", style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15))),

          Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
              child: TextFormField(
                  controller: txt_other_address,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,&#-]")),
                  ],
                  decoration: InputDecoration(
                      hintText: 'Address',
                      contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      filled: true,
                      hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                      border: InputBorder.none,
                      fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                  style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))),

          Padding(padding: EdgeInsets.only(left: 15,top: 20), child: Text("Landmark", style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15))),

          Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
              child: TextFormField(
                  controller: txt_other_landmark,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,&#-]")),
                  ],
                  decoration: InputDecoration(
                      hintText: 'Landmark', counter: Container(),
                      contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      filled: true,
                      hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                      border: InputBorder.none,
                      fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                  style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))),

        ],
      );
      break;

      case 6: _widget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(padding: EdgeInsets.only(left: 15,top: 10),
              child: RichText(
                text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD,fontSize: 15),
                  children: <TextSpan>[
                    TextSpan(text: 'Pole ID '),
                    TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                  ],
                ),
              )),

          Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
              child: TextFormField(
                  controller: txt_pole_id,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,&#-_]")),
                  ],
                  decoration: InputDecoration(
                      hintText: 'Pole ID',
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
                    TextSpan(text: 'Address '),
                    TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                  ],
                ),
              )),

          Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
              child: TextFormField(
                  controller: txt_pole_address,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,&#-]")),
                  ],
                  decoration: InputDecoration(
                      hintText: 'Address',
                      contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      filled: true,
                      hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                      border: InputBorder.none,
                      fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                  style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))),

          Padding(padding: EdgeInsets.only(left: 15,top: 20),
              child: Text("Landmark",
                  style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15))),

          Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
              child: TextFormField(
                  controller: txt_pole_landmark,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,&#-]")),
                  ],
                  decoration: InputDecoration(
                      hintText: 'Landmark', counter: Container(),
                      contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      filled: true,
                      hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                      border: InputBorder.none,
                      fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                  style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))),

        ],
      );
      break;

      case 7 : _widget =  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(padding: EdgeInsets.only(left: 15,top: 10),
              child: RichText(
                text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                  children: <TextSpan>[
                    TextSpan(text: 'Email '),
                    TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                  ],
                ),
              )),

          Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
              child: TextFormField(
                  controller: txt_email,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,&#-@._-]")),
                  ],
                  decoration: InputDecoration(
                      hintText: 'Email',
                      contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      filled: true,
                      hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                      border: InputBorder.none,
                      fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                  style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))),
        ],
      );
      break;

      case 8: _widget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(padding: EdgeInsets.only(left: 15,top: 20),
              child: RichText(
                text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD,fontSize: 15),
                  children: <TextSpan>[
                    TextSpan(text: 'Pole ID '),
                    TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                  ],
                ),
              )),

          Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
              child: TextFormField(
                  controller: txt_pole_id,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,&#-_]")),
                  ],
                  decoration: InputDecoration(
                      hintText: 'Pole ID',
                      contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      filled: true,
                      hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                      border: InputBorder.none,
                      fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                  style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))),


          Padding(padding: EdgeInsets.only(left: 15,top: 20),
              child: RichText(
                text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD,fontSize: 15),
                  children: <TextSpan>[
                    TextSpan(text: 'Address '),
                    TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                  ],
                ),
              )),

          Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
              child: TextFormField(
                  controller: txt_pole_address,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,&#-_]")),
                  ],
                  decoration: InputDecoration(
                      hintText: 'Address',
                      contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      filled: true,
                      hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                      border: InputBorder.none,
                      fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                  style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))),

          Padding(padding: EdgeInsets.only(left: 15,top: 20), child: Text("Landmark", style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15))),

          Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
              child: TextFormField(
                  controller: txt_pole_landmark,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,&#-]")),
                  ],
                  decoration: InputDecoration(
                      hintText: 'Landmark', counter: Container(),
                      contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      filled: true,
                      hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                      border: InputBorder.none,
                      fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                  style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))),

        ],
      );
      break;

    // case 9: _widget = Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [

    //     Padding(padding: EdgeInsets.only(left: 15,top: 20), child: Text("Address", style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15))),

    //     Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
    //         child: TextFormField(
    //             controller: txt_address,
    //             inputFormatters: <TextInputFormatter>[
    //               FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,&#-_]")),
    //             ],
    //             decoration: InputDecoration(
    //                 hintText: 'Address',
    //                 contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
    //                 filled: true,
    //                 hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
    //                 border: InputBorder.none,
    //                 fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
    //             style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))),

    //   ],
    // );
    // break;

      case 10 : _widget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(padding: EdgeInsets.only(left: 15,top: 10),
              child: RichText(
                text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD,fontSize: 15),
                  children: <TextSpan>[
                    TextSpan(text: 'Address '),
                    TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                  ],
                ),
              )),

          Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
              child: TextFormField(
                  controller: txt_soulus_address,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,&#-_]")),
                  ],
                  decoration: InputDecoration(
                      hintText: 'Address',
                      contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      filled: true,
                      hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                      border: InputBorder.none,
                      fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                  style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))),

          Padding(padding: EdgeInsets.only(left: 15,top: 20), child: Text("Landmark", style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15))),

          Container(margin: EdgeInsets.only(left: 10, right: 10,top: 10),
              child: TextFormField(controller: txt_soulus_landmark, textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                      hintText: 'Landmark', counter: Container(),
                      contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      filled: true,
                      hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                      border: InputBorder.none,
                      fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                  style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))),

        ],
      );
      break;


      case 11 : _widget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(padding: EdgeInsets.only(left: 15,top: 10),
              child: RichText(
                text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD,fontSize: 15),
                  children: <TextSpan>[
                    TextSpan(text: 'Address '),
                    TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                  ],
                ),
              )),

          Container(
              margin: EdgeInsets.only(left: 10, right: 10,top: 10),
              child: TextFormField(
                  controller: txt_street_light_address,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ,&#-]")),
                  ],
                  decoration: InputDecoration(
                      hintText: 'Address',
                      contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      filled: true,
                      hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                      border: InputBorder.none,
                      fillColor: Color(AppConfig.LIGHT_GRAY_COLOR[0])),
                  style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black))),

        ],
      );
      break;

      default: _widget = Container();
      break;

    }
  }

  getLoginDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      txt_number.text = _sharedPreferences.getString(AppConfig.MOBILE_NUMBER);
      txt_name.text = _sharedPreferences.getString(AppConfig.NAME);
      txt_email.text = _sharedPreferences.getString(AppConfig.EMAIL_ID);

      txt_street_light_address.text = _sharedPreferences.getString(AppConfig.ADDRESS);
      txt_ujala_address.text = _sharedPreferences.getString(AppConfig.ADDRESS);
      txt_usc_address.text = _sharedPreferences.getString(AppConfig.ADDRESS);
      txt_buliding_address.text = _sharedPreferences.getString(AppConfig.ADDRESS);
      txt_other_address.text = _sharedPreferences.getString(AppConfig.ADDRESS);
      txt_pole_address.text = _sharedPreferences.getString(AppConfig.ADDRESS);
      txt_soulus_address.text = _sharedPreferences.getString(AppConfig.ADDRESS);

      scheme = _sharedPreferences.getString(AppConfig.SCHEME_NAME);
      state = _sharedPreferences.getString(AppConfig.STATE_NAME);
      district = _sharedPreferences.getString(AppConfig.DISTRICT_NAME);
      scheme_id = _sharedPreferences.getInt(AppConfig.SCHEME_ID);

      state_id = _sharedPreferences.getInt(AppConfig.STATE_ID);
      district_id = _sharedPreferences.getInt(AppConfig.DISTRICT_ID);
      scheme_id = _sharedPreferences.getInt(AppConfig.SCHEME_ID);

    });

    print(scheme);
    print('$state  $state_id');
    print('$scheme $scheme_id');
    print('$district $district_id');

    _sharedPreferences.getString(AppConfig.USER_TYPE)=="B2B-USER"?"":_getSchemeList();
    _sharedPreferences.getString(AppConfig.USER_TYPE)=="B2B-USER"?"":_getAllState(scheme_id);


    //  _getSchemeList();
    _getAllDistrict(state_id, scheme_id);


  }

  _getSchemeList() async {

    _progressDialog.show();
    print('get all the schemes list ${AppConfig.GET_SCHEME_LIST}');
    var response = await http.Client().get(Uri.parse(AppConfig.GET_SCHEME_LIST),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});
    print(response.body);
    setState(() {

      var jsonData = json.decode(response.body);
      var responseObj = jsonData["responseObj"] as List;

      for (var model in responseObj) {

        print('the values inside  ${model['id']}');

        if (model['id'] !=4  && model['id']!=9) {

          scheme_list.add(new SchemeListGS.fromJson(model));

        }
      }

    });
    _progressDialog.dismiss();
  }

  _getAllState(int id) async {

    _progressDialog.show();
    print('get all states ${AppConfig.API_GET_STATE}$id');

    var response = await http.Client().get(Uri.parse("${AppConfig.API_GET_STATE}$id"),
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

  _getAllDistrict(int id, int schemeid) async {

    String url = "";

    if(scheme_id == 10) {
      url = "${AppConfig.GET_SOUL_BLOCK_LIST}$id";
    } else {
      url = "${AppConfig.API_GET_STATE_WISE_DISTRICT}$schemeid&StateId=$id";
    }

    print('get all disctricts $url');
    print(id);
    print(schemeid);

    _progressDialog.show();
    var response = await http.Client().get(Uri.parse(url),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});


    print(response.body);

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

  openAlertBox() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("We don't take NON-LED complaint ",textAlign:TextAlign.center,
                        style: TextStyle(fontSize: 18.0, color: Colors.black)),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                      decoration: BoxDecoration(color: Color(AppConfig.BLUE_COLOR[0]),),
                      child: Text(
                        "OKAY!",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

}
