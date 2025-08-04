import 'dart:convert';
import 'dart:ui';
import 'package:eeslsamparkapp/model/compalint_status_gs.dart';
import 'package:http/http.dart' as http;
import 'package:eeslsamparkapp/libary/ars_progress_dialog.dart';
import 'package:eeslsamparkapp/util/app_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactUs extends StatefulWidget {

  @override
  _ContactUsState createState() => _ContactUsState();
}


class _ContactUsState extends State<ContactUs> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(title: Text("Contact US",
              style: TextStyle(fontSize: 18, color: Colors.white,fontFamily: AppConfig.FONT_TYPE_BOLD)),
              centerTitle: true, backgroundColor: Color(AppConfig.BLUE_COLOR[0])),
        ),

        body: SafeArea(
          child: Container(
              width: double.infinity,
              color: Color(AppConfig.LIGHT_GRAY_COLOR[0]),
              child: Column(
                children: [

                  SizedBox(height: 40),


                  Container(
                      child:Image.asset('assets/image/eesl_logo.png', height: 50)),

                  SizedBox(height: 10.0),

                  Text("SAMPARK", textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20.0, color: Color(AppConfig.BLUE_COLOR[1]),
                          fontFamily: AppConfig.FONT_TYPE_BOLD)),

                  SizedBox(height: 10.0),

                  Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(left:15,right: 15, bottom: 10,top: 15),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color:Colors.white),

                      child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(

                            children: <Widget>[

                              SizedBox(height: 10),

                              Padding(padding: const EdgeInsets.all(4.0),
                                  child: Text("GET IN TOUCH ", style: TextStyle(fontSize: 20.0,
                                      color: Color(AppConfig.BLUE_COLOR[1]),fontFamily: AppConfig.FONT_TYPE_BOLD))),

                              SizedBox(height: 20),

                              Padding(padding: const EdgeInsets.all(4.0),
                                  child: Text("Toll Free No. : 1800-180-3580", style: TextStyle(fontSize: 16.0,
                                      color: Color(AppConfig.BLUE_COLOR[1]),fontFamily: AppConfig.FONT_TYPE_BOLD))),

                              SizedBox(height: 20),

                              Padding(padding: const EdgeInsets.all(4.0),
                                  child: Text("Email ID : helpline@eesl.co.in", style: TextStyle(fontSize: 16.0,
                                      color: Color(AppConfig.BLUE_COLOR[1]),fontFamily: AppConfig.FONT_TYPE_BOLD))),

                              SizedBox(height: 20),

                              Padding(padding: const EdgeInsets.all(4.0),
                                  child: Text("WebSite : www.eeslindia.org", style: TextStyle(fontSize: 16.0,
                                      color: Color(AppConfig.BLUE_COLOR[1]),fontFamily: AppConfig.FONT_TYPE_BOLD))),

                              SizedBox(height: 10)
                            ],
                          )

                      )),
                ],
              )
          ),
        )
    );
  }
}