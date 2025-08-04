
import 'dart:convert';
import 'package:eeslsamparkapp/model/compalint_status_gs.dart';
import 'package:eeslsamparkapp/start_up/login_as.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:eeslsamparkapp/complaint_status/compalint_status_result.dart';
import 'package:eeslsamparkapp/libary/ars_progress_dialog.dart';
import 'package:eeslsamparkapp/model/compaint_status_list.dart';
import 'package:eeslsamparkapp/util/app_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiver/async.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ComplainStatusList extends StatefulWidget {
  @override
  _ComplainStatusListState createState() => _ComplainStatusListState();
}


class _ComplainStatusListState extends State<ComplainStatusList> with WidgetsBindingObserver{

  TextEditingController txt_complain = new TextEditingController(text: "");

  SharedPreferences _sharedPreferences;
  ArsProgressDialog _progressDialog;

  String complaintID ="", callerNumber="", callerName="", schemeName="", callStatus="";
  final List<ComplaintStatusListResponse> status_list = [];
  CountdownTimer _countdownTimer;

  TextEditingController txt_remark = new TextEditingController();
  String dropdownValue = 'Close';
  double rating = 0.0;

  final List<ComplaintStatusResponse> status_list_one = [];
  final List<ComplaintStatusResponse> status_list_two = [];

  final List<bool> visible_list = [];

  int segmentedControlGroupValue = 0;
  final Map<int, Widget> myTabs = const <int, Widget>{
    0: Text("   Closed   "),
    1: Text("   ReOpen   ")
  };

  getLoginDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _getTopComplaints();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getLoginDetails();
    // This is initialize the progress dialog
    _progressDialog = ArsProgressDialog(context, blur: 2,
        backgroundColor: Color(AppConfig.PROGRESS_COLOR[0]),
        animationDuration: Duration(milliseconds: 500));

  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {


    print('Applifecycle state is $state');

    if (state==AppLifecycleState.paused) {


      //user has paused the application

      _countdownTimer=CountdownTimer(Duration(minutes: 30), Duration(seconds: 1));

      print(_countdownTimer.elapsed);

    } else if (state==AppLifecycleState.resumed) {


      //user has started using the app


      if (_countdownTimer.remaining>Duration(seconds: 0)) {

        print('app life cycle timer is not completed');

        //let the user start using the app


      } else {

        print('lifecycle state timedout');
        //log user out

        Fluttertoast.showToast(msg: 'Sorry but you have been logged out due to inactivity...');

        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginAsPage()));

      }


      _countdownTimer.cancel();





    }else{

      print('the app lifecycle state of app is different than paused or resume');

      print('${AppLifecycleState}');




    }





  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: AppBar(title: Text("Complaint Status", style: TextStyle(fontSize: 18,
                color: Colors.white, fontFamily: AppConfig.FONT_TYPE_BOLD)),
                centerTitle: true, backgroundColor: Color(AppConfig.BLUE_COLOR[0]))),

        body: SafeArea(
          child: Container(
            color: Color(AppConfig.LIGHT_GRAY_COLOR[0]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                SizedBox(height: 15),

                Row(
                  children: [

                    Expanded(
                        flex: 8,
                        child: Container(
                            margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                            child: TextFormField(
                                controller: txt_complain,
                                textCapitalization: TextCapitalization.characters,
                                maxLength: 12,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z #-_]")),
                                ],
                                decoration: InputDecoration(
                                  enabledBorder:  OutlineInputBorder(
                                      borderSide:  BorderSide(color: Colors.grey, width: 0.0),
                                      borderRadius: BorderRadius.circular(5.0)),
                                  hintText: 'Search', counter: Container(),
                                  contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 15.0),
                                  filled: true,
                                  hintStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),fontSize: 14),
                                  fillColor: Colors.white,
                                  // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
                                ),
                                style: new TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black)))),

                    Expanded(
                      flex: 2,
                      child:  Padding(
                        padding: const EdgeInsets.only(left:8.0,right: 10),
                        child: Container(
                          height: 45,
                          child: ElevatedButton(

                              child: Icon(Icons.search,size: 28,),
                              onPressed: () {

                                if(txt_complain.text.length >= 10) {
                                  _getAllData();
                                } else {
                                  Fluttertoast.showToast(msg: "Please enter valid Complain ID or Mobile Number");
                                }
                              }, style: ElevatedButton.styleFrom(
                              primary: Color(AppConfig.BLUE_COLOR[0]))
                          ),
                        ),
                      ),)



                  ],
                ),

                SizedBox(height: 10),

                Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text('Your Complaints ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.black))),

                Flexible(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: status_list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                            margin: EdgeInsets.only(left:5,right: 5, bottom: 10,top: 10),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
                                color:Colors.white),

                            child: InkWell(
                              onTap: () {

                                setState(() {

                                  if (visible_list[index] == true) {
                                    visible_list[index] = false;
                                  } else {
                                    visible_list[index] = true;
                                    _getSingleComplaintData(status_list[index].complaintID.toString());
                                  }

                                });


                                // Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ComplainStatus(status_list[index].complaintID)));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [

                                        Expanded(
                                            flex: 8,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [

                                                SizedBox(height: 5),

                                                Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: Text("Complaint Date : ${status_list[index].compDate}",
                                                        style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),
                                                            fontFamily: AppConfig.FONT_TYPE_REGULAR, fontSize: 14))),


                                                Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: Text("Complaint ID : ${status_list[index].complaintID}",
                                                        style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]),
                                                            fontFamily: AppConfig.FONT_TYPE_REGULAR, fontSize: 14))),


                                                Row(
                                                  children: [

                                                    Padding(
                                                        padding: const EdgeInsets.all(4.0),
                                                        child: Text("Complaint Status : ",
                                                            style: TextStyle(
                                                                color: Color(AppConfig.BLUE_COLOR[1]),
                                                                fontFamily: AppConfig.FONT_TYPE_REGULAR, fontSize: 14))),

                                                    status_list[index].callStatus.toLowerCase() == "open" ? Padding(
                                                        padding: const EdgeInsets.all(4.0),
                                                        child: Text(status_list[index].callStatus,
                                                            style: TextStyle(color: Colors.red,backgroundColor: Colors.red[100],
                                                                fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 14)))


                                                        : status_list[index].callStatus.toLowerCase() == "escalated" ?

                                                    Padding(
                                                        padding: const EdgeInsets.all(4.0),
                                                        child: Text(status_list[index].callStatus,
                                                            style: TextStyle(color: Colors.red,backgroundColor: Colors.red[100],
                                                                fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 14))
                                                    ) :

                                                    status_list[index].callStatus.toLowerCase() == "rectified" ?

                                                    Padding(
                                                        padding: const EdgeInsets.all(4.0),
                                                        child: Text(status_list[index].callStatus,
                                                            style: TextStyle(color: Colors.orange,backgroundColor: Colors.orange[100],
                                                                fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 14))
                                                    ) :

                                                    Padding(
                                                        padding: const EdgeInsets.all(4.0),
                                                        child: Text(status_list[index].callStatus,
                                                            style: TextStyle(color: Colors.green,backgroundColor: Colors.green[100],
                                                                fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 14))
                                                    ),

                                                  ],
                                                ),

                                                SizedBox(height: 5),


                                              ],
                                            )),

                                        Expanded(
                                            flex: 2,
                                            child: Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Color(AppConfig.LIGHT_GRAY_COLOR[0]),
                                                shape: BoxShape.circle,),
                                              child: IconButton(icon: visible_list[index] == false ? Icon(Icons.arrow_forward_ios,size: 23) : Icon(Icons.keyboard_arrow_down,size: 33,
                                                  color: Color(AppConfig.BLUE_COLOR[1]))),
                                            ))

                                      ],
                                    ),

                                    Visibility(
                                      visible: visible_list[index],
                                      child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[


                                              Stack(

                                                children: [

                                                  Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Padding(padding: const EdgeInsets.all(4.0),
                                                          child: Text("Mobile Number : ", style: TextStyle(fontSize: 14.0,
                                                              color: Color(AppConfig.BLUE_COLOR[1]))))),

                                                  Align(
                                                      alignment: Alignment.centerRight,
                                                      child: Padding(padding: const EdgeInsets.all(4.0),
                                                          child: Text(callerNumber, style: TextStyle(fontSize: 14.0,
                                                              color: Colors.black,fontFamily: AppConfig.FONT_TYPE_REGULAR)))),


                                                ],
                                              ),

                                              Stack(

                                                children: [

                                                  Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Padding(padding: const EdgeInsets.all(4.0),
                                                          child: Text(" Name : ", style: TextStyle(fontSize: 14.0,
                                                              color: Color(AppConfig.BLUE_COLOR[1]))))),

                                                  Align(
                                                      alignment: Alignment.centerRight,
                                                      child: Padding(padding: const EdgeInsets.all(4.0),
                                                          child: Text(callerName, style: TextStyle(fontSize: 14.0,
                                                              color: Colors.black,fontFamily: AppConfig.FONT_TYPE_REGULAR)))),


                                                ],
                                              ),

                                              Stack(

                                                children: [

                                                  Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Padding(padding: const EdgeInsets.all(4.0),
                                                          child: Text("Scheme Name : ", style: TextStyle(fontSize: 14.0,
                                                              color: Color(AppConfig.BLUE_COLOR[1]))))),

                                                  Align(
                                                      alignment: Alignment.centerRight,
                                                      child: Padding(padding: const EdgeInsets.all(4.0),
                                                          child: Text(schemeName, style: TextStyle(fontSize: 14.0,
                                                              color: Colors.black,fontFamily: AppConfig.FONT_TYPE_REGULAR)))),


                                                ],
                                              ),

                                              SizedBox(height: 15),


                                              Visibility(
                                                visible: status_list[index].callStatus.toLowerCase() == "rectified" ? true : false,
                                                child: Column(
                                                  children: [

                                                    Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: Container(
                                                        height: 40,
                                                        width: double.infinity,
                                                        color: Color(AppConfig.BLUE_COLOR[0]),
                                                        child: Center(child: Text("Manage Status",style: TextStyle(fontSize: 14.0,
                                                            color: Colors.white,fontFamily: AppConfig.FONT_TYPE_BOLD))),
                                                      ),
                                                    ),



                                                    Stack(

                                                      children: [

                                                        Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: Padding(padding: const EdgeInsets.only(left:4.0, top: 5),
                                                                child: Text("please update the status of your complaint : ", style: TextStyle(fontSize: 12.0,
                                                                    color: Color(AppConfig.BLUE_COLOR[1]),fontFamily: AppConfig.FONT_TYPE_BOLD)))),

                                                      ],
                                                    ),


                                                    Stack(
                                                      children: [
                                                        Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: Padding(padding: const EdgeInsets.only(left:14.0, top :20),
                                                                child: Text("Status : ", style: TextStyle(fontSize: 16.0,
                                                                    color: Color(AppConfig.BLUE_COLOR[1]),fontFamily: AppConfig.FONT_TYPE_BOLD)))),




                                                        Align(
                                                          alignment: Alignment.center,
                                                          child: Padding(padding: const EdgeInsets.only(top : 16.0,left: 20.0),
                                                            child:  CupertinoSegmentedControl<int>(
                                                              children: myTabs,
                                                              onValueChanged: (value) {
                                                                segmentedControlGroupValue = value;
                                                                setState(() {
                                                                  if (value == 0)
                                                                    dropdownValue = "Close";
                                                                  else
                                                                    dropdownValue = "ReOpen";
                                                                });
                                                              },
                                                              selectedColor: CupertinoColors.activeBlue,
                                                              unselectedColor: CupertinoColors.white,
                                                              borderColor: CupertinoColors.inactiveGray,
                                                              pressedColor: CupertinoColors.inactiveGray,
                                                              groupValue: segmentedControlGroupValue,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),



                                                    SizedBox(height: 10),

                                                    Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Padding(padding: EdgeInsets.only(left: 15,top: 10),
                                                          child: RichText(
                                                            text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD,fontSize: 15),
                                                              children: <TextSpan>[
                                                                TextSpan(text: 'Remark'),
                                                              ],
                                                            ),
                                                          )),
                                                    ),

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


                                                   Visibility(
                                                     visible: dropdownValue == "Close" ? true : false,
                                                     child: Column(
                                                       children: [

                                                         Align(
                                                             alignment: Alignment.centerLeft,
                                                             child: Padding(padding: const EdgeInsets.all(4.0),
                                                                 child: Text("Feedback : ", style: TextStyle(fontSize: 14.0,
                                                                     color: Color(AppConfig.BLUE_COLOR[1]),fontFamily: AppConfig.FONT_TYPE_BOLD)))),

                                                         Align(
                                                             alignment: Alignment.center,
                                                             child: Padding(padding: const EdgeInsets.all(4.0),
                                                                 child:  RatingBar.builder(
                                                                   initialRating: 3,
                                                                   minRating: 1,
                                                                   direction: Axis.horizontal,
                                                                   allowHalfRating: false,
                                                                   itemCount: 5,
                                                                   itemPadding:
                                                                   EdgeInsets.symmetric(horizontal: 4.0),
                                                                   itemBuilder: (context, _) => Icon(
                                                                     Icons.star,
                                                                     color: Colors.amber,
                                                                   ),
                                                                   onRatingUpdate: (rating1) {
                                                                     print(rating1 );
                                                                     setState(() {
                                                                       rating = rating1;
                                                                     });
                                                                   },
                                                                 )
                                                             )),

                                                       ],
                                                     ),
                                                   ),



                                                    Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: InkWell(
                                                        onTap: (){

                                                          if(dropdownValue == "Select status") {
                                                            Fluttertoast.showToast(msg: "please select the status");
                                                            return;
                                                          }


                                                          _registerComplaint(txt_remark.text, dropdownValue, rating.toInt());
                                                          print(txt_remark.text);
                                                          print(dropdownValue);
                                                          print(rating);
                                                        },
                                                        child: Container(
                                                          height: 40,
                                                          width: double.infinity,
                                                          color: Color(AppConfig.BLUE_COLOR[0]),
                                                          child: Center(child: Text("Save",style: TextStyle(fontSize: 14.0,
                                                              color: Colors.white,fontFamily: AppConfig.FONT_TYPE_BOLD))),
                                                        ),
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                              ),


                                              Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Container(
                                                  height: 40,
                                                  width: double.infinity,
                                                  color: Color(AppConfig.BLUE_COLOR[0]),
                                                  child: Center(child: Text("Complaint History",style: TextStyle(fontSize: 14.0,
                                                      color: Colors.white,fontFamily: AppConfig.FONT_TYPE_BOLD))),
                                                ),
                                              ),

                                              Row(

                                                children: [

                                                  Expanded(
                                                      flex: 5,
                                                      child: Padding(padding: const EdgeInsets.all(4.0),
                                                          child: Text("Status", style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold)))),


                                                  Expanded(
                                                      flex: 5,
                                                      child: Padding(
                                                          padding: const EdgeInsets.all(4.0),
                                                          child: Center(child: Text("Date", style: TextStyle(color: Colors.black,  fontSize: 15,fontWeight: FontWeight.bold))))),


                                                ],
                                              ),


                                              Flexible(
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    padding: const EdgeInsets.all(8),
                                                    itemCount: status_list_two.length,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      return Container(
                                                        color: Color(AppConfig.LIGHT_GRAY_COLOR[0]),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(10.0),
                                                          child: Column (
                                                            children: [

                                                              Stack(

                                                                children: [

                                                                  Align(
                                                                      alignment: Alignment.centerLeft,
                                                                      child: Padding(padding: const EdgeInsets.all(4.0),
                                                                          child: Text(status_list_two[index].status, style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold)))),


                                                                  Align(
                                                                      alignment: Alignment.centerRight,
                                                                      child: Padding(
                                                                          padding: const EdgeInsets.all(4.0),
                                                                          child: Text(status_list_two[index].date, style: TextStyle(color: Colors.black,  fontSize: 15,fontWeight: FontWeight.bold)))),

                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },

                                                  )),

                                              SizedBox(height: 10)
                                            ],
                                          )

                                      ),
                                    )
                                  ],

                                ),
                              ),
                            ));
                      },

                    ))




              ],
            ),
          ),
        )
    );
  }

  _getTopComplaints() async {

    _progressDialog.show();
    var response = await http.Client().get(Uri.parse(AppConfig.GET_TOP_COMPLAINT_STATUS+_sharedPreferences.getString(AppConfig.MOBILE_NUMBER)),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});
    _progressDialog.dismiss();

    setState(() {

      var jsonData = json.decode(response.body);
      print(jsonData);
      var responseObjlist = jsonData["responseObj"] as List;

      for (var model in responseObjlist) {
        status_list.add(new ComplaintStatusListResponse.fromJson(model));
        visible_list.add(false);
      }
    });
  }

  _getAllData() async {

    _progressDialog.show();
    var response = await http.Client().get(Uri.parse(AppConfig.GET_COMPLAINT_STATUS+txt_complain.text),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});
    _progressDialog.dismiss();

    var jsonData = json.decode(response.body);

    if (jsonData['responseCode'] == AppConfig.SUCESS_CODE) {
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ComplainStatus(txt_complain.text)));
    } else {
      Fluttertoast.showToast(msg: "Please Enter Valid Complaint ID or Mobile Number ");
    }
  }

  _getSingleComplaintData(String id) async {

    _progressDialog.show();
    var response = await http.Client().get(Uri.parse(AppConfig.GET_COMPLAINT_STATUS+id),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});
    _progressDialog.dismiss();

    setState(() {
      status_list_one.clear();
      status_list_two.clear();
      var jsonData = json.decode(response.body);

      print(jsonData);
      var responseObj = jsonData["responseObjlist"];

      var responseObjlist = jsonData["responseObj"] as List;

      for (var model in responseObjlist) {
        status_list_one.add(new ComplaintStatusResponse.fromJson(model));
      }

      print(status_list_one.length);

      for(int i =0 ; i < status_list_one.length; i++) {
        if(status_list_one[i].status.length != 0) {
          status_list_two.add(status_list_one[i]);
        }
      }

      print(status_list_two.length);

      complaintID = responseObj["complaintID"];
      callerNumber = responseObj["callerNumber"];
      callerName = responseObj["callerName"];
      schemeName = responseObj["schemeName"];
      callStatus = responseObj["callStatus"];

    });


  }

  _registerComplaint(String remark, String status, int rating) async {

    String callStatus = "";
    if(status == "ReOpen") {
      callStatus = "3";
    } else {
      callStatus = "5";
    }

    String schemeId = "";

    if(schemeName == "Beep") {
      schemeId = "11";
    } else if(schemeName == "Street Light") {
      schemeId = "1";
    } else if(schemeName == "UJALA") {
      schemeId = "2";
    } else if(schemeName == "AgDSM") {
      schemeId = "3";
    } else if(schemeName == "Building") {
      schemeId = "4";
    } else if(schemeName == "Other") {
      schemeId = "5";
    } else if(schemeName == "Ajay Phase-I") {
      schemeId = "6";
    } else if(schemeName == "AC") {
      schemeId = "7";
    } else if(schemeName == "Ajay Phase-II") {
      schemeId = "8";
    } else if(schemeName == "BEEP- Railway") {
      schemeId = "9";
    } else if(schemeName == "SoULS") {
      schemeId = "10";
    }


    // _progressDialog.show();
    String token = _sharedPreferences.getString(AppConfig.TOKEN);

    String url = AppConfig.API_LINK + "UpdateRectifiedComplaintStatusAndRating?UID=$complaintID&SchemeId=$schemeId&CallStatus=$callStatus&Remark=$remark&RatingNo=$rating";

    print(url);

    var response = await http.Client().post(Uri.parse(url),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer $token'});

    _progressDialog.dismiss();
    var jsonData = json.decode(response.body);

    print(jsonData);
    _progressDialog.dismiss();
    if(jsonData["responseCode"] == AppConfig.SUCESS_CODE) {
      AppConfig.showResponseAlertDialog(context, 'EESL Sampark', "Your Complaint Status Successfully Updated", 1);
    } else {
      AppConfig.showResponseAlertDialog(context, 'EESL Sampark', "${jsonData["responseObj"]}", 0);
    }
  }
}


