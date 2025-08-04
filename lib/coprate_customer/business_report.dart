import 'dart:convert';
import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dio/dio.dart';
import 'package:eeslsamparkapp/libary/ars_progress_dialog.dart';
import 'package:eeslsamparkapp/model/state_gs.dart';
import 'package:eeslsamparkapp/util/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessReportScreen extends StatefulWidget {
  
  @override
  _BusinessReportScreenState createState() => _BusinessReportScreenState();

}

class _BusinessReportScreenState extends State<BusinessReportScreen> {

  String currentText = "";
  SharedPreferences _sharedPreferences;
  ArsProgressDialog _progressDialog;
  ArsProgressDialog _progressDialog2;

  List<StateResponse> scheme_list = [];
  String scheme;
  int scheme_id;


  TextEditingController txt_start_date = new TextEditingController();
  TextEditingController txt_end_date = new TextEditingController();

  final date_format = DateFormat("dd-MM-yyyy");
  final Dio _dio = Dio();

  String _progress = "-";
  var decode_json;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;


  _getSchemeList() async {

    _progressDialog.show();
    var response = await http.Client().get(Uri.parse(AppConfig.GET_SCHEMES + _sharedPreferences.getString(AppConfig.B2BCode_Id)),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});

    setState(() {

      var jsonData = json.decode(response.body);
      print(jsonData);
      var responseObj = jsonData["responseObj"] as List;

      for (var model in responseObj) {
        scheme_list.add(new StateResponse.fromJson(model));
      }

    });
    _progressDialog.dismiss();
  }

  @override
  void initState() {
    super.initState();

    _getDetails();

    // This is initialize the progress dialog
    _progressDialog = ArsProgressDialog(context, blur: 2,
        backgroundColor: Color(AppConfig.PROGRESS_COLOR[0]),
        animationDuration: Duration(milliseconds: 500));
    // This is initialize the progress dialog
    _progressDialog2 = ArsProgressDialog(context, blur: 2,
        backgroundColor: Color(AppConfig.PROGRESS_COLOR[0]),
        animationDuration: Duration(milliseconds: 500));


    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
   // final iOS = IOSInitializationSettings();
   // final initSettings = InitializationSettings(android:android, iOS:  iOS);

   // flutterLocalNotificationsPlugin.initialize(initSettings, onSelectNotification: _onSelectNotification);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            title: Text("Report",
                style: TextStyle(fontSize: 18, color: Colors.white,fontFamily: AppConfig.FONT_TYPE_BOLD)),
            centerTitle: true, backgroundColor: Color(AppConfig.BLUE_COLOR[0]))),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

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
                      StateResponse response) {
                    return DropdownMenuItem<StateResponse>(
                        value: response,
                        child: Text(response.text));
                  },
                  ).toList(),

                  onChanged: (StateResponse response) {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    setState(() {
                      scheme = response.text;
                      scheme_id = response.id;
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
                      TextSpan(text: 'Select Start Date '),
                      TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                    ],
                  ),
                )),

            Padding(
              padding: const EdgeInsets.only(top:8.0,left: 8.0,right: 8.0),
              child: DateTimeField(
                format: date_format,
                controller: txt_start_date,
                decoration: InputDecoration(
                    hintText: 'Select Start Date',
                    contentPadding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 5.0),
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

                      lastDate: DateTime.now(),
                      initialDate: currentValue ?? DateTime.now(),
                      firstDate: DateTime(2015));

                  return picked;
                },
              ),
            ),

            Padding(padding: EdgeInsets.only(left: 15,top: 10),
                child: RichText(
                  text: TextSpan(style: TextStyle(color: Color(AppConfig.BLUE_COLOR[1]), fontFamily: AppConfig.FONT_TYPE_BOLD, fontSize: 15),
                    children: <TextSpan>[
                      TextSpan(text: 'Select End Date  '),
                      TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red, fontSize: 16)),
                    ],
                  ),
                )),

            Padding(
              padding: const EdgeInsets.only(top:8.0,left: 8.0,right: 8.0),
              child: DateTimeField(
                format: date_format,
                controller: txt_end_date,
                decoration: InputDecoration(
                    hintText: 'Select End Date',
                    contentPadding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 5.0),
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

                      lastDate: DateTime.now(),
                      initialDate: currentValue ?? DateTime.now(),
                      firstDate: DateTime(2015));

                  return picked;
                },
              ),
            ),

            SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                  child: Text('DOWNLOAD REPORT',style : TextStyle(color: Colors.white, fontFamily: AppConfig.FONT_TYPE_BOLD,fontSize: 16.0)),
                  onPressed: () async {

                    FocusScope.of(context).requestFocus(new FocusNode());

                    if(scheme_id == null) {
                      Fluttertoast.showToast(msg: 'Please select the Scheme ID');
                    } else if (txt_start_date.text.length == 0) {
                      Fluttertoast.showToast(msg: 'please select start date');
                    } else if (txt_end_date.text.length == 0) {
                      Fluttertoast.showToast(msg: 'please select end date');
                    } else {

                      var date1 = date_format.parse(txt_start_date.text);
                      var date2 = date_format.parse(txt_end_date.text);

                      if (date1.isAfter(date2)) {
                        Fluttertoast.showToast(msg: 'start date must be greater than end date');
                        return;
                      }

                      final isPermissionStatusGranted = await _requestPermissions();

                      if(isPermissionStatusGranted) {
                        _getReport(txt_start_date.text, txt_end_date.text, scheme, _sharedPreferences.getString(AppConfig.MOBILE_USER_ID));
                      } else {
                        Fluttertoast.showToast(msg: "Give Storage Permission to download report ");
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Color(AppConfig.BLUE_COLOR[0]),
                      padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10))
              ),
            ),

          ],
        ),
      ),
    );
  }

  _getDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _getSchemeList();

    AppConfig.checkInternetConnectivity().then((intenet) {
      if (intenet != null && intenet) {

      } else {
        AppConfig.showAlertDialog(context);
      }
    });
  }

  _getReport(String fromdate, String todate, String schemeName, String UserId) async {
    _progressDialog.show();

    String url = "${AppConfig.GET_REPORT}fromdate=$fromdate&todate=$todate&UserId=$UserId&schemeName=$schemeName";
    print(url);

    var response = await http.Client().get(Uri.parse(url),
        headers: {"Accept": "application/json", 'Authorization': 'Bearer ${_sharedPreferences.getString(AppConfig.TOKEN)}'});
    _progressDialog.dismiss();

    setState(() {
      var jsonData = json.decode(response.body);
      var file_name = jsonData["responseObj"];
      _download(file_name, AppConfig.EXEL_DOWNLOAD_LINK + file_name);
      print(jsonData);

    });


  }


  Future<void> _onSelectNotification(String json) async {
    final obj = jsonDecode(json);

    if (obj['isSuccess']) {
      // OpenFile.open(obj['filePath']);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('${obj['error']}'),
        ),
      );
    }
  }

  Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
    final android = AndroidNotificationDetails(
        'channel id',
        'channel name',
        priority: Priority.high,
        importance: Importance.max
    );


    final platform = NotificationDetails(android : android);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];

    await flutterLocalNotificationsPlugin.show(
        0, // notification id
        isSuccess ? 'Success' : 'Failure',
        isSuccess ? 'File has been downloaded successfully!' : 'There was an error while downloading the file.',
        platform,
        payload: json
    );

    setState(() {
      decode_json = json;  
    });
    
  }

  Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      //return await DownloadsPathProvider.downloadsDirectory;
    }

    // in this example we are using only Android and iOS so I can assume
    // that you are not trying it for other platforms and the if statement
    // for iOS is unnecessary

    // iOS directory visible to user
    return await getApplicationDocumentsDirectory();
  }

  Future<bool> _requestPermissions() async {
    var permission = await Permission.storage.isGranted;

    if (!permission) {
      await Permission.storage.request();
      permission = await Permission.storage.isGranted;
    }

    return permission;
  }

  void _onReceiveProgress(int received, int total) {
    if (total != -1) {
      setState(() {
        _progress = (received / total * 100).toStringAsFixed(0) + "%";
      });

      print(_progress);
      if(_progress == "100") {
        _progressDialog2.dismiss();
      }
    }
  }

  Future<void> _startDownload(String savePath, String _fileUrl) async {
    _progressDialog2.show();
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };

    try {
      final response = await _dio.download(_fileUrl, savePath, onReceiveProgress: _onReceiveProgress);
      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;

      showProcessAlertDialog(context, "File save at $savePath");

    } catch (ex) {
      result['error'] = ex.toString();
    } finally {
      await _showNotification(result);
    }
  }

  Future<void> _download(String _fileName, String url) async {

    final dir = await _getDownloadDirectory();
    final isPermissionStatusGranted = await _requestPermissions();

    if (isPermissionStatusGranted) {
      final savePath = path.join(dir.path, _fileName);
      await _startDownload(savePath,url);
    } else {
      print("permission not granted");
    }
  }


  showProcessAlertDialog(BuildContext context, String message) async {
    _progressDialog2.dismiss();
    return Alert(
      context: context,
      style: alertStyle2,
      type: AlertType.success,
      title: "EESL SAMPARK",
      desc: message,
      buttons: [
        DialogButton(
          height: 40,
          child: Text("OPEN", style: TextStyle(color: Colors.white, fontSize: 20)),
          onPressed: () {
            _progressDialog.dismiss();
            _onSelectNotification(decode_json);
          },
          color: Color(AppConfig.BLUE_COLOR[0]),
          radius: BorderRadius.circular(5.0),
        ),

        DialogButton(
          height: 40,
          child: Text("Close", style: TextStyle(color: Colors.white, fontSize: 20)),
          onPressed: () {
            _progressDialog.dismiss();
            Navigator.pop(context);
          },
          color: Color(AppConfig.BLUE_COLOR[0]),
          radius: BorderRadius.circular(5.0),
        ),
      ],
    ).show();
  }

  var alertStyle2 = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Colors.grey)),
    titleStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[0])),
  );

}