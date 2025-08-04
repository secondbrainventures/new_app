


import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class CapchaProvider with ChangeNotifier {


  String randomGeneratedString=randomAlpha(5);


  getRandomString(){

    randomGeneratedString=randomAlpha(5);

    notifyListeners();


  }


  
}

