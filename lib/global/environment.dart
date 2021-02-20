import 'dart:io';

import 'package:flutter/material.dart';

class Environment {
  static String apiUrl = Platform.isAndroid
      ? 'https://appx-server.herokuapp.com/api'
      : 'https://appx-server.herokuapp.com/api';

  static String socketUrl = Platform.isAndroid
      ? 'https://appx-server.herokuapp.com'
      : 'https://appx-server.herokuapp.com';

  static Color colorApp1 = Color.fromRGBO(52, 130, 191, 1);

}
