import 'package:flutter/material.dart';

class Environment {
  static bool appLocalHost = true;

  static String apiUrl = appLocalHost ? 'http://192.168.1.103:3000/api' : 'http://35.224.64.47:3000/api';

  static String socketUrl = appLocalHost ? 'http://192.168.1.103:3000/' : 'http://35.224.64.47:3000';

  static Color colorApp1 = Color.fromRGBO(57, 129, 189, 1.0);

  static List<String> registroSintomas = ['Malestar General', 'Cardiología', 'Hipertensión arterial'];

  static List<String> registroGenero = ['Masculino', 'Femenino'];

  static String convertToAgo(DateTime input) {
    Duration diff = DateTime.now().difference(input);

    if (diff.inDays >= 1) {
      return 'hace ${diff.inDays} dia(s)';
    } else if (diff.inHours >= 1) {
      return 'hace ${diff.inHours} hora(s)';
    } else if (diff.inMinutes >= 1) {
      return 'hace ${diff.inMinutes} minuto(s)';
    } else if (diff.inSeconds >= 1) {
      return 'hace ${diff.inSeconds} secundo(s)';
    } else {
      return 'just now';
    }
  }
}
