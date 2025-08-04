import 'dart:convert';
import 'dart:io';

import 'package:eeslsamparkapp/libary/ars_progress_dialog.dart';
import 'package:eeslsamparkapp/libary/pin_entry_text_field.dart';
import 'package:eeslsamparkapp/side_menu/create_profile.dart';
import 'package:eeslsamparkapp/util/app_config.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
 
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
 
 
import 'package:flutter/foundation.dart';

class CreatePinScreen extends StatefulWidget {
  @override
  _CreatePinScreenScreenState createState() => _CreatePinScreenScreenState();
}

class _CreatePinScreenScreenState extends State<CreatePinScreen> {
  String pin_text = "";
  String confrim_pin_text = "";
  String encryptedText;

  SharedPreferences _sharedPreferences;
  ArsProgressDialog _progressDialog;

  @override
  void initState() {
    super.initState();

    // This is initialize the progress dialog
    _progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(AppConfig.PROGRESS_COLOR[0]),
        animationDuration: Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              ListView(
                children: <Widget>[
                  SizedBox(height: 50.0),
                  Container(
                      child: Image.asset('assets/image/eesl_logo.png',
                          height: 50)),
                  SizedBox(height: 10.0),
                  Text("SAMPARK",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Color(AppConfig.BLUE_COLOR[1]),
                          fontFamily: AppConfig.FONT_TYPE_BOLD)),
                  SizedBox(height: 30.0),
                  Text("Set Up a PIN",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Color(AppConfig.BLUE_COLOR[1]),
                          fontFamily: AppConfig.FONT_TYPE_BOLD)),
                  SizedBox(height: 5.0),
                  Text("Create a PIN to use in place of password.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: AppConfig.FONT_TYPE_REGULAR,
                          color: Colors.black)),
                  SizedBox(height: 30.0),
                  Text("Enter PIN",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Color(AppConfig.BLUE_COLOR[1]),
                          fontFamily: AppConfig.FONT_TYPE_BOLD)),
                  PinEntryTextField(
                    showFieldAsBox: false,
                    isTextObscure: true,
                    fontSize: 25.0,
                    onSubmit: (String pin) {
                      setState(() {
                        pin_text = pin;
                      });
                    }, // end onSubmit
                  ),
                  SizedBox(height: 50.0),
                  Text("Confirm PIN",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Color(AppConfig.BLUE_COLOR[1]),
                          fontFamily: AppConfig.FONT_TYPE_BOLD)),
                  PinEntryTextField(
                    showFieldAsBox: false,
                    isTextObscure: true,
                    fontSize: 25.0,
                    onSubmit: (String pin) {
                      setState(() {
                        confrim_pin_text = pin;
                      });
                    }, // end onSubmit
                  ),
                  SizedBox(height: 30.0),
                  Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: ElevatedButton(
                        child: Text('SUBMIT'),
                        onPressed: () {
                          if (pin_text.length != 4) {
                            Fluttertoast.showToast(msg: "Please enter Pin");
                          } else if (confrim_pin_text.length != 4) {
                            Fluttertoast.showToast(
                                msg: "Please enter Confirm Pin");
                          } else if (pin_text == confrim_pin_text) {
                            getLoginDetails(pin_text);
                          } else {
                            Fluttertoast.showToast(
                                msg: "Pin and confirm pin not match");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Color(AppConfig.BLUE_COLOR[0]),
                            textStyle: TextStyle(
                                fontSize: 18,
                                fontFamily: AppConfig.FONT_TYPE_BOLD))),
                  ),
                  SizedBox(height: 50.0),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  getLoginDetails(String pin_text) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setBool(AppConfig.KEY_IS_LOGGEDIN, true);
    print(_sharedPreferences.getBool(AppConfig.KEY_IS_LOGGEDIN));

    String mobile_no = _sharedPreferences.getString(AppConfig.MOBILE_NUMBER);
    String device_type = "";

    if ((Platform.isIOS)) {
      device_type = "iOS";
    } else {
      device_type = "Android";
    }

    String deviceId = await _getId();

    _createPIN(mobile_no, pin_text, device_type, deviceId);
  }

  Future<String> _getId() async {
    return "123";
  }

  _createPIN(String mobile_no, String login_pin, String device_type,
      String device_id) async {
    _progressDialog.show();

    String token = _sharedPreferences.getString(AppConfig.TOKEN);

  // final key=encrypt.Key.fromUtf8('MY_UNIQUE_KEY_FOR_EESL_SAMPARK_A');
  // final key=encrypt.Key.fromUtf8('8080808080808080');
  

  // final iv =encrypt.IV.fromUtf8('8080808080808080');
  // final encrypter = encrypt.Encrypter(encrypt.AES(key,mode: AESMode.cbc, padding:'PKCS7' ));

  // final encrypted = encrypter.encrypt(login_pin, iv: iv);
  // final decrypted = encrypter.decrypt(encrypted, iv: iv);


  // print('decrypted pin is $decrypted');  
  // print('encrypted pin is $encrypted');
  // print('encrypted after base64 ${encrypted.base64}');  


    String url =
        "${AppConfig.CREATE_PIN + "?MobileNo=$mobile_no&LoginPin=${AppConfig.encryptPin(login_pin)}&DeviceId=$device_id&DeviceType=$device_type&IsB2BUser=false"}";
   
    print(url);
    print(token);

    var response = await http.Client().post(Uri.parse(url), headers: {
      "Accept": "application/json",
      'Authorization': 'Bearer $token'

    });

    var jsonData = json.decode(response.body);
    _progressDialog.dismiss();
    print(jsonData);

    print(jsonData['responseCode']);

    if (jsonData['responseCode'] == AppConfig.SUCESS_CODE) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => CreateProfile()));
    
    
    } else {

      Fluttertoast.showToast(msg: "Something went wrong, try again later");

    }
 


  //  AppConfig.encryptPin(login_pin);

  //   AppConfig.encryptPin(login_pin).then((value) async {

  //   print('the value of encryption is $value');

   
  //   print(login_pin);
  //   print('the encrypted pin is $encryptedText');
  //   });


    
 
  }

}
