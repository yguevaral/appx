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

  static List<String> registroSintomas = [
    'Malestar General',
    'Cardiología',
    'Hipertensión arterial'
  ];

  static List<String> registroGenero = ['Masculino', 'Femenino'];
}
