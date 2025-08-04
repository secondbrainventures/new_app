import 'dart:convert';
import 'dart:ui';
import 'package:eeslsamparkapp/model/compalint_status_gs.dart';
import 'package:http/http.dart' as http;
import 'package:eeslsamparkapp/libary/ars_progress_dialog.dart';
import 'package:eeslsamparkapp/util/app_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComplainStatus extends StatefulWidget {

  String compaint_id;
  ComplainStatus(this.compaint_id);

  @override
  _ComplainStatusState createState() => _ComplainStatusState(compaint_id);
}


class _ComplainStatusState extends State<ComplainStatus> {

  String compaint_id;
  _ComplainStatusState(this.compaint_id);

  SharedPreferences _sharedPreferences;
  ArsProgressDialog _progressDialog;

  String complaintID ="", callerNumber="", callerName="", schemeName="", callStatus="";
  final List<ComplaintStatusResponse> status_list_one = [];
  final List<ComplaintStatusResponse> status_list_two = [];

  getLoginDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _getAllData(compaint_id);
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
          child: AppBar(title: Text("Complaint Status",
              style: TextStyle(fontSize: 18, color: Colors.white,fontFamily: AppConfig.FONT_TYPE_BOLD)),
              centerTitle: true, backgroundColor: Color(AppConfig.BLUE_COLOR[0])),
        ),

        body: SafeArea(
          child: Container(
              color: Color(AppConfig.LIGHT_GRAY_COLOR[0]),
              child: Container(
                  margin: EdgeInsets.only(left:15,right: 15, bottom: 10,top: 15),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color:Colors.white),

                  child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Stack(

                            children: [

                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(padding: const EdgeInsets.all(4.0),
                                      child: Text("Complaint ID : ", style: TextStyle(fontSize: 14.0,
                                          color: Color(AppConfig.BLUE_COLOR[1]),fontFamily: AppConfig.FONT_TYPE_BOLD)))),

                              Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(padding: const EdgeInsets.all(4.0),
                                      child: Text(complaintID, style: TextStyle(fontSize: 14.0,
                                          color: Colors.black,fontFamily: AppConfig.FONT_TYPE_REGULAR)))),


                            ],
                          ),

                          Stack(

                            children: [

                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(padding: const EdgeInsets.all(4.0),
                                      child: Text("Complaint Number : ", style: TextStyle(fontSize: 14.0,
                                          color: Color(AppConfig.BLUE_COLOR[1]),fontFamily: AppConfig.FONT_TYPE_BOLD)))),

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
                                      child: Text("Complaint Name : ", style: TextStyle(fontSize: 14.0,
                                          color: Color(AppConfig.BLUE_COLOR[1]),fontFamily: AppConfig.FONT_TYPE_BOLD)))),

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
                                          color: Color(AppConfig.BLUE_COLOR[1]),fontFamily: AppConfig.FONT_TYPE_BOLD)))),

                              Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(padding: const EdgeInsets.all(4.0),
                                      child: Text(schemeName, style: TextStyle(fontSize: 14.0,
                                          color: Colors.black,fontFamily: AppConfig.FONT_TYPE_REGULAR)))),


                            ],
                          ),

                          Stack(

                            children: [

                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(padding: const EdgeInsets.all(4.0),
                                      child: Text("Status : ", style: TextStyle(fontSize: 14.0,
                                          color: Color(AppConfig.BLUE_COLOR[1]),fontFamily: AppConfig.FONT_TYPE_BOLD)))),

                              Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(padding: const EdgeInsets.all(4.0),
                                      child: Text(callStatus, style: TextStyle(fontSize: 14.0,
                                          color: Colors.black,fontFamily: AppConfig.FONT_TYPE_REGULAR)))),


                            ],
                          ),

                          SizedBox(height: 15),

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

                  ))



          ),
        )
    );
  }

  _getAllData(String id) async {

    _progressDialog.show();
    var response = await http.Client().get(Uri.parse(AppConfig.GET_COMPLAINT_STATUS+id),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});
    _progressDialog.dismiss();

    setState(() {

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
}