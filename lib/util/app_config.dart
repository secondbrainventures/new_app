import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:eeslsamparkapp/coprate_customer/buisness_home_page.dart';
import 'package:eeslsamparkapp/home_page/main_home_page.dart';
import 'package:eeslsamparkapp/registration/login_pin_screen.dart';
import 'package:eeslsamparkapp/start_up/login_as.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:safe_device/safe_device.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../libary/location_permission.dart';

class AppConfig {
  // Response Codes
  static final int NewUser = 104;
  static final int UserAlreadyRegistered = 102;
  static final int InValidToken = 103;
  static final int Error = 400;
  static final int NotFound = 404;
  static final int Unauthorized = 401;
  static final int SUCESS_CODE = 200;

  static final List BLUE_COLOR = [
    0xff0071ff,
    0xff0d2668,
    0xff0071ff,
    0xffc7dfff
  ];

  static final List LIGHT_GRAY_COLOR = [0xfff3f5fd];
  static final List ORANGE_COLOR = [0xffFFA739];
  static final List PROGRESS_COLOR = [0x33000000];
  static final String FONT_TYPE_BOLD = "Montserrat";
  static final String FONT_TYPE_REGULAR = "Montserrat_Regular";
  static final String MOBILE_NUMBER = "mobile_number";
  static final String SCHEME_NAME = "schemeName";
  static final String STATE_NAME = "stateName";
  static final String DISTRICT_NAME = "districtName";
  static final String SCHEME_ID = "schemeId";
  static final String STATE_ID = "stateId";
  static final String DISTRICT_ID = "districtId";
  static final String EMAIL_ID = "email_id";
  static final String ADDRESS = "address";
  static final String NAME = "name";
  static final String TOKEN = "token";
  static final String USER_TYPE = "user_type";
  static final String UNIQUE_CODE = "unique_code";
  static final String CLIENT_NAME = "client_name";
  static final String B2BCode_Id = "B2BCode_Id";
  static final String MOBILE_USER_ID = "mobileUserId";

  // 0 means - logged in and 1 means logout
  static final String KEY_IS_LOGGEDIN = "isLoggedIn";
  static final String APP_STORE_URL = "https://apps.apple.com/us/app/eesl-sampark/id1576668992";
  static final String PLAY_STORE_URL = "https://play.google.com/store/apps/details?id=com.eeslsampark.app";

  // Dashboard URLs
  static final String SLNP_URL = "https://slnp.eeslindia.org/";
  static final String UJALA_URL = "http://www.ujala.gov.in/";
  static final String AJAY_URL = "http://ajay.eeslindia.org/";
  static final String BEEP_URL = "https://beep.eeslindia.org/";
  static final String SEAC_URL = "https://eeslmart.in/";

  // Home Page URLs
  static final String NEWS_URL = "https://eeslindia.org/en/ourmediacorner/";
  static final String FAQ_URL = "https://support.eeslindia.org/FAQ/FAQ_Common";
  static final String CONTACT_URL = "https://eeslindia.org/en/ourcontact-us/";

  // Web Services
  // static final String EXEL_DOWNLOAD_LINK = "http://172.16.16.43/eeslcrm/AppExcelDownload/";
  static final String EXEL_DOWNLOAD_LINK = "https://support.eeslindia.org/api/AppExcelDownload/";

  //  static final String API_LINK = "http://172.16.16.43:8082/api/commonapi/";
  // static final String API_LINK = "http://staging.fivesdigital.com:8082/api/commonapi/";
  // static final String API_LINK = "http://staging.fivesdigital.com/api/commonapi/";
  // static final String API_LINK = "http://staging.fivesdigital.com:8082/api/commonapi/";
  static final String API_LINK = "https://support.eeslindia.org/api/commonapi/";
  // static final String API_LINK = "https://staging.fivesdigital.com/api/commonapi/";
  static final String IS_MOBILE_EXIST = API_LINK + "IsMobileExist?mobileno=";
  static final String VALIDATE_OTP = API_LINK + "ValidateOTP";
  static final String RESEND_OTP = API_LINK + "SendOTP?mobileno=";
  static final String CREATE_PIN = API_LINK + "RegisteredUser";
  static final String RESET_PIN = API_LINK + "ResetPin";
  static final String LOGIN_WITH_PIN = API_LINK + "IsValidLoginPin";
  static final String CREATE_PROFILE = API_LINK + "UpdateProfile";
  static final String CHANGE_PIN = API_LINK + "UpdateLoginPin";
  static final String GET_USER_PROFILE = API_LINK + "GetUserProfile?MobileNo=";
  static final String GET_SCHEME_LIST = API_LINK + "GetSchemeList";
  static final String API_GET_STATE = API_LINK + "GetSchemeWiseStateList?Schemeid=";
  static final String API_GET_STATE_WISE_DISTRICT = API_LINK + "GetStateSchemeWiseDistrictList?Schemeid=";

  // getComplaint Status
  static final String GET_COMPLAINT_STATUS = API_LINK + "GetComplaintStatus?IDmobile=";
  static final String GET_TOP_COMPLAINT_STATUS = API_LINK + "GetTopComplaints?MobileNo=";

  // lodge Complaint
  static final String CONSUMER_ENTRY = API_LINK + "ConsumerEntry";

  // Street Light
  static final String API_GET_ULB_LIST = API_LINK + "GetStreetLightULBList?DistrictId=";
  static final String API_GET_ZONE_LIST = API_LINK + "GetStreetLightZoneList?ULBID=";
  static final String GET_AREA_TYPE_LIST = API_LINK + "GetAreaTypeList";
  static final String GET_TICKET_TYPE_LIST = API_LINK + "GetTicketType";

  // Ujala
  static final String DIS_COME_FILL = API_LINK + "DiscomeFill?Stateid=";
  static final String GET_REASON_OF_COMPLAINT_LIST = API_LINK + "GetUjalaComplainTypeList";

  // Agdcm
  static final String GET_REASON_COMPLAINT_LIST = API_LINK + "GetReasonOfComplaintList";
  static final String GET_SOUL_BLOCK_LIST = API_LINK + "SoulBlockList?Stateid=";

  // AjayPhase
  static final String AJAYONE_CONSTITUENCY_LIST = API_LINK + "AjayOneConstituencyList?Stateid=";
  static final String AJAY_TWO_CONSTITUENCY_LIST = API_LINK + "AjayTwoConstituencyList?Stateid=";
  static final String AJAY_COMPLAINT_CATEGORYLIST = API_LINK + "AjayOneComplaintCategoryList";

  // Solus
  static final String GET_ADC_MASTER_DATA = API_LINK + "GetADCMasterData?Blockid=";
  static final String GET_RM_CODE_ONLOAD = API_LINK + "GetRMCODEOnLoad?Blockid=";
  static final String GET_RM_CODE_NAME_ONLOAD = API_LINK + "GetRMCODENameOnLoad?Blockid=";
  static final String GET_RM_CENTER_MASTER = API_LINK + "GetRMCenterMaster?RMCode=";

  // Railway
  static final String GET_BEEP_RAILWAYZONE_LIST = API_LINK + "GetBeepRailwayZoneList?Stateid=";
  static final String GET_BEEP_DIVISION_LIST = API_LINK + "GetBeepRailwayDivisionList?Stateid=";
  static final String GET_BEEP_STATION_LIST = API_LINK + "GetBeepRailwayStationList?Stateid=";
  static final String GET_BEEP_PRODUCT_CATEGORY_LIST = API_LINK + "GetBeepProductCategoryListForProductMapping?Zoneid=";
  static final String GET_BEEP_PRODUCT_CATEGORY_ITEM_LIST = API_LINK + "GetBeepProductCategoryItemList?Stateid=";
  static final String GET_PRODUCT_WATT_LIST = API_LINK + "GetProductWattList?ProductId=";
  static final String GET_PRODUCT_MOUNTING_LIST = API_LINK + "GetProductMountingList?ProductId=";
  static final String GET_PRODUCT_MANUFACTURER_LIST = API_LINK + "GetProductManufacturerListCaller?Stateid=";

  //AC
  static final String GET_AC_ISSUE_TYPE_LIST = API_LINK + "GetACIssuTypeList";

  //Building
  static final String GET_BUILDING_PRODUCT_TYPE = API_LINK + "GetBuildingProductType";
  static final String GET_BUILDING_LIST = API_LINK + "GetBuildingList?Stateid=";
  static final String GET_APP_VERSION = API_LINK + "GetAppVersion?DeviceType=";

  //B2B API
  static final String VALIDATE_B2B_CODE = API_LINK + "ValidateB2BCode?CodeNumber=";
  static final String VALIDATE_OTP_B2B_USER = API_LINK + "ValidateOTPB2BUser";
  static final String B2B_USER_PROFILE = API_LINK + "B2BUserProfile";
  static final String ADD_SCHEME_B2B_USER_PROFILE = API_LINK + "AddSchemsInB2BProfile";
  static final String GET_SCHEMES = API_LINK + "GetSchemes?CodeId=";
  static final String GET_STATES = API_LINK + "GetStates?CodeId=";
  static final String GET_DISTRICTS = API_LINK + "GetDistricts?Stateid=";
  static final String GET_REPORT = API_LINK + "GetReport?";
  static final uniqueKey = "8080808080808080";

  static launchURL(String url) async {
    /* if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }*/
  }

  static Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  static String encryptPin(String pin_text) {
    final key = encrypt.Key.fromUtf8('8080808080808080');

    final iv = encrypt.IV.fromUtf8('8080808080808080');
    final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
    final encrypted = encrypter.encrypt(pin_text, iv: iv);

    print('encrypted pin is ${encrypted.base64} ');
    return encrypted.base64;
  }

  static encodePin(String pin_text) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded_pin = stringToBase64.encode(pin_text);
    return encoded_pin;
  }

  static double getImageSize(File image) {
    var imageSize = image.readAsBytesSync().lengthInBytes / 1024.toInt();
    return imageSize;
  }

  // static bool validateImageSize(File image){

  //   final bytes = image.readAsBytesSync();

  //   print('the size of image in kb is  ${bytes.lengthInBytes/1024}');

  //   if (bytes.lengthInBytes/1024>50) {

  //     return false;

  //   } else {

  //     return true;

  //   }

  // }

  static String encodeImage(File image) {
    final bytes = image.readAsBytesSync();

    String encodedImage = base64Encode(bytes);
    print('encoded image is $encodedImage');
    debugPrint('complete string is $encodedImage');

    return encodedImage;
  }

  static checkSafeDevice() async {
    bool isRealDevice = true;
    bool isJailBroken = false;
    try {
      isRealDevice = await SafeDevice.isRealDevice;
      isJailBroken = await SafeDevice.isJailBroken;

      print(isRealDevice);
      print(isJailBroken);
    } catch (error) {
      print(error);
    }

    if (isRealDevice == true && isJailBroken == false) {
      print('It is safe device');
    } else {
      print('It is not safe device');
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      }

      if (Platform.isIOS) {
        exit(0);
      }
    }
  }

  static Future<bool> checkInternetConnectivity() async {
    // var connectivityResult = await (Connectivity().checkConnectivity());

    /*if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }*/
    return true;
  }

  static var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Colors.grey)),
    titleStyle: TextStyle(color: Colors.red),
  );

  static var alertStyle2 = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Colors.grey)),
    titleStyle: TextStyle(color: Color(AppConfig.BLUE_COLOR[0])),
  );

  static showAlertDialog(BuildContext context) async {
    return Alert(
        context: context,
        style: alertStyle,
        type: AlertType.info,
        title: 'EESL Sampark',
        desc: "Internet connection not available",
        buttons: [
          DialogButton(
              child: Text("Okay",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              onPressed: () => Navigator.pop(context),
              color: Color(AppConfig.BLUE_COLOR[0]),
              radius: BorderRadius.circular(0.0))
        ]).show();
  }

  static Future<bool> getpermiaaionLocation() async {
    var status = await Permission.location.status;

    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  static Future<LatLng> getUserLocation(BuildContext context) async {
    try {
      if (Platform.isIOS) {
        var position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        LatLng currentPosition = LatLng(position.latitude, position.longitude);

        if (currentPosition == null) {
          return LatLng(28.7041, 77.1025);
        } else {
          return currentPosition;
        }
      }

      if (Platform.isAndroid) {
        if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
          var position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          LatLng currentPostion = LatLng(position.latitude, position.longitude);

          if (currentPostion == null) {
            return LatLng(28.7041, 77.1025);
          } else {
            return currentPostion;
          }
        } else {
          return LatLng(28.7041, 77.1025);
          // Fluttertoast.showToast(msg: "Please Give location permission to lodge complaint");
        }
      }
    } catch (e) {
      /* showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text('Grant Location Permission'),
                content: Text(
                    'This app needs location permission to register complaints'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('Deny'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoDialogAction(
                    child: Text('Settings'),
                    onPressed: () => openAppSettings(),
                  ),
                ],
              ));*/
    }
  }

  // type 1 for success and 0 for fail
  static showResponseAlertDialog(
      BuildContext context, String title, String message, int type) async {
    return Alert(
      context: context,
      style: alertStyle2,
      type: type == 1 ? AlertType.success : AlertType.info,
      title: title,
      desc: message,
      buttons: [
        DialogButton(
          height: 40,
          child:
              Text("OKAY", style: TextStyle(color: Colors.white, fontSize: 20)),
          onPressed: () async {
            SharedPreferences _sharedPreferences =
                await SharedPreferences.getInstance();

            if (_sharedPreferences.getString(AppConfig.USER_TYPE) ==
                "B2B-USER") {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => BusinessHomePage()));
            } else {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => MainHomePage()));
            }
          },
          color: Color(AppConfig.BLUE_COLOR[0]),
          radius: BorderRadius.circular(5.0),
        ),
      ],
    ).show();
  }

  static showRegisterAlertDialog(BuildContext context, String message) async {
    return Alert(
      context: context,
      style: alertStyle2,
      type: AlertType.success,
      title: "EESL SAMPARK",
      desc: message,
      buttons: [
        DialogButton(
          height: 40,
          child:
              Text("OKAY", style: TextStyle(color: Colors.white, fontSize: 20)),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => LoginAsPage()));
          },
          color: Color(AppConfig.BLUE_COLOR[0]),
          radius: BorderRadius.circular(5.0),
        ),
      ],
    ).show();
  }

  static showProcessAlertDialog(BuildContext context, String message) async {
    return Alert(
      context: context,
      style: alertStyle2,
      type: AlertType.info,
      title: "EESL SAMPARK",
      desc: message,
      buttons: [
        DialogButton(
          height: 40,
          child:
              Text("OKAY", style: TextStyle(color: Colors.white, fontSize: 20)),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Color(AppConfig.BLUE_COLOR[0]),
          radius: BorderRadius.circular(5.0),
        ),
      ],
    ).show();
  }

  static showAddSchemeDialog(BuildContext context, String message) async {
    return Alert(
      context: context,
      style: alertStyle2,
      type: AlertType.success,
      title: "EESL SAMPARK",
      desc: message,
      buttons: [
        DialogButton(
          height: 40,
          child:
              Text("OKAY", style: TextStyle(color: Colors.white, fontSize: 20)),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => BusinessHomePage()));
          },
          color: Color(AppConfig.BLUE_COLOR[0]),
          radius: BorderRadius.circular(5.0),
        ),
      ],
    ).show();
  }

  static showFancyCustomDialogLocation(BuildContext context) {
    Dialog fancyDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        height: 550,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Stack(
          children: <Widget>[
            Align(
              // These values are based on trial & error method
              alignment: Alignment(1.05, -1.05),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Use Your location",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        "Eesl Sampark app collects the location data to enable lodge a complaint against a non-functional street light.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        "you need to provide the location (Coordinates) "
                        "so that the technician could easily locate the faulty street light and get it fixed without disturbing you.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/image/location_icon.png',
                          height: 120),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MaterialButton(
                            // FIRST BUTTON IS REQUIRED
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            color: Colors.white,
                            child: Text('Turn on',
                                style: TextStyle(
                                    color: Colors.blue, fontSize: 14)),
                            onPressed: () {
                              LocationPermissionInApp()
                                  .requestLocationPermission();
                              // openAppSettings();
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MaterialButton(
                            // FIRST BUTTON IS REQUIRED
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            color: Colors.white,
                            child: Text('Cancel',
                                style: TextStyle(
                                    color: Colors.blue, fontSize: 14)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => fancyDialog);
  }

  static showFancyCustomDialogImage(BuildContext context) {
    Dialog fancyDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        height: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Stack(
          children: <Widget>[
            Align(
              // These values are based on trial & error method
              alignment: Alignment(1.05, -1.05),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.image,
                      color: Colors.black,
                      size: 30,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Upload Image",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        "In order to identify the Faulty Street Light Pole, The app will ask you to upload the Pole Image, "
                            "so that the technician could easily identify the pole by just seeing the image and get it fixed when he reaches the location.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ),
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MaterialButton(
                            // FIRST BUTTON IS REQUIRED
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            color: Colors.white,
                            child: Text('Turn on',
                                style: TextStyle(
                                    color: Colors.blue, fontSize: 14)),
                            onPressed: () {
                              Navigator.pop(context);
                              LocationPermissionInApp()
                                  .requestCameraPermission();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MaterialButton(
                            // FIRST BUTTON IS REQUIRED
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            color: Colors.white,
                            child: Text('Cancel',
                                style: TextStyle(
                                    color: Colors.blue, fontSize: 14)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => fancyDialog);
  }
}
