import 'dart:io';

import 'package:flutter/material.dart';

class Environment {

  static bool appLocalHost = false;

  static String apiUrl = appLocalHost
      ? 'http://localhost:3000/api'
      : 'https://appx-server.herokuapp.com/api';

  static String socketUrl = appLocalHost
      ? 'http://localhost:3000/'
      : 'https://appx-server.herokuapp.com';

  static Color colorApp1 = Color.fromRGBO(57, 129, 189, 1.0);


  static List<String> registroSintomas = ['Malestar General', 'Cardiología', 'Hipertensión arterial'];

  static List<String> registroGenero = ['Masculino', 'Femenino'];

  static String convertToAgo(DateTime input){
    Duration diff = DateTime.now().difference(input);

    if(diff.inDays >= 1){
      return '${diff.inDays} day(s) ago';
    } else if(diff.inHours >= 1){
      return '${diff.inHours} hour(s) ago';
    } else if(diff.inMinutes >= 1){
      return '${diff.inMinutes} minute(s) ago';
    } else if (diff.inSeconds >= 1){
      return '${diff.inSeconds} second(s) ago';
    } else {
      return 'just now';
    }
  }

}
