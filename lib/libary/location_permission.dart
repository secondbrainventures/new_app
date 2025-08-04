import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPermissionInApp  {

  Future<void> requestCameraPermission() async {
    print("====>>>>>>");
    final status = await Permission.camera.request();

    var camerastatus = await Permission.location.status;

    if(!camerastatus.isGranted){
      await Permission.camera.request();
    }

    if (status == PermissionStatus.granted) {
      print('Permission Granted');
    } else if (status == PermissionStatus.denied) {
      print('Permission denied');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Permission Permanently Denied');
      await Permission.camera.request();
    }
  }

  Future<void> requestLocationPermission() async {
    final serviceStatusLocation = await Permission.locationWhenInUse.isGranted;

    bool isLocation = serviceStatusLocation == ServiceStatus.enabled;

    var locationStatus = await Permission.location.status;

    if(!locationStatus.isGranted){
      await Permission.location.request();
    }

    final status = await Permission.locationWhenInUse.request();

    if (status == PermissionStatus.granted) {
      print('Permission Granted');
    } else if (status == PermissionStatus.denied) {
      print('Permission denied');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Permission Permanently Denied');
      await openAppSettings();
    }
  }
}